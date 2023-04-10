module SignInSupport
  def sign_in(user)
    visit new_user_session_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: 'password'
    find('.btn-primary').click
  end
end