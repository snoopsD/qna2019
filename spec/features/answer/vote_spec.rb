require 'rails_helper'

feature 'User can score to asnwer', %q{
  In order to score answer
  As an authenticated user
  I'd like to be score an answer
} do

  given(:user)     { create(:user) }
  given(:other_user)     { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answers) { create(:answer, question: question, user: other_user) }


  describe "Give a score for answer", js: true do

    context 'Authenticated user' do
      scenario 'author answer cant voteup' do
        sign_in(other_user)
        visit question_path(question)

        within '.answer-votes' do
          click_on '+'
        end  

        within '.answer-errors' do
          expect(page).to have_content("Author can't vote")
        end
      end

      scenario 'author answer cant votedown' do
        sign_in(other_user)
        visit question_path(question)

        within '.answer-votes' do
          click_on '-'
        end  

        within '.answer-errors' do
          expect(page).to have_content("Author can't vote")          
        end
      end

      scenario 'not author answer can voteup' do
        sign_in(user)
        visit question_path(question)

        within '.answer-score' do
          expect(page).to_not have_content("1")
        end

        within '.answer-votes' do
          click_on '+'
        end  

        within '.answer-score' do
          expect(page).to have_content("1")
        end
      end

      scenario 'not author answer can votedown' do
        sign_in(user)
        visit question_path(question)

        within '.answer-score' do
          expect(page).to_not have_content("-1")
        end

        within '.answer-votes' do
          click_on '-'
        end  

        within '.answer-score' do
          expect(page).to have_content("-1")
        end
      end

      scenario 'not author answer can revote' do
        sign_in(user)
        visit question_path(question)

        within '.answer-score' do
          expect(page).to_not have_content("1")
        end

        within '.answer-votes' do
          click_on '-'
          sleep 0.3
          click_on '+'
          sleep 0.3
          click_on '+'
        end  

        within '.answer-score' do
          expect(page).to have_content("1")
        end
      end
    end

    context 'Unauthenticated user' do
      scenario 'cant voteup' do
        visit question_path(question)

        within '.answer-votes' do
          click_on '+'
        end  

        expect(page).to have_content('You need to sign in or sign up before continuing.')
      end

      scenario 'cant votedown' do
        visit question_path(question)

        within '.answer-votes' do
          click_on '-'
        end  

        expect(page).to have_content('You need to sign in or sign up before continuing.')
      end
    end
  end  
end
