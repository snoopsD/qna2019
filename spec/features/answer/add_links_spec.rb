require 'rails_helper'

feature 'User can add links to asnwer', %q{
  In order to provide additional info to my answer
  As an answer author
  I'd like to be able to add likns
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/snoopsD/bf00aa93c529956c77a6d7b320aa0175' }

  scenario 'User adds link when give an answer', js: true do
    sign_in(user)

    visit question_path(question)    

    fill_in 'Body', with: 'text answer'  

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Post answer'

    within '.answers' do 
      expect(page).to have_link 'My gist', href: gist_url
    end
  end


end
