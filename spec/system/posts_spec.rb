require 'rails_helper'

RSpec.describe "投稿機能", type: :system do
  describe '新規投稿機能' do
    let!(:user){ FactoryBot.create(:user) }
    before do
      sign_in(user)
    end
    context '投稿を新規作成した場合' do
      it '作成した投稿が表示される' do
        visit new_post_path
        find('#task_name').set("test_title")
        fill_in "詳細", with: "test_detail"
        fill_in "詳細（非公開）", with: "test_detail_secret"
        fill_in "深掘り", with: 'test_detail_deeply'
        check "趣味"
        click_on "登録"
        expect(page).to have_content '公開登録しました'
        expect(page).to have_content 'test_title'
        expect(page).not_to have_content 'test_detail' 
      end
    end
    context '投稿を下書き保存した場合' do
      it '下書き保存される' do
        visit new_post_path
        find('#task_name').set("test_title")
        fill_in "詳細", with: "test_detail"
        fill_in "詳細（非公開）", with: "test_detail_secret"
        fill_in "深掘り", with: 'test_detail_deeply'
        check "趣味"
        click_on "下書き"
        sleep 1.0
        click_on "test_title"
        expect(page).to have_content("下書き", count:2)
        expect(page).to have_content 'test_title'
      end
    end
  end
  describe '一覧表示機能' do
    let!(:user){ FactoryBot.create(:user) }
    let!(:post1){ FactoryBot.create(:post,user: user)}
    let!(:detail1){ FactoryBot.create(:detail, post: post1)}
    let!(:post2){ FactoryBot.create(:post, title: "title_post2", user: user)}
    let!(:detail2){ FactoryBot.create(:detail, post: post2)}
    before do
      sign_in(user)
    end
    context '一覧画面に遷移した場合' do
      it '作成済みの投稿一覧が表示される' do
        expect(page).to have_content 'title_post1'
        expect(page).to have_content 'title_post2'
      end
    end
    context '検索を行う場合' do
      it '選んだテキストの入っているもののみが表示される' do
        fill_in "検索条件", with: "post1"
        click_on "検索"
        expect(page).to have_content 'title_post1'
        expect(page).not_to have_content 'title_post2'
      end
    end
    context '編集を行う場合' do
      it '編集後の結果が表示される' do
        click_on "編集", match: :first
        find('#task_name').set("edit_title")
        click_on "登録"
        expect(page).to have_content 'edit_title'
        expect(page).not_to have_content 'title_post1'
      end
    end
    context '編集をして下書き保存する場合' do
      it '編集後の結果が下書きとして保存される' do
        click_on "編集", match: :first
        find('#task_name').set("edit_title")
        click_on "下書き"
        click_on "edit_title"
        expect(page).to have_content 'edit_title'
        expect(page).to have_content("下書き",count:2)
        expect(page).not_to have_content 'title_post1'
      end
    end
    context '投稿を削除する場合' do
      it '削除されなくなる' do
        accept_alert do
          click_on "削除", match: :first
        end
        expect(page).to have_content 'title_post2'
        expect(page).to have_content '投稿を削除しました'
        expect(page).not_to have_content 'title_post1'
      end
    end
  end
end
