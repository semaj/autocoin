require './tools'
require './report'
require 'daemons'

report = Report.new
while true
  report.get_buy
  report.get_sell
  #if Time.now.hour == 24 
    report.get_sentiment
    report.record
  #end
  sleep(3600) #run every hour
end
