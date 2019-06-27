require 'rails_helper'

feature 'User can delete question', %q{
  In order to delete question
  As an authenticated user
  I'd like to be delete own question
} do

  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario ' Authenticated user delete own question' do
    sign_in(user)

    visit questions_path
    click_on 'Show'
    click_on 'Delete question'

    expect(page).to have_content 'Question successfully delete'
  end

  scenario 'Authenticated userdelete not own question' do
    sign_in(other_user)

    visit questions_path
    click_on 'Show'
    click_on 'Delete question'
    expect(page).to have_content "You are not the author question."
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on 'Show'
    click_on 'Delete question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

end
