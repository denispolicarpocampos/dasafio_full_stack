require 'rails_helper'
require 'rspec/json_expectations'

RSpec.describe 'Api::V1::Quizzes', type: :request do

  describe 'GET /api/v1/quizzes?page=:page' do
    context 'Unauthenticated' do
      it_behaves_like :deny_without_authorization, :get, '/api/v1/quizzes/'
    end
    context 'Authenticate if admin' do
      let(:admin) { create(:admin) }
      let(:evaluator) { create(:user)}
      let(:evaluated) { create(:user)}
      let(:quiz) { create(:quiz, user: admin, evaluator: evaluator, evaluated_id: evaluated.id)}

      it do
        get "/api/v1/users?page=1", headers: header_with_authentication(admin)
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'GET /api/v1/quizzes/:id' do

    context 'user admin' do
      let(:admin) { create(:admin) }
      let(:evaluator) { create(:user)}
      let(:evaluated) { create(:user)}
      let(:quiz) { create(:quiz, user_id: admin.id, evaluator_id: evaluator.id, evaluated_id: evaluated.id)}

      before { get "/api/v1/quizzes/#{quiz.id}", headers: header_with_authentication(admin) }
      it { expect(response).to have_http_status(:success) }
    end
    context 'user employe' do
      context 'evaluator show quiz' do
        let(:admin) { create(:admin) }
        let(:evaluator) { create(:user)}
        let(:evaluated) { create(:user)}
        let(:quiz) { create(:quiz, user_id: admin.id, evaluator_id: evaluator.id, evaluated_id: evaluated.id)}

        before { get "/api/v1/quizzes/#{quiz.id}", headers: header_with_authentication(evaluator) }
        it { expect(response).to have_http_status(:success) }
      end

      context 'other user show quiz' do
        let(:admin) { create(:admin) }
        let(:user) { create(:user) }
        let(:evaluator) { create(:user)}
        let(:evaluated) { create(:user)}
        let(:quiz) { create(:quiz, user_id: admin.id, evaluator_id: evaluator.id, evaluated_id: evaluated.id)}

        before { get "/api/v1/quizzes/#{quiz.id}", headers: header_with_authentication(user) }
        it { expect(response).to have_http_status(:forbidden) }
      end
    end
  end

  describe 'DELETE /api/v1/quizzes/:id' do
    context 'Unauthenticated' do
      it_behaves_like :deny_without_authorization, :delete, '/api/v1/quizzes/-1'
    end

    context 'Authenticated' do
      context 'User is admin' do
        context 'User exists' do
          context 'Admin and tries to delete' do
            let(:admin) { create(:admin) }
            let(:evaluator) { create(:user)}
            let(:evaluated) { create(:user)}
            let(:quiz) { create(:quiz, user_id: admin.id, evaluator_id: evaluator.id, evaluated_id: evaluated.id)}
            it do
              delete "/api/v1/quizzes/#{quiz.id}", headers: header_with_authentication(admin)
              expect(response).to have_http_status(:no_content)
            end
          end

          context 'Employe tries to delete' do
            let(:admin) { create(:admin) }
            let(:user) { create(:user)}
            let(:evaluator) { create(:user)}
            let(:evaluated) { create(:user)}
            let(:quiz) { create(:quiz, user_id: admin.id, evaluator_id: evaluator.id, evaluated_id: evaluated.id)}
            it do
              delete "/api/v1/quizzes/#{quiz.id}", headers: header_with_authentication(user)
              expect(response).to have_http_status(:forbidden)
            end
          end
        end
      end
    end
  end

  describe 'POST /api/v1/quizzes' do
    context 'Unauthenticated' do
      it_behaves_like :deny_without_authorization, :post, '/api/v1/quizzes/'
    end
    context 'Valid params' do
      let(:admin) { create(:admin) }
      let(:user) { create(:user)}
      let(:evaluator) { create(:user)}
      let(:evaluated) { create(:user)}
      let!(:user_relation) { create(:user_relation, user: evaluator, user2: evaluated)}

      let(:quiz_params) { attributes_for(:quiz, user_id: admin.id, evaluated_id: evaluated.id, evaluator_id: evaluator.id) }

      it 'return created' do
        post '/api/v1/quizzes/', params: { quiz: quiz_params }, headers: header_with_authentication(admin)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'User is not admin' do
      let(:user) { create(:user)}
      let(:evaluator) { create(:user)}
      let(:evaluated) { create(:user)}
      let!(:user_relation) { create(:user_relation, user: evaluator, user2: evaluated)}

      let(:quiz_params) { attributes_for(:quiz, user_id: user.id, evaluated_id: evaluated.id, evaluator_id: evaluator.id) }

      it 'return created' do
        post '/api/v1/quizzes/', params: { quiz: quiz_params }, headers: header_with_authentication(user)
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'PUT /api/v1/quizzes/:id' do
    context 'Unauthenticated' do
      it_behaves_like :deny_without_authorization, :put, '/api/v1/users/-1'
    end

    context 'Authenticated' do
      context 'Just infos about user' do


        let(:admin) { create(:admin) }
        let(:evaluator) { create(:user)}
        let(:evaluated) { create(:user)}
        let!(:user_relation) { create(:user_relation, user: evaluator, user2: evaluated)}
        let!(:quiz) { create(:quiz, user_id: admin.id, evaluator_id: evaluator.id, evaluated_id: evaluated.id)}

        let(:quiz_params) { attributes_for(:quiz, user_id: admin.id, evaluated_id: evaluated.id, evaluator_id: evaluator.id) }

        before do
          put "/api/v1/quizzes/#{quiz.id}", params: {quiz: quiz_params }, headers: header_with_authentication(admin)
        end

        it { expect(response).to have_http_status(:ok) }
      end
    end
  end
end