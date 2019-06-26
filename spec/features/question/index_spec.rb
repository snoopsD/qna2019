require 'rails_helper'

feature 'User can see list questions', %q{
  In order to choose question
  As an user
  I'd like to be able to see all questions
} do
  
  given!(:questions) { create_list(:question, 3) }

  scenario 'Any user can see list questions' do
    visit questions_path

    expect(page).to have_content("QuestionTitle", count: 3)
  end

end
