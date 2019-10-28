class ShotsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  
  def index

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

  private

  def shot_params
    params.require(:shot).permit(:message)
  end
end
