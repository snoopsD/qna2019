require 'rails_helper'

RSpec.describe Subscription, type: :model do
  subject { create(:subscription) }


  it { should belong_to(:user) }
  it { should belong_to(:question).touch(true)  }
  it { should validate_uniqueness_of(:question).scoped_to(:user_id) }
end
