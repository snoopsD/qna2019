require 'rails_helper'

RSpec.describe User, type: :model do

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:questions).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  let(:user) { create(:user) }

  describe 'metod author' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it 'check user is author of question' do
      expect(user).to be_author(question)
    end

    it 'check user is not author of question' do
      expect(other_user).not_to be_author(question)
    end

  end
end
