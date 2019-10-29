class ShotsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  
  def index

  end

  def show
    @shot = Shot.find_by_id(params[:id])
    return render_not_found if @shot.blank?
  end

  def new
    @shot = Shot.new
  end

  def create
    @shot = current_user.shots.create(shot_params)
    if @shot.valid?
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @shot = Shot.find_by_id(params[:id])
    return render_not_found if @shot.blank?
  end

  def update
    @shot = Shot.find_by_id(params[:id])
    return render_not_found if @shot.blank?

    @shot.update_attributes(shot_params)

    if @shot.valid?
    redirect_to root_path
    else
      return render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @shot = Shot.find_by_id(params[:id])
    return render_not_found if @shot.blank?
    @shot.destroy
    redirect_to root_path
  end

  private

  def shot_params
    params.require(:shot).permit(:message)
  end

  def render_not_found
    render plain: 'Not Found :(', status: :not_found
  end
end
