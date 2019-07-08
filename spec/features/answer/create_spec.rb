require 'rails_helper'

feature 'User can create answer', %q{
  In order to give answer 
  As an authenticated user
  I'd like to be able to answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user', js: true  do

    background do
      sign_in(user)

      visit questions_path
      
      click_on 'Show' 
    end

    scenario 'create an answer' do
      fill_in 'Body', with: 'text answer'  
      click_on 'Post answer'

      expect(page).to have_content 'Your answer successfully created.'
      expect(page).to have_content 'text answer'
    end

    scenario 'create answer with errors' do
      click_on 'Post answer'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'create answer with attached file' do
      fill_in 'Body', with: 'text answer'

      attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb","#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Post answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

  end

  describe 'Unauthenticated user' do

    scenario 'tries to create answer' do
      visit questions_path
      
      click_on 'Show'  
      click_on 'Post answer'
      
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end

  end  
end
