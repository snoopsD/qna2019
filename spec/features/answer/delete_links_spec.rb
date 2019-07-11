require 'rails_helper'

feature 'User can delete links to answer', %q{
  In order to delete links on answer
  As an answer author
  I'd like to be able to delete links
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:link) { create(:link, linkable: answer) }

  describe 'Authenticated user', js: true do

    scenario 'can delete link' do  

      sign_in(user)
      visit question_path(question)
      
      within '.answers' do
        click_on 'Edit'
        click_on 'remove link'
        click_on 'Save'
      end  

      expect(page).to_not have_link link.name, href: link.url
    end
  end
   
end
