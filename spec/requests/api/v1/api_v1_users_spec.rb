require 'rails_helper'
require 'rspec/json_expectations'

RSpec.describe 'Api::V1::Users', type: :request do

  describe 'GET /api/v1/users?page=:page' do
    context 'Authenticate if admin' do
      let(:admin) { create(:admin) }

      before { 15.times { create(:user) } }

      it do
        get "/api/v1/users?page=1", headers: header_with_authentication(admin)
        expect(response).to have_http_status(:success)
      end

      it 'returns 15 elemments on first page' do
        get "/api/v1/users?page=1", headers: header_with_authentication(admin)
        expect(json.count).to eql(15)
      end

    end

    context 'Authenticate if user' do
      let(:user) { create(:user) }

      before { 15.times { create(:user) } }

      it do
        get "/api/v1/users?page=1", headers: header_with_authentication(user)
        expect(response).to have_http_status(:forbidden)
      end

    end
  end

  describe 'GET /api/v1/users/:id' do
    context 'when user exists' do
      let(:user) { create(:user) }

      context 'same user' do

        before { get "/api/v1/users/#{user.id}", headers: header_with_authentication(user) }

        it { expect(response).to have_http_status(:success) }
      end

      context 'other user' do
        let(:user) { create(:user) }
        let(:user2) { create(:user) }

        before { get "/api/v1/users/#{user2.id}", headers: header_with_authentication(user) }

        it { expect(response).to have_http_status(:forbidden) }
      end
    end
  end

  
  describe 'GET /api/v1/users/current' do
    context 'Unauthenticated' do
      it_behaves_like :deny_without_authorization, :get, '/api/v1/users/current'
    end

    context 'Authenticated' do
      let(:user) { create(:user) }
      before do
        get '/api/v1/users/current/', headers: header_with_authentication(user)
      end

      it { expect(response).to have_http_status(:success) }

    end
  end

  describe 'DELETE /api/v1/users/:id' do
    context 'Unauthenticated' do
      it_behaves_like :deny_without_authorization, :delete, '/api/v1/users/-1'
    end

    context 'Authenticated' do
      context 'User is admin' do
        context 'User exists' do
          context 'Owner of resource' do
            before { @user = create(:admin) }
            
            it do
              delete "/api/v1/users/#{@user.id}", headers: header_with_authentication(@user)
              expect(response).to have_http_status(:forbidden)
            end

          end

          context 'Not resource owner' do
            let(:user) { create(:admin) }

            let(:other_user) { create(:user) }

            it do
              delete "/api/v1/users/#{other_user.id}", headers: header_with_authentication(user)
              expect(response).to have_http_status(:no_content)
            end
          end
        end
      end
      
      context 'User is not admin' do
        context 'User exists' do
          context 'Owner of resource' do
            before { @user = create(:user) }
            
            it do
              delete "/api/v1/users/#{@user.id}", headers: header_with_authentication(@user)
              expect(response).to have_http_status(:forbidden)
            end
          end

          context 'Not resource owner' do
            let(:user) { create(:user) }

            let(:other_user) { create(:user) }

            it do
              delete "/api/v1/users/#{other_user.id}", headers: header_with_authentication(user)
              expect(response).to have_http_status(:forbidden)
            end

          end
        end
      end

      context 'User dont exist' do
        let(:user) { create(:user) }
        let(:user_id) { -1 }
        before { delete "/api/v1/users/#{user_id}", headers: header_with_authentication(user) }
        it { expect(response).to have_http_status(:not_found) }
      end
    end
  end

  describe 'POST /api/v1/users' do
    context 'Valid params' do
      let(:user_params) { attributes_for(:admin) }
      let(:user) { create(:user) }

      it 'return created' do
        post '/api/v1/users/', params: { user: user_params, user2: user }
        expect(response).to have_http_status(:created)
      end

      it 'returns right user in json' do
        post '/api/v1/users/', params: { user: user_params }
        expect(json).to include_json(user_params.except(:password))
      end

      it 'create user' do
        expect do
          post '/api/v1/users/', params: { user: user_params }
        end.to change { User.count }.by(1)
      end
    end

    context 'Invalid params' do
      let(:user_params) { {foo: :bar} }

      before { post '/api/v1/users/', params: { user: user_params } }

      it { expect(response).to have_http_status(:unprocessable_entity) }
    end
  end

  describe 'PUT /api/v1/users/:id' do
    context 'Unauthenticated' do
      it_behaves_like :deny_without_authorization, :put, '/api/v1/users/-1'
    end

    context 'Authenticated' do
      context 'Only infos about user' do
        let(:user) { create(:user) }
        let(:other_user) { create(:user) }
        let(:user_params) { attributes_for(:user) }

        before do
          put "/api/v1/users/#{other_user.id}", params: {user: user_params }, headers: header_with_authentication(user)
        end

        it { expect(response).to have_http_status(:forbidden) }
      end
    end
    context 'Infos about forms' do
      let(:admin) {create(:admin) }
      let(:user) {create(:user) }
      let(:user2) {create(:user) }
      let(:user_params) {attributes_for(:user) }

      before do
        @user_relations_attributes = [{user_id: user, user2_id: user2.id}]
        put "/api/v1/users/#{user.id}", params: { user: user_params.merge(user_relations_attributes: @user_relations_attributes) }, headers: header_with_authentication(admin)
      end

      it { expect(UserRelation.count).to eq(1) }
      it { expect(response).to have_http_status(:success) }
    end
  end
end