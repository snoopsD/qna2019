require 'rails_helper'

feature 'User can check best answer', %q{
  In order to check best answer
  As an author
  I'd like to be able to check the answer
} do

  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create_list(:answer, 2, question: question, user: other_user) }
  given!(:badge) { create(:badge, question: question, answer: answer[0]) }  

  describe 'Authenticated user', js: true do

    scenario 'not author question cant see check best answer' do
      sign_in(other_user)
      visit question_path(question)

      expect(page).to_not have_link('best')
    end

    scenario 'author can sees to check best answer' do
      sign_in(user)
      visit question_path(question)

      within '.answers' do        
        expect(page).to have_link('Best').twice

      end
    end  

    scenario 'author question can check best answer' do
      sign_in(user)
      visit question_path(question)

      within "#answer-#{answer.last.id}" do
        click_on 'Best'
      end

      within ".best-answer" do
        expect(current_path).to eq question_path(question)
        expect(page).to have_content "#{answer.last.body}"
        expect(page).to_not have_content "#{answer.first.body}"
      end
    end

    scenario 'user get badge for best answer' do
      sign_in(user)
      visit question_path(question)

      within "#answer-#{answer.last.id}" do
        click_on 'Best'
      end

      sign_out
      sign_in(other_user)
      visit user_badges_path(other_user)

      expect(page).to have_content question.title
      expect(page).to have_content badge.name
      expect(page).to have_css "img[src*='badge.png']"
    end

    scenario 'see the best answer in top on list' do
      sign_in(user)
      visit question_path(question)

      within "#answer-#{answer.last.id}" do
        click_on 'Best'
      end

      within first('.answers') do
        expect(page).to have_content answer.last.body
      end
    end

    context 'can choose another answer for best check' do
      given!(:best_answer) { create(:answer, question: question, user: user, best: true) }

      scenario 'check another best answer'do  
        sign_in(user)
        visit question_path(question)

        within "#answer-#{answer.last.id}" do
          click_on 'Best'
        end
   
        expect(current_path).to eq question_path(question)
        within ".best-answer" do
          expect(page).to have_content "#{answer.last.body}"
          expect(page).to_not have_content (best_answer.body)
        end
      end
    end  
  end 
end
