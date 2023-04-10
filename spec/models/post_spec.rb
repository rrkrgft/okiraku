require 'rails_helper'

RSpec.describe 'ポストモデル機能', type: :model do
  let!(:user) { FactoryBot.create(:user) }
  describe 'バリデーションのテスト' do
    context 'ポストの情報が全て入っている場合' do
      it '登録できる' do
        post = Post.new(title: 'test', score: '50', draft: 'false', user: user)
        expect(post).to be_valid
      end
    end
    context 'ポストのタイトルが入っていない場合' do
      it 'バリデーションに引っかかる' do
        post = Post.new(title: '', score: '50', draft: 'false', user: user)
        expect(post).not_to be_valid
      end
    end
    context 'ポストのスコアが１００を超えている場合' do
      it 'バリデーションに引っかかる' do
        post = Post.new(title: 'test', score: '101', draft: 'false', user: user)
        expect(post).not_to be_valid
      end
    end
    context 'ポストのスコアがマイナスの場合' do
      it 'バリデーションに引っかかる' do
        post = Post.new(title: 'test', score: '-1', draft: 'false', user: user)
        expect(post).not_to be_valid
      end
    end
  end
end
