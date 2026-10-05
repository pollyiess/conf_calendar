class PagesController < ApplicationController
  def home
    @conferences = Conference.published.upcoming
  end
end