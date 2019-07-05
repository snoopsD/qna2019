require 'rails_helper'

feature 'User can edit own question', %q{
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
} do 

  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Unauthenticated can not edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end


  describe 'Authenticated user', js: true  do

    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'edits his question' do  
      within '.question' do
        click_on 'Edit'
        fill_in 'Body', with: 'edited question'
        click_on 'Save'

        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited question'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edit a question with attached file' do
      within '.question' do
        click_on 'Edit'
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb","#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'
      end  
      
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'edits his question with errors' do
      within '.question' do
        click_on 'Edit'
        fill_in 'Body', with: ''
        click_on 'Save'
      end 
      expect(page).to have_content "Body can't be blank"
    end

    scenario "tries to edit other user's question" do
      sign_out
      sign_in(other_user)
      visit question_path(question)

      within '.question' do
        expect(page).to_not have_link 'Edit'
      end  
    end

  end
end
