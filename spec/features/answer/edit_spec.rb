require 'rails_helper'

feature 'User can edit own answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
} do 

  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)

      visit question_path(question)
    end 

    scenario 'edits his answer' do
      within '.answers' do
        click_on 'Edit'
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'        
      end

      within '.question-edit' do
        expect(page).to_not have_selector 'textarea'
      end
    end

    context 'edit a answer with attached file' do
      background do
        within '.answers' do
          click_on 'Edit'
          attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb","#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Save'
        end  
      end

      scenario 'add multiple files' do       
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end

      scenario 'delete attached file in answer' do

        within first('.answer-file') do 
          click_on 'Delete'
        end

        expect(page).to_not have_link 'rails_helper.rb'
      end

      scenario "not author can't see delete link file" do
        sign_out
        sign_in(other_user)
      
        visit question_path(question)  

        within first('.answer-file')  do 
          expect(page).to_not have_link 'delete'
        end  
      end  
    end

    scenario 'edits his answer with errors' do
      within '.answers' do
        click_on 'Edit'
        fill_in 'Your answer', with: ''
        click_on 'Save'
      end  
      expect(page).to have_content "Body can't be blank"
    end

    scenario "tries to edit other user's question" do
      sign_out
      sign_in(other_user)
      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_content 'Edit'
      end  
    end

  end

end
