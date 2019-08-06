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
    expect(page).to have_content("AnswerBody", count: 2)
  end

  describe "Give a score for question", js: true do

    context 'Authenticated user' do
      scenario 'author question cant voteup' do
        sign_in(user)
        visit question_path(question)

        within '.question-votes' do
          click_on '+'
        end  

        within '.question-errors' do
          expect(page).to have_content("Author can't vote")
        end
      end

      scenario 'author question cant votedown' do
        sign_in(user)
        visit question_path(question)

        within '.question-votes' do
          click_on '-'
        end  

        within '.question-errors' do
          expect(page).to have_content("Author can't vote")          
        end
      end

      scenario 'not author question can voteup' do
        sign_in(other_user)
        visit question_path(question)

        within '.question-score' do
          expect(page).to_not have_content("1")
        end

        within '.question-votes' do
          click_on '+'
        end  

        within '.question-score' do
          expect(page).to have_content("1")
        end
      end

      scenario 'not author question can votedown' do
        sign_in(other_user)
        visit question_path(question)

        within '.question-score' do
          expect(page).to_not have_content("-1")
        end

        within '.question-votes' do
          click_on '-'
        end  

        within '.question-score' do
          expect(page).to have_content("-1")
        end
      end

      scenario 'not author question can revote' do
        sign_in(other_user)
        visit question_path(question)

        within '.question-score' do
          expect(page).to_not have_content("1")
        end

        within '.question-votes' do
          click_on '-'
          sleep 0.3
          click_on '+'
          sleep 0.3
          click_on '+'
        end  

        within '.question-score' do
          expect(page).to have_content("1")
        end
      end
    end

    context 'Unauthenticated user' do
      scenario 'cant voteup' do
        visit question_path(question)

        within '.question-votes' do
          click_on '+'
        end  

        expect(page).to have_content('You need to sign in or sign up before continuing.')
      end

      scenario 'cant votedown' do
        visit question_path(question)

        within '.question-votes' do
          click_on '-'
        end  

        expect(page).to have_content('You need to sign in or sign up before continuing.')
      end
    end
  end
end
