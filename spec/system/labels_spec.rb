require 'rails_helper'

RSpec.describe "ラベル機能", type: :system do
  describe 'ラベル登録のテスト' do
    let!(:user){ FactoryBot.create(:user) }
    before do
      sign_in(user)
    end
    context 'ラベルの新規登録をした場合' do
      it 'ラベルの新規登録ができる' do
        visit new_label_path
        fill_in "ラベル", with: "テニス"
        click_on "登録"
        expect(page).to have_content "ラベルを登録しました"
        expect(page).to have_content "テニス"
      end
    end
    context 'ラベルの編集をした場合' do
      it 'ラベルの変更ができる' do
        visit labels_path
        click_on "編集", match: :first
        fill_in "ラベル", with: "テニス"
        click_on "登録"
        expect(page).to have_content "ラベルを編集しました"
        expect(page).to have_content "テニス"
        expect(page).not_to have_content "趣味"
      end
    end
    context 'ラベルの削除をした場合' do
      it 'ラベルの削除ができる' do
        visit labels_path
        accept_alert do
          click_on "削除", match: :first
        end
        expect(page).to have_content "ラベルを削除しました"
        expect(page).to have_content "仕事"
        expect(page).not_to have_content "趣味"
      end
    end
  end
end
