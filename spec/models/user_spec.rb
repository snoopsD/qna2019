require 'rails_helper'

RSpec.describe User, type: :model do

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:badges).through(:answers) }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:subscribes).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  
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

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    let(:service) { double('Services::FindForOauth') }

    it 'calss Services::FindForOauth' do
      expect(Services::FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end

  describe '.subscribed_for?' do
    let(:user)       { create(:user) }
    let(:other_user) { create(:user) }
    let!(:question)  { create(:question, user: user) }

    it 'should return true if user already subscribed to the question' do
      expect(user.subscribed_for?(question)).to be_truthy
    end

    it 'should return false if user is not subscribed to the question' do
      expect(other_user.subscribed_for?(question)).to be_falsey
    end
  end
end
