require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to(:linkable).touch(true)  }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  describe 'check url' do
    let(:question) { create(:question) }
    let(:valid_url) { build(:link, name: 'github', url: 'https://github.com/', linkable: question) }
    let(:invalid_url) { build(:link, url: 'something wrong', linkable: question) }
 
    it 'url is valid' do
      expect(valid_url).to be_valid
    end

    it 'url is invalid' do
      expect(invalid_url).to_not be_valid
    end

  end

  describe 'gist?' do
    let(:gist_url) { build(:link, name: 'github', url: 'https://gist.github.com/') }
    let(:habr_url) { build(:link, name: 'github', url: 'https://habr.ru/') }

    it 'url on gist' do
      expect(gist_url).to be_gist
    end

    it 'url not on gist' do
      expect(habr_url).to_not be_gist
    end

  end

  describe 'show_gist' do
    let(:gist_url) { build(:link, url: 'https://gist.github.com/snoopsD/bf00aa93c529956c77a6d7b320aa0175') }

    it 'show gist content' do
      expect(gist_url.show_gist).to be_a_kind_of Array    
      expect(gist_url.show_gist.first).to include(content: "test1\ntest2\ntest3", name: :test)
    end
  end

end
