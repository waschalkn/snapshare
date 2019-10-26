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
      expect(response).to eq('Hello!')
    end
  end
end
