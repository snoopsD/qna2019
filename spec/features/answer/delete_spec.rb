require 'rails_helper'

feature 'User can delete question', %q{
  In order to delete 
  As an user
  I'd like to be delete own question
} do

  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario ' Authenticated user delete own answer' do
    sign_in(user)

    visit questions_path
    click_on 'Show'
    click_on 'Delete answer'

    expect(page).to have_content 'Answer successfully delete'
  end

  scenario 'Authenticated user delete not own answer' do
    sign_in(other_user)

    visit questions_path
    click_on 'Show'
    click_on 'Delete answer'
    expect(page).to have_content "You are not the author answer."
  end

  scenario 'Unauthenticated user tries delete answer' do
    visit questions_path
    click_on 'Show'
    click_on 'Delete answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

end
