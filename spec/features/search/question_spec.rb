require 'sphinx_helper'

feature 'User can search for question', %q{
  In order to find needed question
  As a User
  I'd like to be able to search for the question } do   

  given(:user)     { create(:user) }
  given!(:question) { create(:question) }

  context "Some user searches", sphinx: true, js: true do
    scenario 'find question' do
      visit questions_path
      
      ThinkingSphinx::Test.run do

        within('.search') do
          fill_in "find_field", with: 'QuestionTitle'
          select 'question', from: :query        
          click_on 'Find'
        end

        expect(page).to have_content 'Questions find'
        expect(page).to have_content 'QuestionTitle'
        expect(page).to_not have_content 'Add answer'
      end  
    end
  end
end
