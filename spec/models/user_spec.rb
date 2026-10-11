require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { User.create!(email: "student@example.com", password: "password123") }
  let(:conference) do
    Conference.create!(
      title: "Международная конференция",
      description: "Описание",
      location: "Москва",
      start_date: Date.today + 10.days,
      end_date: Date.today + 12.days,
      submission_deadline: Date.today + 5.days,
      website_url: "https://example.com"
    )
  end

  describe 'Бизнес-логика работы с избранным' do
    context 'когда пользователь сохраняет конференцию' do
      it 'успешно добавляет её в список закладок' do
        expect { user.bookmark!(conference) }.to change { user.bookmarked_conferences.count }.by(1)
      end

      it 'подтверждает наличие закладки' do
        user.bookmark!(conference)
        expect(user.bookmarked?(conference)).to be true
      end
    end

    context 'когда конференция уже в избранном' do
      before { user.bookmark!(conference) }

      it 'не создает дубликатов при повторном добавлении' do
        expect { user.bookmark!(conference) }.not_to change { user.bookmarked_conferences.count }
      end

      it 'успешно удаляет конференцию из избранного' do
        expect { user.unbookmark!(conference) }.to change { user.bookmarked_conferences.count }.by(-1)
        expect(user.bookmarked?(conference)).to be false
      end
    end
  end
end
