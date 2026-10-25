class Conference < ApplicationRecord
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
end
