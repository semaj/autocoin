require 'sentimental'
require 'date'
require 'sqlite3'

db = SQLite3::Database.new("forbes.db")
Sentimental.load_defaults
analyzer = Sentimental.new
scores = Hash.new
db.execute("SELECT body, date FROM data;") do |body, date|
  day, month, year = date.split("/")
  begin 
    date = Date.new(year.to_i,day.to_i,month.to_i)
    scores[date] = analyzer.get_score(body)
  rescue ArgumentError => e

  end
end
scores.keys.sort.each do |k|
  puts k.to_s + " : " + scores[k].to_s
end
