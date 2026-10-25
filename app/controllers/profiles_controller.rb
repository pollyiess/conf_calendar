class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @created = current_user.created_conferences.order(:start_date)
    @bookmarked = current_user.bookmarked_conferences.order(:start_date)
  end
end
