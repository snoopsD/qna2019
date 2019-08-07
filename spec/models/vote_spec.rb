require 'rails_helper'

RSpec.describe Vote, type: :model do

  it { should belong_to(:votable) }
  it { should belong_to(:user) }
  it { should validate_inclusion_of(:score).in_array([-1, 1]) }
  it { should validate_uniqueness_of(:user_id).scoped_to([:votable_id, :votable_type]) }

  describe 'check validate' do
    let(:user) { create(:user) } 
    let(:question) { create(:question, user: user) }

    it 'validate author not votes' do
      question.voteup(user)
      
      expect { question.voteup(user) }.to_not change(Vote, :count)
    end
  end
end
