require 'sphinx_helper'

feature 'User can search for all', %q{
  In order to find needed somebody
  As a User
  I'd like to be able to search for the all } do   

  given(:user)     { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }  
  given!(:comment) { create(:comment, user: user) }

  context "Some user searches", sphinx: true, js: true do
    scenario 'find somebody' do
      visit question_path(question) 
      
      ThinkingSphinx::Test.run do

        within('.search') do
          fill_in "find_field", with: 'user1'
          select 'all', from: :query        
          click_on 'Find'
        end

        expect(page).to have_content 'Answers find'
        expect(page).to have_content 'Questions find'
        expect(page).to have_content 'Comments find'
        expect(page).to have_content 'Users find'
        expect(page).to have_content question.title
        expect(page).to have_content answer.body
        expect(page).to have_content comment.body
        expect(page).to have_content user.email
        expect(page).to_not have_content other_user.email
      end  
    end
  end
end
