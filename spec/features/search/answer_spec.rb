require 'sphinx_helper'

feature 'User can search for answer', %q{
  In order to find needed answer
  As a User
  I'd like to be able to search for the answer } do   

  given(:user)     { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }  

  context "Some user searches", sphinx: true, js: true do
    scenario 'find answer' do
      visit questions_path
      
      ThinkingSphinx::Test.run do

        within('.search') do
          fill_in "find_field", with: 'AnswerBody1'
          select 'answer', from: :query        
          click_on 'Find'
        end

        expect(page).to have_content 'Answers find'
        expect(page).to have_content 'AnswerBody1'
        expect(page).to have_content 'QuestionTitle'
        expect(page).to_not have_content 'Add answer'
      end  
    end
  end
end
