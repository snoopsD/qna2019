shared_examples_for "voted" do  
  let(:user)          { create(:user) }
  let(:other_user)    { create(:user) }
 

  def send_request(action, member)
    process action, method: :post, params: { id: member }, format: :js
  end

  describe 'POST #voteup' do  
    context 'resource non-owner' do
      before { login(other_user) }
      
      it 'assigns requested votable resource to @votable' do     
        send_request(:voteup, user_resource)
        expect(assigns(:votable)).to eq(user_resource)
      end    

      it 'increase score by 1' do
        send_request(:voteup, user_resource)
        expect(user_resource.rate).to eq(1)
      end

      it 'responds with json' do
        send_request(:voteup, user_resource)
        expect(response.content_type).to eq('application/json')
      end
    end    

    context 'resource owner' do
      before { login(user) }

      it 'dont save to db' do
        send_request(:voteup, user_resource)
        expect { send_request(:voteup, user_resource) }.to_not change(Vote, :count)
      end   

      it 'responds with status code 403' do
        send_request(:voteup, user_resource)
        expect(response.status).to eq(403)
      end
    end
  end 

  describe 'POST #votedown' do  
    context 'resource non-owner' do
      before { login(other_user) }
  
      it 'assigns requested votable resource to @votable' do
        send_request(:votedown, user_resource)
        expect(assigns(:votable)).to eq(user_resource)
      end    

      it 'increase score by -1' do
        send_request(:votedown, user_resource)
        expect(user_resource.rate).to eq(-1)
      end

      it 'responds with json' do
        send_request(:votedown, user_resource)
        expect(response.content_type).to eq('application/json')
      end
    end    

    context 'resource owner' do
      before { login(user) }

      it 'assigns requested votable resource to @votable' do
        send_request(:votedown, user_resource)
        expect(assigns(:votable)).to eq(user_resource)
      end   

      it 'dont save to db' do
        send_request(:votedown, user_resource)
        expect { send_request(:votedown, user_resource) }.to_not change(Vote, :count)
      end   

      it 'responds with status code 403' do
        send_request(:votedown, user_resource)
        expect(response.status).to eq(403)
      end
    end
  end  
end
