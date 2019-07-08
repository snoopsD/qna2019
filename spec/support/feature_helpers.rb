module FeatureHelpers

  def sign_in(user)
    
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

  end

  def sign_out
    visit root_path
    click_on 'Log out'
  end
end
