class ShotsController < ApplicationController
  def index

  end

  def new
    @shot = Shot.new
  end
end
