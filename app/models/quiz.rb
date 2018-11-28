# frozen_string_literal: true

# Classe de modelo Questionario
class Quiz < ApplicationRecord
  belongs_to :user
  belongs_to :evaluator, class_name: 'User', foreign_key: 'evaluator_id'
  belongs_to :evaluated, class_name: 'User', foreign_key: 'evaluated_id'

  validates :proactivity, :organization, :flexibility,
  :efficiency, :team_work, presence: false, on: :create

  validates :proactivity, :organization, :flexibility,
  :efficiency, :team_work, presence: true, on: :update, if: :employe?

  validates_numericality_of :proactivity, :organization, :flexibility,
  :efficiency, :team_work, greater_than_or_equal_to: 0, less_than_or_equal_to: 10, on: :update
  
  validate :month_year_unique, on: :create
  
  def employe?
    evaluator.has_role? :employe
  end

  def month_year_unique
    quiz = Quiz.exists?(evaluator_id: evaluator_id,
                        evaluated_id: evaluated_id,
                        created_at: Time.now.beginning_of_month..Time.now.end_of_month)

    errors.add(:created_at, 'a quiz in the same month') if quiz.present?
  end
end
