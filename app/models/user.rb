class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Ассоциации
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_conferences, through: :bookmarks, source: :conference

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
