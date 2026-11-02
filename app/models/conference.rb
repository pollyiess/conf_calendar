class Conference < ApplicationRecord
  CATALOG_ANY = "any".freeze

  after_create_commit  :broadcast_to_catalog
  after_destroy_commit :broadcast_removal_from_catalog
  belongs_to :creator, class_name: "User", optional: true, inverse_of: :created_conferences
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_by_users, through: :bookmarks, source: :user

  enum :status, { draft: 0, published: 1 }, default: :published

  validates :title, :description, :location, :start_date, :end_date, :submission_deadline, presence: true
  validates :title, length: { maximum: 200 }
  validates :website_url, presence: true,
            format: { with: /\Ahttps?:\/\/\S+\z/i, message: "должна начинаться с http:// или https://" }
  validate :end_date_after_start_date
  validate :submission_deadline_before_start_date

  scope :upcoming, -> { where("submission_deadline >= ?", Date.current).order(start_date: :asc) }
  scope :scopus, -> { where(is_scopus: true) }
  scope :elibrary, -> { where(is_elibrary: true) }
  scope :in_location, ->(loc) { loc.present? ? where(location: loc) : all }
  scope :indexed_in, ->(kind) {
    case kind
    when "scopus" then scopus
    when "elibrary" then elibrary
    else all
    end
  }

  def self.catalog_stream(indexing: nil, location: nil)
    indexing_key = %w[scopus elibrary].include?(indexing.to_s) ? indexing.to_s : CATALOG_ANY
    location_key = location.present? ? Digest::SHA1.hexdigest(location.to_s)[0, 16] : CATALOG_ANY
    [ "catalog", indexing_key, location_key ]
  end

  def listed_in_catalog?
    published? && submission_deadline >= Date.current
  end

  def catalog_streams
    indexings = [ nil ]
    indexings << "scopus"   if is_scopus?
    indexings << "elibrary" if is_elibrary?

    indexings.product([ nil, location ]).map do |indexing, loc|
      Conference.catalog_stream(indexing: indexing, location: loc)
    end.uniq
  end

  def self.filtered(params)
    published.upcoming.indexed_in(params[:indexing]).in_location(params[:location])
  end

  def registration_open?
    submission_deadline >= Date.current
  end

  def days_until_deadline
    return 0 if submission_deadline < Date.current
    (submission_deadline - Date.current).to_i
  end

  def indexing_badge
    if is_scopus && is_elibrary then "Scopus & eLibrary"
    elsif is_scopus then "Scopus"
    elsif is_elibrary then "eLibrary"
    else "Без индексации"
    end
  end

  def owned_by?(user)
    user.present? && creator_id.present? && creator_id == user.id
  end

  private

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?
    errors.add(:end_date, "должна быть не раньше даты начала") if end_date < start_date
  end

  def submission_deadline_before_start_date
    return if submission_deadline.blank? || start_date.blank?
    errors.add(:submission_deadline, "должен быть не позже даты начала") if submission_deadline > start_date
  end

  def broadcast_to_catalog
    return unless listed_in_catalog?

    catalog_streams.each do |stream|
      broadcast_prepend_to(*stream, target: "conferences_grid",
                           partial: "conferences/catalog_item",
                           locals: { conference: self, highlight: true })
    end
  end

  def broadcast_removal_from_catalog
    catalog_streams.each { |stream| broadcast_remove_to(*stream) }
  end
end
