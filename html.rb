def html(params)
  email = params[:email]
  low_sent_score, low_sent_title, low_sent_link = params[:low_sent].split("^")
  high_sent_score, high_sent_title, high_sent_link = params[:high_sent].split("^")
  avg_sent = params[:avg_sent]
  high_buy_price, high_buy_time = params[:high_buy].split("^")
  avg_buy_price = params[:avg_buy]
  low_buy_price, low_buy_time = params[:low_buy].split("^")

  high_sell_price, high_sell_time = params[:high_sell].split("^")
  avg_sell_price = params[:avg_sell]
  low_sell_price, low_sell_time = params[:low_sell].split("^")
  return <<-eos
  <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
  <html xmlns="http://www.w3.org/1999/xhtml">
    <head>
      <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
      <meta name="viewport" content="width=device-width"/>
      <style type="text/css">
        body {
          font-family:Helvetica Neue;
        }
        h1, h3, p, .center{
          text-align:center;
        }
        p {
          font-size:10px;
        }
        td {
          padding-bottom:10px;
        }
        a {
          text-decoration:none;
        }
        /* Your custom styles go here */

      </style>
    </head>
    <body>
      <h1>The Daily Bit</h1>
      <h3>#{Date.today.to_s}</h3>
        <p> by james's computer </p>
        <hr width="400px">
      <table class="the" align="center" width="600px">
        <tr>
          <td align="center" colspan="2"><b>High Sentiment</b></td>
        </tr>
        <tr>
          <td><a href="#{high_sent_link}">#{high_sent_title}</a></td>
          <td style="color:green;">#{high_sent_score}</td>
        </tr>
        <tr>
          <td align="center" colspan="2"><b>Average Sentiment</b></td>
        </tr>
        <tr>
          <td align="center" colspan="2" style="color:blue;">#{avg_sent}</td>
        </tr>
        <tr>
          <td align="center" colspan="2"><b>Low Sentiment</b></td>
        </tr>
        <tr>
          <td><a href="#{low_sent_link}">#{low_sent_title}</a></td>
          <td style="color:red;">#{low_sent_score}</td>
        </tr>
        <tr>
          <td align="center" colspan="2"><b>Buying</b></td>
        </tr>
        <tr>
          <td>High price was $#{high_buy_price} at #{high_buy_time}.</td>
        </tr>
        <tr>
          <td>Average price was $#{avg_buy_price}.</td>
        </tr>
        <tr>
          <td>Low price was $#{low_buy_price} at #{low_buy_time}.</td>
        </tr>
        <tr>
          <td align="center" colspan="2"><b>Selling</b></td>
        </tr>
        <tr>
          <td>High price was $#{high_sell_price} at #{high_sell_time}.</td>

        </tr>
        <tr>
          <td>Average price was $#{avg_sell_price}.</td>
        </tr>
        <tr>
          <td>Low price was $#{low_sell_price} at #{low_sell_time}.</td>
        </tr>
      </table>
      <hr width="400px">
      <p><a href="https://github.com/semaj/autocoin">source</a> | data collected from coinbase, google news | <a href="http://192.241.234.213/dailybit/dailybit.php?action=unsubscribe&email=#{email}">unsubscribe</a></p>
    </body>
  </html>
  eos
end
