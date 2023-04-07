class AnalysesController < ApplicationController
  def index
    # (...データベースからのデータ取得処理...)
    # ダミーのデータを用意
    months = [ 4, 5, 6, 7, 8, 9 ]
    product_A_sales = [ 1_000_000, 1_200_000, 1_300_000,
      1_400_000, 1_200_000, 1_100_000 ]
    product_B_sales = [   300_000,   500_000,   750_000,
      1_150_000, 1_350_000, 1_600_000 ] 
    # グラフ（チャート）を作成 
    @chart1 = LazyHighCharts::HighChart.new("graph") do |c|
      c.title(text: "4-9月売上")
      # X軸の名称を設定 '月'
      c.xAxis(categories: months, title: {text: '月'})       # Y軸の名称を設定 '円'
      c.yAxis(title: {text: '円'})
      c.series(name: "A", data: product_A_sales)
      c.series(name: "B", data: product_B_sales)
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
