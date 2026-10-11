class Conference < ApplicationRecord
  # Ассоциации
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_by_users, through: :bookmarks, source: :user

  # Валидации
  validates :title, :description, :location, :start_date, :end_date, :submission_deadline, presence: true
  validates :website_url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: "должен быть корректным URL" }
  validate :end_date_after_start_date
  validate :submission_deadline_before_start_date

  # Скоупы
  scope :upcoming, -> { where("submission_deadline >= ?", Date.current).order(start_date: :asc) }
  scope :scopus, -> { where(is_scopus: true) }
  scope :elibrary, -> { where(is_elibrary: true) }

  # Методы бизнес-логики
  def registration_open?
    submission_deadline >= Date.current
  end

  def days_until_deadline
    return 0 if submission_deadline < Date.current

    (submission_deadline - Date.current).to_i
  end

  def indexing_badge
    if is_scopus && is_elibrary
      "Scopus & eLibrary"
    elsif is_scopus
      "Scopus"
    elsif is_elibrary
      "eLibrary"
    else
      "Без индексации"
    end
  end

  private

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    if end_date < start_date
      errors.add(:end_date, "должна быть позже даты начала")
    end
  end

  def submission_deadline_before_start_date
    return if submission_deadline.blank? || start_date.blank?

    if submission_deadline > start_date
      errors.add(:submission_deadline, "должен быть раньше или равен дате начала")
    end
  end
end
