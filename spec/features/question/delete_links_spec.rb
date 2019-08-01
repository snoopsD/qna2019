require 'rails_helper'

feature 'User can delete links to question', %q{
  In order to delete links question
  As an question author
  I'd like to be able to delete links
} do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:link) { create(:link, linkable: question) }

  describe 'Authenticated user', js: true do

    scenario 'Author can delete link' do  

      sign_in(user)
      visit question_path(question)
      
      within '.question' do
        click_on 'Edit'
        click_on 'remove link'
        click_on 'Save'
      end  

      expect(page).to_not have_link link.name, href: link.url
    end

    scenario 'Not author cant see delete link' do
      sign_in(other_user)
      visit question_path(question)
      
      within '.question' do
        expect(page).to_not have_link 'remove link'
      end 
    end
  end

  describe 'Unauthenticated user', js: true do
    scenario 'can show delete link' do 
      visit question_path(question)

      within '.question' do
        expect(page).to_not have_link 'remove link'
      end

    end
  end
   
end
