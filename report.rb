require './tools'
include Tools

class Report
  
  def initialize
    @sentiments = []
    @buys = []
    @sells = []
  end

  def get_sentiment
    Tools.rss.items.each do |article|
      @sentiments.push(score(article))
    end
  end
  
  def get_buy
    @buys.push(buy_price)
  end

  def get_sell
    @sells.push(sell_price)
  end

  def avg(a)
    a.reduce(:+).to_f / a.size
  end

  def record
    params = Hash.new
    params[:high_sent] = @sentiments.max
    params[:avg_sent] = avg(@sentiments)
    params[:low_sent] = @sentiments.min
    params[:high_buy] = @buys.max
    params[:avg_buy] = avg(@buys)
    params[:low_buy] = @buys.min
    params[:high_sell] = @sells.max
    params[:avg_sell] = avg(@sells)
    params[:low_sell] = @sells.min
    if params[:avg_sent] < -3.0
      params[:now] = "sell"
      params[:later] = "buy"
    elsif params[:avg_sent] > 3.0
      params[:now] = "buy"
      params[:later] = "sell"
    else
      params[:now] = "nothing"
      params[:later] = "nothing"
    end
    Tools.insert(params)
    mail = Mail.new do
      from 'me@test.lindsaar.net'
      to 'jamesfordummies@gmail.com'
      subject 'Magic Time'
      body Tools.retrieve_by_date(Date.today).last.to_s
    end
    mail.delivery_method :sendmail
    mail.deliver
    puts "SENT DAT MAIL"
    @sentiments = []
    @buys = []
    @sells = []
  end
end

