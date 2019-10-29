require 'rails_helper'

RSpec.describe ShotsController, type: :controller do

  describe "shots#destroy action" do

    it "shouldn't allow users who didn't create the shot to destroy it" do
      shot = FactoryBot.create(:shot)
      user = FactoryBot.create(:user)
      sign_in user
      delete :destroy, params: { id: shot.id }
      expect(response).to have_http_status(:forbidden)
    end
    it "should not let unauthenticated users destroy a shot" do
      shot = FactoryBot.create(:shot)
      delete :destroy, params: { id: shot.id }
      expect(response).to redirect_to new_user_session_path
    end

    it "should allow user to destroy a shot" do
      shot = FactoryBot.create(:shot)
      sign_in shot.user
      delete :destroy, params: { id: shot.id }
      expect(response).to redirect_to root_path
      shot = Shot.find_by_id(shot.id)
      expect(shot).to eq nil
    end

    it "should return a 404 message if shot cannot be found with specified id" do
      user = FactoryBot.create(:user)
      sign_in user
      delete :destroy, params: { id: 'SPACEDUCK' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "shots#update action" do
    it "shouldn't let users who didn't create the shot update it" do
      shot = FactoryBot.create(:shot)
      user = FactoryBot.create(:user)
      sign_in user
      patch :update, params: { id: shot.id, shot: { message: 'wahoo' } }
      expect(response).to have_http_status(:forbidden)
    end

    it "should not let unauthenticated users update a shot" do
      shot = FactoryBot.create(:shot)
      patch :update, params: { id: shot.id, shot: { message: "Hello" } }
      expect(response).to redirect_to new_user_session_path
    end

    it "should allow users to successfully update shots" do
      shot = FactoryBot.create(:shot, message: "Initial Value")
      sign_in shot.user
      patch :update, params: { id: shot.id, shot: { message: 'Changed' } }
      expect(response).to redirect_to root_path
      shot.reload
      expect(shot.message).to eq "Changed"
    end

    it "should have http 404 error if the shot cannot be found" do
      user = FactoryBot.create(:user)
      sign_in user
      patch :update, params: { id: "YOLOSWAG", shot: { message: 'Changed' } }
      expect(response).to have_http_status(:not_found)
    end

    it "should render the edit form with an http status of unprocessable_entity" do
      shot = FactoryBot.create(:shot, message: "Initial Value")
      sign_in shot.user
      patch :update, params: { id: shot.id, shot: { message: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      shot.reload
      expect(shot.message).to eq "Initial Value"
    end
  end

  describe "shots#edit action" do
    it "shouldn't let a user who did not create the shot edit a shot" do
      shot = FactoryBot.create(:shot)
      user = FactoryBot.create(:user)
      sign_in user
      get :edit, params: { id: shot.id }
      expect(response).to have_http_status(:forbidden)
    end

    it "should not let unauthenticated users edit a shot" do
      shot = FactoryBot.create(:shot)
      get :edit, params: { id: shot.id }
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully show the edit form if the shot is found" do
      shot = FactoryBot.create(:shot)
      sign_in shot.user
      get :edit, params: { id: shot.id }
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error message if the shot is not found" do
      user = FactoryBot.create(:user)
      sign_in user
      get :edit, params: { id: "TACOS" }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "shots#show action" do
    it "should successfully show the page if the shot is found" do
      shot = FactoryBot.create(:shot)
      get :show, params: { id: shot.id }
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error if the shot is not found" do
      get :show, params: { id: "SWAG" }
      expect(response).to have_http_status(:not_found)
    end
  end



  describe "shots#index action" do
    it "should successfully show the page" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "shots#new action" do
    it "should require users to be logged in" do
      get :new
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully show the new form" do
      user = FactoryBot.create(:user)
      sign_in user

      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "shots#create action" do

    it "should require users to be logged in" do
      post :create, params: { shot: { message: "Hello!" } }
      expect(response).to redirect_to new_user_session_path
    end
    
    it "should successfully create a new shot in our database" do
      user = FactoryBot.create(:user)
      sign_in user

      post :create, params: {
        shot: {
          message: 'Hello!',
          picture: fixture_file_upload("/picture.png", 'image/png')
        }
      }

      expect(response).to redirect_to root_path

      shot = Shot.last
      expect(shot.message).to eq('Hello!')
      expect(shot.user).to eq(user)
    end

    it "should properly deal with validation errors" do
      user = FactoryBot.create(:user)
      sign_in user

      post :create, params: { shot: { message: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(Shot.count).to eq Shot.count
    end
  end
end
