require 'rails_helper'

feature 'User can see question with answers', %q{
  In order to view question
  As an user
  I'd like to be able to see question with answers
} do
  
  given(:user)     { create(:user) }
  given(:other_user)     { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 2, question: question) }

  scenario 'Any user can see question with answers' do
    visit question_path(question)

    expect(page).to have_content("QuestionTitle")
    expect(page).to have_content(answers.first.body)
    expect(page).to have_content(answers.last.body)
  end

  describe "Give a score for question", js: true do

    context 'Authenticated user' do
      scenario 'author question cant voteup' do
        sign_in(user)
        visit question_path(question)

        within '.question-votes' do
          expect(page).to_not have_link '+'
        end
      end

      scenario 'author question cant votedown' do
        sign_in(user)
        visit question_path(question)

        within '.question-votes' do
          expect(page).to_not have_link '-'
        end
      end

      scenario 'not author question can voteup' do
        sign_in(other_user)
        visit question_path(question)
        
        within ".question-score-#{question.id}" do
          expect(page).to_not have_content("1")
        end

        within '.question-votes' do
          click_on '+'
        end  

        within ".question-score-#{question.id}"  do
          expect(page).to have_content("1")
        end
      end

      scenario 'not author question can votedown' do
        sign_in(other_user)
        visit question_path(question)

        within ".question-score-#{question.id}"  do
          expect(page).to_not have_content("-1")
        end

        within '.question-votes' do
          click_on '-'
        end  

        within ".question-score-#{question.id}"  do
          expect(page).to have_content("-1")
        end
      end

      scenario 'not author question can revote' do
        sign_in(other_user)
        visit question_path(question)

        within ".question-score-#{question.id}"  do
          expect(page).to_not have_content("1")
        end

        within '.question-votes' do
          click_on '-'
          sleep 0.3
          click_on '+'
          sleep 0.3
          click_on '+'
        end  

        within ".question-score-#{question.id}"  do
          expect(page).to have_content("1")
        end
      end
    end

    context 'Unauthenticated user' do
      scenario 'cant voteup' do
        visit question_path(question)

        within '.question-votes' do
          expect(page).to_not have_link '+'
        end
      end

      scenario 'cant votedown' do
        visit question_path(question)

        within '.question-votes' do
          expect(page).to_not have_link '-'
        end
      end
    end
  end
end
