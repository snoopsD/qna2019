require 'rails_helper'

RSpec.describe Services::Searches do
  subject { Services::Searches }

  context 'query_object is invalid type' do
    it 'calls the method search of ThinkingSphinx ' do 
      expect(subject.find_query('invalid type', 'test')).to be_nil
    end
  end

  context 'query_object is :all' do
    it 'calls the method search of ThinkingSphinx' do 
      expect(ThinkingSphinx).to receive(:search).with("test")
      subject.find_query("all", 'test')
    end
  end

  context 'query_object is classname' do
    it 'calls the method search of select class' do 
      %w[question answer comment user].each do |klass|
        expect(klass.classify.constantize).to receive(:search).with("test")
        subject.find_query(klass, 'test')
      end
    end
  end

end
