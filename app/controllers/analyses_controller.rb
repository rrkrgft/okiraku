class AnalysesController < ApplicationController
  before_action :set_common_variable

  def index
    @user = User.find_by(id: current_user.id)
    # 投稿の一覧とラベルの投稿数を抽出
    my_labels = Label.where(user_id: current_user.id).pluck(:name)
    my_posts_labels = current_user.posts.includes(:labels)
    my_posts_details = current_user.posts.includes(:detail)
    my_labels_lists = my_posts_labels.map{ |n| n.labels.pluck(:name) }.flatten
    
    # お気に入りに登録したデータのラベルによる抽出
    favorites = current_user.favorites.pluck(:post_id) #ユーザーのお気に入り番号
    favorite_posts = Post.where(id: favorites).where(draft: false) #お気に入り投稿
    favorite_labels_lists = favorite_posts.map{ |f| f.labels.pluck(:name) }.flatten
    favorite_labels = favorite_labels_lists.uniq

    # chart1表で以下３つのデータを使用
    labels = favorite_labels | my_labels
    my_labels_counts = labels.map{ |l| my_labels_lists.count(l) }
    favorite_labels_counts = labels.map{ |l| favorite_labels_lists.count(l) }

    # 投稿のラベルと嬉しい度による重みづけによるデータの抽出
    post_boxs = []
    my_posts_labels.each do |f|
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
    
    post_dates = hash_boxs.map{ |key,value| { name: key.to_s, y: value }}

    # グラフ（チャート）を作成 
    @chart1 = LazyHighCharts::HighChart.new("graph") do |c|
      c.title(text: "ラベルの個数")
      c.xAxis(categories: labels, title: {text: 'ラベル名'})
      c.yAxis(title: {text: '個数'})
      c.series(name: "自分の投稿", data: my_labels_counts)
      c.series(name: "お気に入り投稿", data: favorite_labels_counts)
      # 判例を右側に配置
      c.legend(align: 'right', verticalAlign: 'top', x: -100, y: 180, layout: 'vertical')
      # グラフの種類を「折れ線グラフ」から「棒グラフ」に変更
      c.chart(type: "column")
    end

    @chart2 = LazyHighCharts::HighChart.new("graph") do |c|
      c.title(text: "ラベル別、嬉しい度による割合")
      c.series({
        colorByPoint: true,
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

    # ここからテキストマイニングに関係するコード
    @words_boxs = []
    ng_word = ["こと","よう","あと"]
    mecab = Natto::MeCab.new("-Ochasen")

    my_posts_details.each do |t|
      mecab.parse(t.detail.public) do |n|
        if n.feature.include?("名詞"||"動詞")
          @words_boxs << "#{n.surface}" unless n.surface.size == 1 || ng_word.any?(n.surface)
        end
      end
      mecab.parse(t.detail.secret) do |n|
        if n.feature.include?("名詞"||"動詞")
          @words_boxs << "#{n.surface}" unless n.surface.size == 1 || ng_word.any?(n.surface)
        end
      end
      mecab.parse(t.detail.deeply) do |n|
        if n.feature.include?("名詞"||"動詞")
          @words_boxs << "#{n.surface}" unless n.surface.size == 1 || ng_word.any?(n.surface)
        end
      end
    end

    # ここからchatGPTに対するコード関係
    unless params[:gpt] == "no_gpt"
      posts_count = my_posts_details.count

      str = ""
      my_labels.each_with_index do |l,i|
        str << "#{l}は#{my_labels_counts[i]}個、"
      end
      binding.pry

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
end
