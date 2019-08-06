require 'rails_helper'

RSpec.describe Vote, type: :model do

  it { should belong_to(:votable) }
  it { should belong_to(:user) }

  describe 'check validate' do
    let(:user) { create(:user) } 
    let(:question) { create(:question, user: user) }

    it 'validate author not votes' do
      question.voteup(user)
      
      expect { question.voteup(user) }.to_not change(Vote, :count)
    end
  end
end
