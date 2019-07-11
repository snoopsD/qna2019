require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/snoopsD/bf00aa93c529956c77a6d7b320aa0175' }
  given(:github_url)  { 'https://github.com/' }

  describe 'Authenticated user', js: true do

    background do
      sign_in(user)
      visit new_question_path

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text for question'

      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url
    end

    scenario 'adds link when asks question' do 
      click_on 'Ask'

      expect(page).to have_content('test1 test2 test3')
    end

    scenario 'add links' do
      click_on 'add link'

      within all('.nested-fields')[1] do
        fill_in 'Link name', with: 'github'
        fill_in 'Url', with: github_url
      end

      click_on 'Ask'

      expect(page).to have_content('test1 test2 test3')
      expect(page).to have_link 'github', href: github_url
    end

    scenario 'add invalid link' do
      click_on 'add link'
      
      within all('.nested-fields')[1] do
        fill_in 'Link name', with: 'github'
        fill_in 'Url', with: 'something wrong'
      end

      click_on 'Ask'
  
      expect(page).to have_content('Links url provided invalid')
    end
  end
   
end
