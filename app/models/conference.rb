class Conference < ApplicationRecord
  enum :status, { draft: 0, published: 1, archived: 2 }, default: :published

  validates :title, presence: { message: "не может быть пустым" }
  validates :description, presence: { message: "не может быть пустым" }
  validates :start_date, presence: { message: "не может быть пустой" }
  validates :submission_deadline, presence: { message: "не может быть пустым" }

  scope :upcoming, -> { where("submission_deadline >= ?", Date.current).order(submission_deadline: :asc) }
  scope :scopus, -> { where(is_scopus: true) }
  scope :elibrary, -> { where(is_elibrary: true) }
end
