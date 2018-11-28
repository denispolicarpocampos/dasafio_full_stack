# frozen_string_literal: true

# Classe de modelo UserRelation
class UserRelation < ApplicationRecord
  belongs_to :user
  belongs_to :user2, class_name: 'User', foreign_key: 'user2_id'
end
