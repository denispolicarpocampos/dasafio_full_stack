require 'rails_helper'

RSpec.describe User, type: :model do
  it 'user employe' do
    user = create(:user)
    expect(user.has_role? 'employe').to be_truthy
  end

  it 'invalid without name, lastname, email, password' do
    user = User.new(name: nil, last_name: nil, email: nil, password: nil)
    expect(user).to_not be_valid
  end

  it 'unique email creating new user' do
    user = create(:user)
    user2 = User.new(name: 'teste', last_name: 'teste', email: user.email, password: '12345678')
    expect(user2).to_not be_valid
  end


end
