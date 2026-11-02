require "rails_helper"

RSpec.describe "Живой каталог и фильтр во фрейме", type: :request do
  include Turbo::Streams::StreamName
  let(:author) { create(:user) }

  it "возвращает только фрейм со списком при запросе из фрейма" do
    get conferences_path, headers: { "Turbo-Frame" => "conferences_list" }
    expect(response.body).to match(/<turbo-frame[^>]*id="conferences_list"/)
    expect(response.body).not_to include("<header")
  end
end
