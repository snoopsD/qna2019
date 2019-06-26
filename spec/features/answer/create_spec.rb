require 'rails_helper'

feature 'User can create answer', %q{
  In order to give answer 
  As an authenticated user
  I'd like to be able to answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user' do

    background do
      sign_in(user)

      visit questions_path
      
      click_on 'Show' 
      click_on 'Create answer'
    end

    scenario 'Create an answer' do
      fill_in 'Body', with: 'text answer'  
      click_on 'Post answer'

      expect(page).to have_content 'Your answer successfully created.'
      expect(page).to have_content 'text answer'
    end

    scenario 'Create answer with errors' do
      click_on 'Post answer'

      expect(page).to have_content "Body can't be blank"
    end

  end

  describe 'Unauthenticated user' do

    scenario 'tries to create answer' do
      visit questions_path
      
      click_on 'Show'      
      click_on 'Create answer'
      
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end

  end  
end
