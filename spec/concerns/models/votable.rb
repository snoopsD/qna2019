shared_examples_for "votable" do  
  it { should have_many(:votes).dependent(:destroy) }
  
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:question) { create(:question, user: user) }
  
  describe '#voteup' do

    context 'user votes for the first time' do
      it 'increase by 1' do
        expect { model.voteup(other_user) }.to change(model, :rate).by(1)
      end
    end

    context 'user votes again on the same resource' do      
      let!(:vote) { create(:vote, votable: model, user: other_user) }

      it 'cancel previous vote' do
        expect { model.voteup(other_user) }.to change(model, :rate).by(-1)
      end
    end

    context 'user change his vote from negative to positive' do
      let(:vote) { create(:negative_vote, votable: model, user: other_user) }

      it 'increases by 1' do
        expect { model.voteup(other_user) }.to change(model, :rate).by(1)
      end
    end
  end

  describe '#votedown' do

    context 'user votes down for the first time' do
      it 'decrease by 1' do
        expect { model.votedown(other_user) }.to change(model, :rate).by(-1)
      end
    end

    context 'user votes down again on the same resource' do      
      let!(:vote) { create(:negative_vote, votable: model, user: other_user) }

      it 'cancel previous vote' do
        expect { model.votedown(other_user) }.to change(model, :rate).by(1)
      end
    end

    context 'user change his vote from positive to negative' do
      let(:vote) { create(:vote, votable: model, user: other_user) }

      it 'increases by 1' do
        expect { model.votedown(other_user) }.to change(model, :rate).by(-1)
      end
    end
  end
end
