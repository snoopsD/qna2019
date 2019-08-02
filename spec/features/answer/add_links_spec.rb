require 'rails_helper'

feature 'User can add links to asnwer', %q{
  In order to provide additional info to my answer
  As an answer author
  I'd like to be able to add likns
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given(:gist_url) { 'https://gist.github.com/snoopsD/bf00aa93c529956c77a6d7b320aa0175' }
  given(:github_url)  { 'https://github.com/' }
  given(:habr_url)  { 'https://habr.ru/' }

  describe 'Authenticated user', js: true do

    background do
      sign_in(user)
      visit question_path(question)

      fill_in 'Body', with: 'text for answers'

      fill_in 'Link name', with: 'Github'
      fill_in 'Url', with: github_url
    end

    scenario 'adds link when send answer' do 
      click_on 'Post answer'

      expect(page).to have_link 'Github', href: github_url
    end

    scenario 'add links' do
      click_on 'add link'

      within all('.nested-fields')[1] do
        fill_in 'Link name', with: 'Habr'
        fill_in 'Url', with: habr_url
      end

      click_on 'Post answer'

      expect(page).to have_link 'Github', href: github_url
      expect(page).to have_link 'Habr', href: habr_url
    end

    scenario 'with gist link' do
      fill_in 'Url', with: gist_url

      click_on 'Post answer'

      within '.answers' do
        expect(page).to have_content 'test'
        expect(page).to have_content 'test1 test2 test3'
      end
    end

    scenario 'add invalid link' do
      click_on 'add link'
      
      within all('.nested-fields')[1] do
        fill_in 'Link name', with: 'github'
        fill_in 'Url', with: 'something wrong'
      end

      click_on 'Post answer'
  
      expect(page).to have_content('Links url provided invalid')
    end
  end

  describe 'Unauthenticated user', js: true do
    scenario 'cant add link' do 
      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_link 'add link'
      end
    end
  end  

end
