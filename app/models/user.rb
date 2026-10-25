class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, format: { with: /\A[^@\s]+@[^@\s]+\.[^@\s]+\z/, message: "некорректный формат" }

  # Ассоциации
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_conferences, through: :bookmarks, source: :conference
  has_many :created_conferences, class_name: "Conference", foreign_key: :creator_id,
         inverse_of: :creator, dependent: :nullify

  # Валидации
  validates :email, presence: true, uniqueness: true

  # Методы бизнес-логики
  def bookmark!(conference)
    bookmarked_conferences << conference unless bookmarked?(conference)
  end

  def unbookmark!(conference)
    bookmarked_conferences.delete(conference)
  end

  def bookmarked?(conference)
    bookmarked_conferences.exists?(conference.id)
  end
end
