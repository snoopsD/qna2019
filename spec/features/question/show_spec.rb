require 'rails_helper'

feature 'User can see question with answers', %q{
  In order to view question
  As an user
  I'd like to be able to see question with answers
} do
  
  given(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 2, question: question) }

  scenario 'Any user can see question with answers' do
    visit question_path(question)
    
    expect(page).to have_content("QuestionTitle")
    expect(page).to have_content("AnswerBody", count: 2)
  end

end
