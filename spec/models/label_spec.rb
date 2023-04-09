require 'rails_helper'

RSpec.describe 'ラベルモデル機能', type: :model do
  let!(:user) { FactoryBot.create(:user) }
  describe 'バリデーションのテスト' do
    context 'ラベルの全てが入力されている場合' do
      it '登録される' do
        label = Label.new(name: 'test', user: user)
        expect(label).to be_valid
      end
    end
  end
  describe 'バリデーションのテスト' do
    context 'ラベルの全てが入力されている場合' do
      it '登録される' do
        label = Label.new(name: 'test', user: user)
        expect(label).to be_valid
      end
    end
  end
end
