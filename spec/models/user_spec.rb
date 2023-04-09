require 'rails_helper'

RSpec.describe 'ユーザーモデル機能', type: :model do
  describe 'バリデーションのテスト' do
    context 'ユーザーの情報が全て入っている場合' do
      it '登録できる' do
        user = User.new(name: 'test', email: 'test@test.com', password: 'password')
        expect(user).to be_valid
      end
    end
    context 'ユーザーの名前が空の場合' do
      it 'バリデーションにひっかる' do
        user = User.new(name: '', email: 'test@test.com', password: 'password')
        expect(user).not_to be_valid
      end
    end
    context 'ユーザーのemailが空の場合' do
      it 'バリデーションにひっかる' do
        user = User.new(name: 'test', email: '', password: 'password')
        expect(user).not_to be_valid
      end
    end
    context 'ユーザーのemailがemailではない場合' do
      it 'バリデーションにひっかる' do
        user = User.new(name: 'test', email: 'test', password: 'password')
        expect(user).not_to be_valid
      end
    end
    context 'ユーザーのpasswordが空の場合' do
      it 'バリデーションにひっかる' do
        user = User.new(name: 'test', email: 'test@test.com', password: '')
        expect(user).not_to be_valid
      end
    end
    context 'ユーザーのpasswordが5文字の場合' do
      it 'バリデーションにひっかる' do
        user = User.new(name: 'test', email: 'test@test.com', password: 'passw')
        expect(user).not_to be_valid
      end
    end
  end
end
