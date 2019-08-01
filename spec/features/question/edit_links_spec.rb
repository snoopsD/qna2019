require 'rails_helper'

feature 'User can edit links to question', %q{
  In order to provide links question
  As an question author
  I'd like to be able to edit links
} do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:link) { create(:link, linkable: question) }

  describe 'Authenticated user', js: true do
    
    scenario 'can edit link' do
      sign_in(user)
      visit question_path(question)

      within '.question' do
        click_on 'Edit'

        fill_in 'Link name', with: 'Github'
        fill_in 'Url', with: 'https://github.com'

        click_on 'Save'
      end  

      expect(page).to have_link 'Github', href: 'https://github.com'

    end
  end

  scenario 'Not author cant see edit  link' do
    sign_in(other_user)
    visit question_path(question)
    
    within '.question' do
      expect(page).to_not have_link 'Edit'
    end 
  end

  describe 'Unauthenticated user', js: true do
    scenario 'can show edit link' do 
      visit question_path(question)

      within '.question' do
        expect(page).to_not have_link 'Edit'
      end

    end
  end  
   
end
