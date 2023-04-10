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
  describe 'セッションのログイン機能' do
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
    context 'ログアウトした場合' do
      it 'ログアウトできる' do
        click_on 'ログアウト'
        expect(page).to have_content 'ログアウトしました'
        expect(page).not_to have_content 'マイページ'
      end
    end
  end
end
