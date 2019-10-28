require 'rails_helper'

RSpec.describe ShotsController, type: :controller do
  describe "shots#index action" do
    it "should successfully show the page" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "shots#new action" do
    it "should successfully show the new form" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "shots#create action" do
    it "should successfully create a new shot in our database" do
      post :create, params: { shot: { message: 'Hello!' } }
      expect(response).to redirect_to root_path

      shot = Shot.last
      expect(shot.message).to eq('Hello!')
    end

    it "should properly deal with validation errors" do
      post :create, params: { shot: { message: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(Shot.count).to eq 0
    end
  end
end
