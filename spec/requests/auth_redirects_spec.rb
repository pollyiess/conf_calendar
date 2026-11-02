require "rails_helper"

RSpec.describe "Вход, выход и возврат на нужную страницу", type: :request do
  let(:user) { create(:user) }
  let!(:conference) { create(:conference) }
  let(:turbo_headers) { { "Accept" => "text/vnd.turbo-stream.html" } }

  def log_in(account)
    post user_session_path, params: { user: { email: account.email, password: "password123" } }
  end

  describe "Happy path" do
    context "когда гость хочет создать конференцию" do
      it "отправляет на вход, а после входа возвращает на форму создания" do
        get new_conference_path
        expect(response).to redirect_to(new_user_session_path)

        log_in(user)
        expect(response).to redirect_to(new_conference_path)
      end
    end

    context "когда гость нажимает «В избранное»" do
      it "отправляет на вход, а после входа возвращает на страницу конференции" do
        post conference_bookmark_path(conference), headers: turbo_headers
        expect(response).to redirect_to(new_user_session_path)

        log_in(user)
        expect(response).to redirect_to(conference_path(conference))
        expect(Bookmark.count).to eq(0)
      end
    end

    context "когда пользователь выходит из системы" do
      before { sign_in user }

      it "попадает на страницу входа с плашкой" do
        delete destroy_user_session_path

        expect(response).to redirect_to(new_user_session_path)
        follow_redirect!
        expect(response.body).to include("Выход из системы выполнен.")
      end
    end
  end

  describe "Ветка 1: обычный вход" do
    it "ведёт на главную, если гость ничего не пытался открыть" do
      get new_user_session_path
      log_in(user)

      expect(response).to redirect_to(root_path)
    end
  end

  describe "Ветка 2: неверный пароль" do
    it "остаётся на форме входа с ошибкой" do
      post user_session_path, params: { user: { email: user.email, password: "wrong" } }

      expect(response).to have_http_status(422)
    end
  end
end
