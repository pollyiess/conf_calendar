class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :conference

  # Валидация уникальности связи
  validates :user_id, uniqueness: { scope: :conference_id, message: "уже добавил эту конференцию в избранное" }
end
