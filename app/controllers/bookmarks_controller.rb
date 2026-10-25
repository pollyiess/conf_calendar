class BookmarksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conference

  def create
    current_user.bookmark!(@conference)
    redirect_back fallback_location: conference_path(@conference), notice: "Добавлено в избранное"
  end

  def destroy
    current_user.unbookmark!(@conference)
    redirect_back fallback_location: conference_path(@conference), notice: "Убрано из избранного", status: :see_other
  end

  private

  def set_conference
    @conference = Conference.find(params[:conference_id])
  end
end
