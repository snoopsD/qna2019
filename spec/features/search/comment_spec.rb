require 'sphinx_helper'

feature 'User can search for comment', %q{
  In order to find needed comment
  As a User
  I'd like to be able to search for the comment } do   

  given(:user)     { create(:user) }
  given!(:question) { create(:question) }
  given!(:comment) { create(:comment, user: user) }

  context "Some user searches", sphinx: true, js: true do
    scenario 'find comment' do
      visit questions_path
      
      ThinkingSphinx::Test.run do

        within('.search') do
          fill_in "find_field", with: 'MyString'
          select 'comment', from: :query        
          click_on 'Find'
        end

        expect(page).to have_content 'Comments find'
        expect(page).to have_content 'MyString'
        expect(page).to_not have_content 'Add answer'
      end  
    end
  end
end
