require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like 'votable' do
    let(:model)   { create(described_class.to_s.underscore.to_sym, user: user) }
  end

  it_behaves_like 'commentable' do
    let(:model)   { create(described_class.to_s.underscore.to_sym, user: user) }
  end
  
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should belong_to(:user) }
  it { should have_one(:badge).dependent(:destroy) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :badge }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'reputation' do
    let(:question) { build(:question) }

    it 'calls ReputationJob' do
      expect(ReputationJob).to receive(:perform_later).with(question)
      question.save!
    end
  end
  
end
