# frozen_string_literal: true

# Classe de modelo Usuario
class User < ApplicationRecord
  rolify
  has_secure_password

  has_many :quizzes
  has_many :evaluator, class_name: 'Quiz', foreign_key: 'evaluator_id'
  has_many :evaluated, class_name: 'Quiz', foreign_key: 'evaluated_id'

  has_many :user_relations, dependent: :destroy
  has_many :user2, class_name: 'UserRelation', foreign_key: 'user2_id', dependent: :destroy

  accepts_nested_attributes_for :user_relations, allow_destroy: true, reject_if: :reject_user

  validates :name, :last_name, :email, :password, presence: true
  validates_uniqueness_of :email, if: :same_email

  validates_length_of :password,
                      maximum: 72,
                      minimum: 8,
                      allow_nil: true,
                      allow_blank: false

  before_create :assign_default_role

  def assign_default_role
    add_role(:employe)
  end

  def reject_user(attributes)
    user_relation = UserRelation.exists?(user_id: id, user2_id: attributes[:user2_id])
    user_relation && attributes[:id].blank?
  end

  def same_email
    user = User.find_by(email: email)
    if (user.present? && id.present?) || (user.present? && id.blank?)
      true
    else
      false
    end
  end
end
