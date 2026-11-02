class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_conferences, through: :bookmarks, source: :conference
  has_many :created_conferences, class_name: "Conference", foreign_key: :creator_id,
           inverse_of: :creator, dependent: :nullify

  def bookmark!(conference)
    bookmarks.find_or_create_by!(conference: conference)
  rescue ActiveRecord::RecordNotUnique
    nil
  end

  def unbookmark!(conference)
    bookmarks.where(conference: conference).destroy_all
  end

  def bookmarked?(conference)
    bookmarks.exists?(conference_id: conference.id)
  end
end
