class ConferencesController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_conference, only: %i[show edit update destroy]
  before_action :require_owner!, only: %i[edit update destroy]

  def index
    @conferences = Conference.filtered(filter_params)
    @locations = Conference.published.distinct.order(:location).pluck(:location)
  end

  def show; end

  def new
    @conference = Conference.new
  end

  def create
    @conference = current_user.created_conferences.build(conference_params)
    if @conference.save
      redirect_to conference_path(@conference), notice: "Конференция создана"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @conference.update(conference_params)
      redirect_to conference_path(@conference), notice: "Изменения сохранены"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @conference.destroy
    redirect_to profile_path, notice: "Конференция удалена", status: :see_other
  end

  private

  def set_conference
    @conference = Conference.find(params[:id])
  end

  def require_owner!
    return if @conference.owned_by?(current_user)

    redirect_to conference_path(@conference), alert: "Редактировать конференцию может только её автор"
  end

  def filter_params
    params.permit(:indexing, :location)
  end

  def conference_params
    params.require(:conference).permit(:title, :description, :location, :start_date, :end_date,
                                       :submission_deadline, :website_url, :is_scopus, :is_elibrary)
  end
end
