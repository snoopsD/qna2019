require 'rails_helper'

feature 'User can delete answer', %q{
  In order to delete 
  As an user
  I'd like to be delete own answer
} do

  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario ' Authenticated user delete own answer', js: true do
    sign_in(user)

    visit questions_path
    click_on 'Show'
    expect(page).to have_content 'AnswerBody'
    
    click_on 'Delete answer'

    expect(page).to have_no_content 'AnswerBody'
    expect(page).to have_content 'Answer successfully delete'
  end

  scenario 'Authenticated user delete not own answer', js: true do
    sign_in(other_user)

    visit questions_path
    click_on 'Show'
 
    expect(page).to_not have_link("Delete answer")
  end

  scenario 'Unauthenticated user tries delete answer', js: true do
    visit questions_path
    click_on 'Show'

    expect(page).to_not have_link("Delete answer")
  end

end
