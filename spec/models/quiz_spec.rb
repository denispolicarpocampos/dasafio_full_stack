require 'rails_helper'

RSpec.describe User, type: :model do

  it 'invalid with rates' do
    quiz = Quiz.new(proactivity: 1, organization: 2, flexibility: nil, team_work: 2)
    expect(quiz).to_not be_valid
  end


  it 'quiz with wrong rates' do
    quiz = Quiz.new(proactivity: 15, organization: 1, flexibility: 11, team_work: 5, efficiency: 14)
    expect(quiz).to_not be_valid
  end
end
