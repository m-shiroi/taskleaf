require 'rails_helper'

describe 'タスク管理機能', type: :system do
  let(:user_a) { FactoryBot.create(:user, name: 'ユーザA', email: 'a@jp') }
  let(:user_b) { FactoryBot.create(:user, name: 'ユーザB', email: 'b@jp') }
  let!(:task_a) { FactoryBot.create(:task, name: 'ユーザAの最初のタスク', user: user_a) }
  let(:name) { "simple name" } # https://stackoverflow.com/questions/45439673/rspec-mocking-name-not-available-from-within-an-example-group
  
  before do
    # ユーザAを作成しておく
    # FactoryBot.buildだと未保存のオブジェクト
#      user_a = FactoryBot.create(:user)
#      user_a = FactoryBot.create(:user, name: 'ユーザA', email: 'a@jp')
    
    # ユーザAのタスクを作成しておく
#      FactoryBot.create(:task, name: 'ユーザAの最初のタスク', user: user_a)
    
    # 1.ログイン画面にアクセス
    visit login_path
    # 2.メールアドレス入力
#      fill_in 'Email', with: 'a@jp'
    fill_in 'Email', with: login_user.email
    # 3.パスワード入力
    fill_in 'パスワード', with: login_user.password
    # 4.ログインボタン押下
    click_button 'ログインする'
  end
  
  # itの共通化
  shared_examples_for 'ユーザAのタスクが表示される' do
    # 作成済のタスクの名称が画面上に表示されていることを確認
    it { expect(page).to have_content 'ユーザAの最初のタスク' }
  end
  
  describe '一覧表示機能' do
 
    context 'ユーザAがログインしている時' do
      let(:login_user) { user_a }
        
#      it 'ユーザAのタスクが表示される' do
#        # 作成済のタスクの名称が画面上に表示されていることを確認
#        expect(page).to have_content 'ユーザAの最初のタスク'
#      end
      it_behaves_like 'ユーザAのタスクが表示される'
    end
    
    context 'ユーザBがログインしている時' do
      let(:login_user) { user_b }
        
#      before do
#        # ユーザBを作成＆ログイン
#        user_b = 
#        visit login_path
#        fill_in 'Email', with: 'b@jp'
#        fill_in 'パスワード', with: 'password'
#        click_button 'ログインする'
#      end
      it 'ユーザAのタスクが表示されない' do
        # ユーザAのタスクが画面上に表示されていることを確認
        expect(page).to have_no_content 'ユーザAの最初のタスク'
      end
    end
  end
  
  describe '詳細表示機能' do
    context 'ユーザAがログインしている時' do
      let(:login_user) { user_a }

      before do
        visit task_path(task_a)
      end
      
      it_behaves_like 'ユーザAのタスクが表示される'
    end
  end
  
  describe '新規登録' do
    let(:login_user) { user_a }
    
    before do
      visit new_task_path
      fill_in '名称', with: task_name # task_nameは後続で定義
      click_button '登録する'
    end
    
    context '名称を入力した時' do
      let(:task_name) { '新規作成のテストケースを書く' }
      
      it '正常登録' do
        # have_selectorはHTML内の要素を取得する
        # 下記では'.alert-success'というclassのテキストを比較
        expect(page).to have_selector '.alert-success', text: '新規作成のテストケースを書く'
      end
    end
    
    context '名称を入力しなかった時' do
      let(:task_name) { '' }
        
      it 'エラー' do
        # 'error_explanation'というidの要素を比較
        within '#error_explanation' do
          expect(page).to have_content '名称 を入力してください'
        end
      end
    end
  end
end