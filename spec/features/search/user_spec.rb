require 'sphinx_helper'

feature 'User can search for user', %q{
  In order to find needed user
  As a User
  I'd like to be able to search for the user } do   

  given(:user)     { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question) }

  context "Some user searches", sphinx: true, js: true do
    scenario 'find user' do
      visit questions_path
      
      ThinkingSphinx::Test.run do

        within('.search') do
          fill_in "find_field", with: 'user1'
          select 'user', from: :query        
          click_on 'Find'
        end

        expect(page).to have_content 'Users find'
        expect(page).to have_content 'user1@test.com'
        expect(page).to_not have_content 'user2@test.com'
      end  
    end
  end
end
