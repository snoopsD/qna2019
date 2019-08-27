require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all}
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user}
    let(:other_user) { create :user}
    let(:file) { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb", 'text/plain') }
    let(:question) { create :question, files: [file], user: user }
    let(:other_question) { create :question, files: [file], user: other_user }
    let(:answer) { create :answer, question: question, files: [file], user: user }
    let(:other_answer) { create :answer, question: question, files: [file], user: other_user }    
    
    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, question}
    it { should_not be_able_to :update, other_question }

    it { should be_able_to :update, answer }
    it { should_not be_able_to :update, other_answer }

    it { should be_able_to :destroy, question }
    it { should_not be_able_to :destroy,  other_question}

    it { should be_able_to :destroy, answer }
    it { should_not be_able_to :destroy,  other_answer }  

    it { should be_able_to :destroy, question.files.first }
    it { should_not be_able_to :destroy, other_question.files.first }

    it { should be_able_to :destroy, answer.files.first }
    it { should_not be_able_to :destroy, other_answer.files.first }

    it { should be_able_to :best, other_answer }
    it { should_not be_able_to :best, answer }

    it { should be_able_to :voteup, other_answer }
    it { should be_able_to :votedown, other_question }
    it { should_not be_able_to :voteup, answer }
    it { should_not be_able_to :votedown, question }

    it { should be_able_to :index, Badge }
    
  end
end
