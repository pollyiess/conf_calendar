require "rails_helper"

RSpec.describe "Сценарии работы с конференциями", type: :request do
  let(:author) { create(:user) }
  let(:reader) { create(:user) }

  # Параметры для успешного создания конференции
  let(:valid_params) do
    { conference: {
      title: "Конференция по ИИ", description: "Описание", location: "Казань",
      start_date: Date.current + 30, end_date: Date.current + 32,
      submission_deadline: Date.current + 15, website_url: "https://example.com",
      is_scopus: "1", is_elibrary: "0"
    } }
  end

  describe "Happy path" do
    context "когда автор создаёт конференцию, а другой пользователь её использует" do
      it "проходит весь путь: создание → список → избранное → профиль" do
        sign_in author
        # 1. Создание
        expect { post conferences_path, params: valid_params }.to change(Conference, :count).by(1)
        conference = Conference.last
        expect(conference.creator).to eq(author)

        sign_out author
        sign_in reader

        # 2. Просмотр в списке
        get conferences_path
        expect(response.body).to include("Конференция по ИИ")

        # 3. Добавление в избранное
        expect { post conference_bookmark_path(conference) }
          .to change { reader.bookmarked_conferences.count }.by(1)

        # 4. Просмотр в профиле
        get profile_path
        expect(response.body).to include("Конференция по ИИ")
      end
    end

    context "когда пользователь применяет фильтры" do
      let!(:scopus)   { create(:conference, title: "Про Scopus", is_scopus: true, location: "Москва") }
      let!(:elibrary) { create(:conference, title: "Про eLibrary", is_elibrary: true, location: "Казань") }

      it "фильтрует по индексации" do
        get conferences_path, params: { indexing: "scopus" }
        expect(response.body).to include("Про Scopus")
        expect(response.body).not_to include("Про eLibrary")
      end

      it "фильтрует по городу" do
        get conferences_path, params: { location: "Казань" }
        expect(response.body).to include("Про eLibrary")
        expect(response.body).not_to include("Про Scopus")
      end
    end
  end

  describe "Ветка 1: гость без авторизации" do
    it "не может создать конференцию и перенаправляется на вход" do
      expect { post conferences_path, params: valid_params }.not_to change(Conference, :count)
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "Ветка 2: пользователь без прав правит чужую конференцию" do
    let!(:conference) { create(:conference, creator: author, title: "Исходное название") }

    before { sign_in reader }

    it "не может изменить чужую конференцию и получает ошибку" do
      patch conference_path(conference), params: { conference: { title: "Взлом" } }
      expect(response).to redirect_to(conference_path(conference))
      expect(flash[:alert]).to be_present
      expect(conference.reload.title).to eq("Исходное название")
    end
  end

  describe "Ветка 3: некорректные данные при создании" do
    before { sign_in author }

    it "не принимает опасную ссылку (javascript:)" do
      bad = valid_params.deep_merge(conference: { website_url: "javascript:alert(1) https://example.com" })
      expect { post conferences_path, params: bad }.not_to change(Conference, :count)
      expect(response).to have_http_status(:unprocessable_content)
    end

    it "не принимает дедлайн позже даты начала" do
      bad = valid_params.deep_merge(conference: { submission_deadline: Date.current + 40 })
      expect { post conferences_path, params: bad }.not_to change(Conference, :count)
      expect(response).to have_http_status(:unprocessable_content)
    end
  end
end
