class BookmarksController < ApplicationController
  before_action :remember_conference_for_login, unless: :user_signed_in?
  before_action :authenticate_user!
  before_action :set_conference

  def create
    current_user.bookmark!(@conference)
    respond_with_flash("Добавлено в избранное")
  end

  def destroy
    current_user.unbookmark!(@conference)
    respond_with_flash("Убрано из избранного")
  end

  private

  def set_conference
    @conference = Conference.find(params[:conference_id])
  end

  def respond_with_flash(message)
    respond_to do |format|
      format.turbo_stream do
        flash.now[:notice] = message
        render :update
      end
      format.html do
        redirect_back fallback_location: conference_path(@conference), notice: message, status: :see_other
      end
    end
  end

  def remember_conference_for_login
    store_location_for(:user, conference_path(params[:conference_id]))
  end
end
