module PostsHelper
  def detail_public_placeholder 
    <<-"EOS".strip_heredoc
      楽しかったこと、嬉しかったことの（以下省略）詳細を記入。
      例：フルーツのたくさんのった美味しいパフェを食べた。しかも値段もそこまで高くなく大満足だった。
    EOS
  end

  def detail_secret_placeholder 
    <<-"EOS".strip_heredoc
      詳細で他の人に見られたくないことを記入。
      例：いいなと思っている人と一緒に行けたのもよかった。
    EOS
  end

  def detail_deeply_placeholder 
    <<-"EOS".strip_heredoc
      詳細で書いたものを楽しいと感じた理由を記入。（見られたくない場合は右にチェック）
      例：美味しいパフェを食べると幸せな気持ちになる。友達と楽しい話ができて仲良くなれて嬉しかった。
    EOS
  end

end
