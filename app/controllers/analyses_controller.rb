class AnalysesController < ApplicationController
  before_action :set_common_variable

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
    
    hash_boxs = {}
    post_boxs.each do |f|
      if hash_boxs[f[0].intern]
        hash_boxs[f[0].intern] += f[1]
      else
        hash_boxs[f[0].intern] = f[1]
      end
    end
    
    post_dates = []
    hash_boxs.each do |key,value|
      post_dates << { name: key.to_s, y: value }
    end

    # グラフ（チャート）を作成 
    @chart1 = LazyHighCharts::HighChart.new("graph") do |c|
      c.title(text: "ラベルの個数")
      # X軸の名称を設定 '月'
      c.xAxis(categories: labels, title: {text: 'ラベル名'})
      c.yAxis(title: {text: '個数'})
      c.series(name: "自分の投稿", data: my_labels_counts)
      c.series(name: "お気に入りの投稿", data: favorite_labels_counts)
      # 判例を右側に配置
      c.legend(align: 'right', verticalAlign: 'top', x: -100, y: 180, layout: 'vertical')
      # グラフの種類を「折れ線グラフ」から「棒グラフ」に変更
      c.chart(type: "column")
    end

    @chart2 = LazyHighCharts::HighChart.new("graph") do |c|
      c.title(text: "ラベル別、嬉しい度による割合")
      c.series({
        colorByPoint: true,
        # ここでは各月の売上額合計をグラフの値とする
        data: post_dates
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

    @public_boxs = []
    @secret_boxs = []
    @deeply_boxs = []
    ng_word = ["こと","よう","あと"]
    texts = my_posts
    mecab = Natto::MeCab.new("-Ochasen")
    texts.each do |t|
      mecab.parse(t.detail.public) do |n|
        if n.feature.include?("名詞"||"動詞")
          @public_boxs  << "#{n.surface}" unless n.surface.size == 1 || ng_word.any?(n.surface)
        end
      end
      mecab.parse(t.detail.secret) do |n|
        if n.feature.include?("名詞"||"動詞")
          @secret_boxs  << "#{n.surface}" unless n.surface.size == 1 || ng_word.any?(n.surface)
        end
      end
      mecab.parse(t.detail.deeply) do |n|
        if n.feature.include?("名詞"||"動詞")
          @deeply_boxs  << "#{n.surface}" unless n.surface.size == 1 || ng_word.any?(n.surface)
        end
      end
    end

    posts_count = my_posts.count

    i = 0
    str = ""
    my_labels.each do |l|
      str << "#{l}は#{my_labels_counts[i]}個、"
      i += 1
    end

    @query = "楽しい、嬉しいと思うことに対して、#{posts_count}件投稿した際にラベルをそれぞれ、#{str}、のラベルが付けられました。自分はどのようなものに好きだと思っているか教えてください。"
    response = @client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [{ role: "user", content: @query }],
      }
    )
    @charts = response.dig("choices", 0, "message", "content")
  end
end
