require 'rails_helper'

feature 'User can sign in', %q{
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sign in
} do

  describe 'login without oauth' do

    given(:user) { create(:user) }

    background { visit new_user_session_path }  

    scenario 'Registred user tries to sign in' do

      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Log in'

      expect(page).to have_content 'Signed in successfully.'
    end

    scenario 'Unregistred user tries to sign in' do
      
      fill_in 'Email', with: 'wrong@test.com'
      fill_in 'Password', with: '12345678'
      click_on 'Log in'

      expect(page).to have_content 'Invalid Email or password.'
    end
  end  

  describe 'login with oauth' do
    background { visit new_user_session_path } 

    scenario 'with instargram' do
      expect(page).to have_content('Sign in with Instagram')
      mock_auth :instagram
      click_on 'Sign in with Instagram'
      expect(page).to have_content('Add email information')
      fill_in "auth_hash[info][email]", with: 'test@test11.com'
      click_on 'Add' 
      open_email(User.first.email)
      current_email.click_link 'Confirm my account'
      expect(page).to have_content('Your email address has been successfully confirmed.')
      click_on 'Sign in with Instagram'
      expect(page).to have_content('Successfully authenticated from instagram account.')
    end

    scenario 'with github' do
      expect(page).to have_content('Sign in with GitHub')
      mock_auth :github
      click_on 'Sign in with GitHub'
      open_email(User.first.email)
      current_email.click_link 'Confirm my account'
      expect(page).to have_content('Your email address has been successfully confirmed.')
      click_on 'Sign in with GitHub'
      expect(page).to have_content('Successfully authenticated from github account.')
    end

  end
end
