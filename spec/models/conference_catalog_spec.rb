require "rails_helper"

RSpec.describe Conference, type: :model do
  include Turbo::Streams::StreamName

  def stream_for(**filters)
    stream_name_from(Conference.catalog_stream(**filters))
  end

  describe "живой каталог" do
    context "когда создана новая конференция" do
      it "рассылает карточку в общий поток" do
        expect { create(:conference) }.to have_broadcasted_to(stream_for).exactly(:once)
      end

      it "рассылает в поток своей индексации и города" do
        expect { create(:conference, is_scopus: true, location: "Казань") }
          .to have_broadcasted_to(stream_for(indexing: "scopus", location: "Казань")).exactly(:once)
      end
    end
  end
end
