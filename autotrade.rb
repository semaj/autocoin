require 'coinbase'
require 'sanitize'
require 'cgi'
require 'htmlentities'
require 'sentimental'
require 'simple-rss'
require 'open-uri'
require 'sqlite3'

@db = SQLite3::Database.open('instructions.db')
@db.execute("CREATE TABLE IF NOT EXISTS instructions2(Id INTEGER PRIMARY KEY AUTOINCREMENT, Date TEXT, Do_now TEXT, Do_later TEXT, Buy_price TEXT, Sell_price TEXT)")
@rss = SimpleRSS.parse(open('http://fulltextrssfeed.com/news.google.com/news?pz=1&cf=all&ned=us&hl=en&q=Bitcoin&output=rss'))
@coinbase = Coinbase::Client.new(ENV['COINBASEKEY'])
@coder = HTMLEntities.new
Sentimental.load_defaults
@analyzer = Sentimental.new
@ran_today = false
@scores_today = []

def check_sentiment
  @ran_today = true
  @rss.items.each do |item|
    @scores_today.push(@analyzer.get_score(clean(item.description)))
  end
  react_sentiment
end

def react_sentiment
  avg = @scores_today.reduce(:+).to_f / @scores_today.size
  do_now = :nothing
  do_later = :nothing
  #if negative, sell now, buy when low
  if avg > 3.0
    do_now = :buy
    do_later = :sell
  elsif avg < -2.0
    do_now = :sell
    do_later = :buy
  end
  puts "sentiment: " + avg.to_s
  method(do_now).call
  @db.execute("INSERT INTO instructions2(Date, Do_now, Do_later, Buy_price, Sell_price) VALUES (?, ?, ?, ?, ?)", Date.today.to_s, do_now.to_s, do_later.to_s, check_buy.to_s, check_sell.to_s)
end

def buy
  puts "would buy at " + check_buy.to_s + " at " + Date.today.to_s
end

def sell
  puts "would sell at " + check_sell.to_s + " at " + Date.today.to_s
end

def nothing
  puts "would do nothing at " + Date.now.to_s
end

def check_sell
  @coinbase.sell_price(1)
end

def check_buy
  @coinbase.buy_price(1)
end

def clean(stuff)
  return Sanitize.clean(CGI.unescapeHTML(stuff).to_s.force_encoding('UTF-8'))
end

check_sentiment
@ran_today = true
while true
  if Time.now.hour == 23 and not @ran_today
    check_sentiment
  elsif Time.now.hour == 24
    @ran_today = false
    @scores_today = []
  end
end
