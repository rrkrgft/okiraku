require 'rails_helper'

RSpec.describe "ユーザー機能", type: :system do
  describe 'ユーザー新規作成機能' do
    context 'ユーザーの新規登録した場合' do
      it 'ユーザーの新規登録ができる' do
        visit new_user_registration_path
        fill_in '名前', with: 'test'
        fill_in 'メールアドレス', with: 'test@test.com'
        fill_in 'パスワード', with: 'password'
        fill_in '確認用パスワード', with: 'password'
        click_on 'アカウント登録'
        expect(page).to have_content 'アカウント登録が完了しました'
      end
    end
    context 'ログインせずに一覧ページにアクセスした場合' do
      it 'ログイン画面に遷移' do
        visit posts_path
        expect(page).to have_content 'ログイン'
        expect(page).to have_content 'パスワード'
      end
    end
    context 'ログインせずに一覧ページにアクセスした場合' do
      it 'ログイン画面に遷移' do
        visit favorites_path
        expect(page).to have_content 'ログイン'
        expect(page).to have_content 'パスワード'
      end
    end
    context 'ログインせずに一覧ページにアクセスした場合' do
      it 'ログイン画面に遷移' do
        visit labels_path
        expect(page).to have_content 'ログイン'
        expect(page).to have_content 'パスワード'
      end
    end
    context 'ログインせずに一覧ページにアクセスした場合' do
      it 'ログイン画面に遷移' do
        visit users_path
        expect(page).to have_content 'ログイン'
        expect(page).to have_content 'パスワード'
      end
    end
  end
  describe '一般ユーザーのログイン機能' do
    let!(:user) { FactoryBot.create(:user) }
    before do
      sign_in(user)
    end
    context 'ログインをした場合' do
      it 'ログインできる' do
        expect(page).to have_content 'ログインしました'
        expect(page).to have_content '嬉しいこと、楽しいことの一覧'
      end
    end
    context 'ユーザーの一覧ページにアクセスした場合' do
      it 'ユーザーの一覧ページに行ける' do
        visit users_path
        expect(page).to have_content 'ユーザー投稿一覧'
        expect(page).not_to have_content 'ログイン'
      end
    end
    context 'ユーザーの名前とメールアドレスの編集をした場合' do
      it 'ユーザー名、メールアドレスの編集ができる' do
        visit edit_user_registration_path(user)
        fill_in '名前', with: 'test_edit'
        fill_in 'メールアドレス', with: 'test_edit@test.com'
        find('#user_current_password').set("password")
        click_on '更新'
        expect(page).to have_content 'アカウント情報を変更しました。'
        visit edit_user_registration_path(user)
        expect(page).to have_field '名前', with: 'test_edit'
        expect(page).to have_field 'メールアドレス', with: 'test_edit@test.com'
      end
    end
    context 'ユーザーの名前の編集をした場合' do
      it 'ユーザー名の編集ができる' do
        visit edit_user_registration_path(user)
        fill_in '名前', with: 'test_edit'
        find('#user_current_password').set("password")
        click_on '更新'
        expect(page).to have_content 'アカウント情報を変更しました。'
        visit edit_user_registration_path(user)
        expect(page).to have_field '名前', with: 'test_edit'
      end
    end
    context 'ユーザーのメールアドレスの編集をした場合' do
      it 'メールアドレスの編集ができる' do
        visit edit_user_registration_path(user)
        fill_in 'メールアドレス', with: 'test_edit@test.com'
        find('#user_current_password').set("password")
        click_on '更新'
        expect(page).to have_content 'アカウント情報を変更しました。'
        visit edit_user_registration_path(user)
        expect(page).to have_field 'メールアドレス', with: 'test_edit@test.com'
      end
    end
    context 'ユーザーのパスワードを変更をした場合' do
      it 'パスワードの変更ができる' do
        visit edit_user_registration_path(user)
        find('#user_password').set("password1")
        find('#user_password_confirmation').set("password1")
        find('#user_current_password').set("password")
        click_on '更新'
        expect(page).to have_content 'アカウント情報を変更しました。'
        visit edit_user_registration_path(user)
        fill_in 'メールアドレス', with: 'test_edit@test.com'
        find('#user_current_password').set("password1")
        click_on '更新'
        expect(page).to have_content 'アカウント情報を変更しました。'
      end
    end
    context 'ログアウトした場合' do
      it 'ログアウトできる' do
        click_on 'ログアウト'
        expect(page).to have_content 'ログアウトしました'
        expect(page).not_to have_content 'マイページ'
      end
    end
    context '管理者画面にアクセスした場合' do
      it 'アクセスできない' do
        visit rails_admin_path
        expect(page).to have_content '画面を閲覧する権限がありません。'
        expect(page).to have_content '嬉しいこと、楽しいことの一覧'
      end
    end
  end
  describe '管理者権限の機能' do
    let!(:user) { FactoryBot.create(:user, admin: true) }
    before do
      sign_in(user)
    end
    context '管理者ページにアクセスした場合' do
      it 'アクセスできる' do
        visit rails_admin_path
        expect(page).to have_content 'サイト管理'
        expect(page).to have_content 'ナビゲーション'
      end
    end
  end
end
