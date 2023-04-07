class AnalysesController < ApplicationController
  def index
    @user = User.find_by(id: current_user.id)
    # 投稿の一覧とラベルの投稿数を抽出
    my_labels = Label.where(user_id: current_user.id).pluck(:name)
    my_posts = Post.where(user_id: current_user.id)
    my_labels_lists = []
    post_scores = []
    my_posts.each do |p|
      my_labels_lists << p.labels.pluck(:name)
      post_scores << p
    end
    
    my_labels_lists.flatten!
    
    # お気に入りに登録したデータのラベルによる抽出
    favorites = Favorite.where(user_id: current_user.id).pluck(:post_id)
    favorite_posts = Post.where(id: favorites).where(draft: false)
    favorite_labels_lists = []
    favorite_posts.each do |f|
      favorite_labels_lists << f.labels.pluck(:name)
    end
    favorite_labels_lists.flatten!
    favorite_labels = favorite_labels_lists.uniq
    
    labels = favorite_labels | my_labels
    
    favorite_labels_counts = []
    my_labels_counts = []
    
    labels.each do |l|
      my_labels_counts << my_labels_lists.count(l)
      favorite_labels_counts << favorite_labels_lists.count(l)
    end

    # 投稿のラベルと嬉しい度による重みづけによるデータの抽出
    post_boxs = []
    post_scores.each do |f|
      f.labels.pluck(:name).each do |l|
        post_boxs << [l,(f.score)]
      end
    end
    
    

    months = [ 4, 5, 6, 7, 8, 9 ]
    product_A_sales = [ 1_000_000, 1_200_000, 1_300_000,
      1_400_000, 1_200_000, 1_100_000 ]
    product_B_sales = [   300_000,   500_000,   750_000,
      1_150_000, 1_350_000, 1_600_000 ] 
    # グラフ（チャート）を作成 
    @chart1 = LazyHighCharts::HighChart.new("graph") do |c|
      c.title(text: "ラベルの個数")
      # X軸の名称を設定 '月'
      c.xAxis(categories: my_labels, title: {text: 'ラベル名'})
      c.yAxis(title: {text: '個数'})
      c.series(name: "自分の投稿", data: my_labels_counts)
      c.series(name: "お気に入りの投稿", data: favorite_labels_counts)
      # 判例を右側に配置
     c.legend(align: 'right', verticalAlign: 'top', 
       x: -100, y: 180, layout: 'vertical')
     # グラフの種類を「折れ線グラフ」から「棒グラフ」に変更
     c.chart(type: "column")
    end

    @chart2 = LazyHighCharts::HighChart.new("graph") do |c|
      c.title(text: "製品別上期売上")
      c.series({
        colorByPoint: true,
        # ここでは各月の売上額合計をグラフの値とする
        data: [{
name: 'A',
y: product_A_sales.reduce{|sum,e| sum + e}
}, {
name: 'B', 
y: product_B_sales.reduce{|sum,e| sum + e}
}]
      })
      c.plotOptions(pie: {
        allowPointSelect: true,
        cursor: 'pointer',
        dataLabels: {
          enabled: true,
          format: '{point.name}: {point.percentage:.1f} %',
        }
      })
      # グラフの種類として「パイチャート」を指定
      c.chart(type: "pie")
   end
  end
end
