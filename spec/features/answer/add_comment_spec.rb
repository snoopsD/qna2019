require 'rails_helper'

feature 'User can add comments to answer', %q{
  In order to provide additional info to answer
  As an authenticated user
  He's like to be able to add comments
} do

  given(:user) { create(:user) }
  given(:question)  { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'add comments' do
      within('.new-comment-answer') do
        fill_in 'Comment', with: 'test comment'
        click_on 'Create Comment'
      end

      within(".comments-answer-#{answer.id}") do
        expect(page).to have_content('test comment')
      end
      
    end
  end

  context "multiple comments answer", js: true do
    scenario "question comments appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do       
        within('.new-comment-answer') do
          fill_in 'Comment', with: 'test comment'
          click_on 'Create Comment'
        end
  
        within(".comments-answer-#{answer.id}") do
          expect(page).to have_content('test comment')
        end
      end

      Capybara.using_session('guest') do
        within(".comments-answer-#{answer.id}") do
          expect(page).to have_content('test comment')
        end
      end
    end
  end  

  describe 'Unauthenticated user', js: true do
    background do
      visit question_path(question)
    end

    scenario 'cant see button add comments' do
      expect(page).to have_no_button('Create Comment')
    end
  end

end
