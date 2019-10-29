class ShotsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  
  def index
    @shots = Shot.all
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
    return render_not_found(:forbidden) if @shot.user != current_user
  end

  def update
    @shot = Shot.find_by_id(params[:id])
    return render_not_found if @shot.blank?
    return render_not_found(:forbidden) if @shot.user != current_user

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
    return render_not_found(:forbidden) if @shot.user != current_user

    @shot.destroy
    redirect_to root_path
  end

  private

  def shot_params
    params.require(:shot).permit(:picture, :message)
  end
  
end
