require 'rails_helper'

RSpec.describe "お気に入り機能", type: :system do
  describe 'お気に入りの登録テスト' do
    let!(:user){ FactoryBot.create(:user) }
    let!(:user2){ FactoryBot.create(:user, name: "user2", email: "user2@test.com")}
    let!(:post1){ FactoryBot.create(:post,user: user)}
    let!(:detail1){ FactoryBot.create(:detail, post: post1)}
    let!(:post2){ FactoryBot.create(:post, title: "title_post2", user: user2)}
    let!(:detail2){ FactoryBot.create(:detail, post: post2)}
    let!(:post3){ FactoryBot.create(:post, title: "title_post3", user: user2)}
    let!(:detail3){ FactoryBot.create(:detail, post: post3)}
    before do
      sign_in(user)
    end
    context 'お気に入りの登録をした場合' do
      it 'お気に入りの新規登録ができる' do
        click_on "title_post2"
        click_on "お気に入り登録"
        expect(page).to have_content "お気に入りに登録しました"
        expect(page).to have_content "お気に入り解除"
      end
    end
    context 'お気に入りの解除をした場合' do
      it 'お気に入りの解除ができる' do
        click_on "title_post2"
        click_on "お気に入り登録"
        expect(page).to have_content "お気に入りに登録しました"
        expect(page).to have_content "お気に入り解除"
        sleep 1.0
        click_on "お気に入り解除"
        expect(page).to have_content "お気に入りの解除をしました"
        expect(page).to have_content "お気に入り登録"
      end
    end
    context '自分の投稿にお気に入り登録しようとした場合' do
      it 'お気に入りの登録ができない' do
        click_on "title_post1"
        expect(page).not_to have_content "お気に入り登録"
      end
    end
  end
  describe 'お気に入りの一覧表示テスト' do
    let!(:user){ FactoryBot.create(:user) }
    let!(:user2){ FactoryBot.create(:user, name: "user2", email: "user2@test.com")}
    let!(:post1){ FactoryBot.create(:post,user: user)}
    let!(:detail1){ FactoryBot.create(:detail, post: post1)}
    let!(:post2){ FactoryBot.create(:post, title: "title_post2", user: user2)}
    let!(:detail2){ FactoryBot.create(:detail, post: post2)}
    let!(:post3){ FactoryBot.create(:post, title: "title_post3", user: user2)}
    let!(:detail3){ FactoryBot.create(:detail, post: post3)}
    before do
      sign_in(user)
    end
    context 'お気に入りの一覧を見た場合' do
      it 'お気に入り登録したデータが一覧に表示できる' do
        click_on "title_post2"
        click_on "お気に入り登録"
        visit favorites_path
        expect(page).to have_content "title_post2"
        expect(page).not_to have_content "title_post3"
      end
    end
  end
end
