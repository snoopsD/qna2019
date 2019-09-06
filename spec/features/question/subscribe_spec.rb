require 'rails_helper'

feature 'User can see subscribe on question', %q{
  In order to view new answers
  As an user
  I'd like to be able to see new answers
} do
  
  given(:user)     { create(:user) }
  given(:other_user)  { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Unauthenticated user cant see subscribe link' do
    visit question_path(question)

    expect(page).to_not have_link('Subscribe')
  end

  describe 'Authenticated user', js: true do

    scenario 'Author question can unsunscribe own question' do  
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_link('Subscribe')
      expect(page).to have_link('Unsubscribe')

      click_on 'Unsubscribe'

      expect(page).to have_link('Subscribe')
      expect(page).to_not have_link('Unsubscribe')
    end

    scenario 'Not author question can subscribe on question' do 
      sign_in(other_user)
      visit question_path(question)

      expect(page).to_not have_link('Unsubscribe')
      expect(page).to have_link('Subscribe')

      click_on 'Subscribe'

      expect(page).to_not have_link('Subscribe')
      expect(page).to have_link('Unsubscribe')
    end
  end

end  

