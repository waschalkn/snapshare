require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe "comments#create action" do
    it "should allow users to create comments on shots" do
      shot = FactoryBot.create(:shot)
      user = FactoryBot.create(:user)
      sign_in user

      post :create, params: { shot_id: shot.id, comment: { message: 'awesome shot' } }
      expect(response).to redirect_to root_path
      expect(shot.comments.length).to eq 1
      expect(shot.comments.first.message).to eq "awesome shot"
    end

    it "should require a user to be logged in to comment on a shot" do
      shot = FactoryBot.create(:shot)
      post :create, params: { shot_id: shot.id, comment: { message: 'awesome shot' } }
      expect(response).to redirect_to new_user_session_path
    end

    it "should return http status code of not found if the shot isn't found" do
      user = FactoryBot.create(:user)
      sign_in user
      post :create, params: { shot_id: 'YOLOSWAG', comment: { message: 'awesome shot' } }
      expect(response).to have_http_status :not_found
    end
  end
end
