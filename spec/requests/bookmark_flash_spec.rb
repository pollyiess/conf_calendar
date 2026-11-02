require "rails_helper"

RSpec.describe "Избранное и плашки уведомлений", type: :request do
  let(:user) { create(:user) }
  let!(:conference) { create(:conference) }
  let(:turbo_headers) { { "Accept" => "text/vnd.turbo-stream.html" } }

  describe "Happy path" do
    context "когда пользователь добавляет конференцию в избранное через Turbo" do
      before { sign_in user }

      it "меняет кнопку и показывает плашку на текущей странице" do
        post conference_bookmark_path(conference), headers: turbo_headers

        expect(response).to have_http_status(:ok)
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
        expect(response.body).to include('target="bookmark_button"')
        expect(response.body).to include('target="flash"')
        expect(response.body).to include("Добавлено в избранное")
        expect(response.body).to include("Убрать из избранного")
        expect(user.bookmarked?(conference)).to be true
      end
    end

    context "когда пользователь убирает конференцию из избранного" do
      before do
        sign_in user
        user.bookmark!(conference)
      end

      it "возвращает кнопку и показывает плашку об удалении" do
        delete conference_bookmark_path(conference), headers: turbo_headers

        expect(response.body).to include("Убрано из избранного")
        expect(response.body).to include("В избранное")
        expect(user.bookmarked?(conference)).to be false
      end
    end

    context "когда автор удаляет свою конференцию" do
      let!(:own) { create(:conference, creator: user) }

      before { sign_in user }

      it "возвращается на главную и видит плашку" do
        delete conference_path(own)

        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include("Конференция удалена")
      end
    end
  end

  describe "Ветка 1: гость нажимает «В избранное»" do
    it "попадает на вход с плашкой и закладка не создаётся" do
      post conference_bookmark_path(conference), headers: turbo_headers

      expect(response).to redirect_to(new_user_session_path)
      follow_redirect!
      expect(response.body).to include("Вам необходимо войти в систему или зарегистрироваться.")
      expect(Bookmark.count).to eq(0)
    end
  end

  describe "Ветка 2: запрос без Turbo" do
    it "делает редирект на страницу конференции с плашкой" do
      sign_in user
      post conference_bookmark_path(conference)

      expect(response).to redirect_to(conference_path(conference))
      follow_redirect!
      expect(response.body).to include("Добавлено в избранное")
    end
  end

  describe "Ветка 3: чужая конференция" do
    it "нельзя удалить, плашка с отказом, конференция остаётся" do
      sign_in user
      expect { delete conference_path(conference) }.not_to change(Conference, :count)
      expect(flash[:alert]).to be_present
    end
  end
end
