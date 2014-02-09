require 'coinbase'
require 'sanitize'
require 'cgi'
require 'htmlentities'
require 'sentimental'
require 'simple-rss'
require 'open-uri'
require 'sqlite3'
require 'date'
require 'mail'

module Tools
  COINBASE = Coinbase::Client.new(ENV['COINBASEKEY'])
  Sentimental.load_defaults
  SENTIMENTAL = Sentimental.new
  HTMLENT = HTMLEntities.new
  LOG = File.open('log.txt', 'w')
  DB = SQLite3::Database.open('bitcoin_reports.db')
  DB.execute("CREATE TABLE IF NOT EXISTS reports(
             ID INTEGER PRIMARY KEY AUTOINCREMENT,
             DATE TEXT,
             HIGH_SENT REAL,
             AVG_SENT REAL,
             LOW_SENT REAL,
             HIGH_BUY REAL,
             AVG_BUY REAL,
             LOW_BUY REAL,
             HIGH_SELL REAL,
             AVG_SELL REAL,
             LOW_SELL REAL,
             NOW TEXT,
             LATER TEXT)")
  def rss
    SimpleRSS.parse(open('http://fulltextrssfeed.com/news.google.com/news?pz=1&cf=all&ned=us&hl=en&q=Bitcoin&output=rss'))
  end

  def insert(params)
    puts params
    DB.execute("INSERT INTO reports(
               DATE,
               HIGH_SENT,
               AVG_SENT,
               LOW_SENT,
               HIGH_BUY,
               AVG_BUY,
               LOW_BUY,
               HIGH_SELL,
               AVG_SELL,
               LOW_SELL,
               NOW,
               LATER) 
               VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
               Date.today.to_s,
               params[:high_sent],
               params[:avg_sent],
               params[:low_sent],
               params[:high_buy].to_f,
               params[:avg_buy],
               params[:low_buy].to_f,
               params[:high_sell].to_f,
               params[:avg_sell],
               params[:low_sell].to_f,
               params[:now].to_s,
               params[:later].to_s)
  end

  def retrieve_by_date(date)
    DB.execute("SELECT * FROM reports WHERE DATE=?", date.to_s)
  end

  def log(text)
    LOG << "#{DateTime.now.to_s}|#{text.to_s}"
  end

  def sell_price
    COINBASE.sell_price(1)
  end

  def buy_price
    COINBASE.buy_price(1)
  end

  def score(dirty_item)
    SENTIMENTAL.get_score(clean(dirty_item.description)) #content = description, weird
  end

  def clean(dirty_content)
    Sanitize.clean(CGI.unescapeHTML(dirty_content).to_s.force_encoding('UTF-8'))
  end
end
    
