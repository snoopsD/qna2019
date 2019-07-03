require 'rails_helper'

feature 'User can check best answer', %q{
  In order to check best answer
  As an author
  I'd like to be able to check the answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create_list(:answer, 2, question: question, user: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'not author answer cant see check best answer' do
      expect(page).to_not have_link('best')
    end

    scenario 'can sees to check best answer' do
      within '.answers' do
        
        expect(page).to have_link('Best').twice

      end
    end  

    scenario 'author answer can check best answer' do
      within "#answer-#{answer.last.id}" do
        click_on 'Best'
      end

      within ".best-answer" do
        expect(current_path).to eq question_path(question)
        expect(page).to have_content "#{answer.last.body}"
        expect(page).to_not have_content "#{answer.first.body}"
      end
    end

    scenario 'can choose another answer for best check'do
      within "#answer-#{answer.first.id}" do
        click_on 'Best'
      end

      within ".best-answer" do
        expect(current_path).to eq question_path(question)
        expect(page).to have_content "#{answer.first.body}"
        expect(page).to_not have_content "#{answer.last.body}"
      end
    end
  end 
end
