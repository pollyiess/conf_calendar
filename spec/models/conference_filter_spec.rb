require "rails_helper"

RSpec.describe Conference, type: :model do
  describe ".filtered" do
    context "когда у конференции прошёл дедлайн" do
      let!(:expired) do
        create(:conference, submission_deadline: Date.current - 1,
                            start_date: Date.current + 5, end_date: Date.current + 6)
      end
      let!(:active) { create(:conference) }

      it "скрывает её из каталога" do
        expect(Conference.filtered({})).to contain_exactly(active)
      end
    end
  end

  describe "#owned_by?" do
    let(:owner)      { create(:user) }
    let(:conference) { create(:conference, creator: owner) }

    it "возвращает true для автора" do
      expect(conference.owned_by?(owner)).to be true
    end

    it "возвращает false для чужого пользователя или гостя" do
      expect(conference.owned_by?(create(:user))).to be false
      expect(conference.owned_by?(nil)).to be false
    end
  end
end
