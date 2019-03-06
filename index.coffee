#
# Name: DarkSky.Widget
# Destination App: Übersicht
# Created: 09.Jan.2019
# Author: Gert Massheimer
#
# === User Settings ===================================================
#======================================================================
#--- standard iconSet is "color" (options are: color, mono)
iconSet = "color"
#
#--- max 7 days for forecast plus today!
numberOfDays = 8
#
#--- max number of weather alerts
numberOfAlerts = 1
#
#--- show weather alerts (show = true ; don't show = false)
#showAlerts = true
showAlerts = false
#
#--- display as "day" or as "text" or as "icon" or as "iconplus" or as "week"
#display = "day"        # Just the banner
#display = "text"       # The banner plus numberOfDays as detailed text
display = "icon"       # The banner plus 7 days as graph (with small icons)
#display = "iconplus"   # The banner plus "icon" plus 3 days of "text"
#display = "week"       # just 7 days as graph (with small icons)
#
#--- location in degrees
latitude = "34.0057742"
longitude = "-84.149144"
#
#--- your location (just for display purpose)
myLocation = 'Duluth, GA'
#
#--- your API-key from DarkSky (https://darksky.net/dev)
apiKey = "xxxxxxxxxxxxxxxxxxxxxxxxxxxx"
#
#--- select the language (possible "de" for German or "en" for English)
lang = 'de' # deutsch
#lang = 'en' # english
#
#--- select how the units are displayed
units = 'ca' # Celsius and km
#units = 'us' # Fahrenheit and miles
#

#=== DO NOT EDIT AFTER THIS LINE unless you know what you're doing! ===
#======================================================================

command: "curl -s 'https://api.darksky.net/forecast/#{apiKey}/#{latitude},#{longitude}?lang=#{lang}&units=#{units}&exclude=minutely,hourly'"

refreshFrequency: '15m' # every 15 minutes

render: ->
  """
  <div class="weather">
    <table><tr>
      <td><div class="image"></div></td>
      <td><div class="text-container">
        <div class="location"></div>
        <div class="conditions"></div>
        <div class="time"></div>
        <div class="wind"></div>
      </div></td>
    </tr></table>
    <div class="forecast"></div>
  </div>
  """

update: (output, domEl) ->

  weatherData = JSON.parse(output)

  if display != 'week'
    # --- show weather condition image
    icon  = '<img style="width:80px;height:80px;margin-right:-1rem;" src="darksky.widget/images/' + iconSet + '/'
    icon += weatherData.currently.icon
    icon += '.png">'
    $(domEl).find('.image').html(icon)

    # --- show weather forecast location
    location = myLocation
    $(domEl).find('.location').html(location)

    # --- show current weather conditions
    current = weatherData.currently.temperature.toFixed(1)
    if lang == 'de' then current += '°C - '
    else current += '°F - '
    current += weatherData.currently.summary
    $(domEl).find('.conditions').html(current)

    # --- show time of last update
    if lang == 'de' then areaCode = 'de-DE'
    else areaCode = 'en-US'
    time = new Date(weatherData.currently.time * 1000).toLocaleDateString(areaCode, { weekday: 'short', year: 'numeric', month: 'short', day: 'numeric', hour: 'numeric', minute: 'numeric' })
    $(domEl).find('.time').html(time)

    # --- show wind conditions
    deg = weatherData.currently.windBearing
    switch
      when deg >= 348.75 && deg <= 11.25
        if lang == 'de' then w = 'Nord'
        else w = 'North'
      when deg >= 11.25 && deg <= 33.75
        if lang == 'de' then w = 'Nord-Nordost'
        else w = 'North-NorthEast'
      when deg >= 33.75 && deg <= 56.25
        if lang == 'de' then w = 'Nordost'
        else w = 'North-East'
      when deg >= 56.25 && deg <= 78.75
        if lang == 'de' then w = 'Ost-Nordost'
        else w = 'East-NorthEast'
      when deg >= 78.75 && deg <= 101.25
        if lang == 'de' then w = 'Ost'
        else w = 'East'
      when deg >= 101.25 && deg <= 123.75
        if lang == 'de' then w = 'Ost-Südost'
        else w = 'East-SouthEast'
      when deg >= 123.75 && deg <= 146.25
        if lang == 'de' then w = 'Südost'
        else w = 'South-East'
      when deg >= 146.25 && deg <= 168.75
        if lang == 'de' then w = 'Süd-Südost'
        else w = 'South-SouthEast'
      when deg >= 168.75 && deg <= 191.25
        if lang == 'de' then w = 'Süd'
        else w = 'South'
      when deg >= 191.25 && deg <= 213.75
        if lang == 'de' then w = 'Süd-Südwest'
        else w = 'South-SouthWest'
      when deg >= 213.75 && deg <= 236.25
        if lang == 'de' then w = 'Südwest'
        else w = 'South-West'
      when deg >= 236.25 && deg <= 258.75
        if lang == 'de' then w = 'West-Südwest'
        else w = 'West-SouthWest'
      when deg >= 258.75 && deg <= 281.25
        if lang == 'de' then w = 'West'
        else w = 'West'
      when deg >= 281.25 && deg <= 303.75
        if lang == 'de' then w = 'West-Nordwest'
        else w = 'West-NorthWest'
      when deg >= 303.75 && deg <= 326.25
        if lang == 'de' then w = 'Nordwest'
        else w = 'North-West'
      when deg >= 326.25 && deg <= 348.75
        if lang == 'de' then w = 'Nord-Nordwest'
        else w = 'North-NorthWest'

    currentWind = weatherData.currently.windSpeed.toFixed(1)
    if units == 'ca'
      windGust = weatherData.currently.windGust.toFixed(1) + ' km/h'
    else
      windGust = weatherData.currently.windGust.toFixed(1) + ' mph'
    if lang == 'de'
      wind  = 'Wind: '
      wind += currentWind
      wind += ' - '
      wind += windGust
      wind += ' aus ' + w
    else
      wind  = 'Winds from '
      wind += w
      wind += ' at '
      wind += currentWind
      wind += ' - '
      wind += windGust
    $(domEl).find('.wind').html(wind)

  # --- generate weather alert message only if there is alert
  forecast = ''; dayMaxTemp = 0; weekMaxTemp = 0;
  if weatherData.hasOwnProperty('alerts') && showAlerts == true
    if numberOfAlerts < weatherData.alerts.length then maxAlerts = numberOfAlerts
    else maxAlerts = weatherData.alerts.length

    for i in [0..maxAlerts-1]

      alertTitle = weatherData.alerts[i].title

      if lang == 'de' then areaCode = 'de-DE'
      else areaCode = 'en-US'
      alertTime    = new Date(weatherData.alerts[i].time * 1000).toLocaleDateString(areaCode, { weekday: 'short', year: 'numeric', month: 'short', day: 'numeric', hour: 'numeric', minute: 'numeric' })
      alertExpires = new Date(weatherData.alerts[i].expires * 1000).toLocaleDateString(areaCode, { weekday: 'short', year: 'numeric', month: 'short', day: 'numeric', hour: 'numeric', minute: 'numeric' })

      alertDescription = weatherData.alerts[i].description
      alertRegions = weatherData.alerts[i].regions

      alertSeverity = weatherData.alerts[i].severity
      switch alertSeverity
        when 'advisory'
          alertSeverity = 0
          levelCSS = 'alert-level0'
        when 'watch'
          alertSeverity = 1
          levelCSS = 'alert-level1'
        when 'warning'
          alertSeverity = 2
          levelCSS = 'alert-level2'

      if lang == 'de'
        alertSeverity = ['Niedrig', 'Mittel', 'Hoch'][alertSeverity];
      else
        alertSeverity = ['Low', 'Middle', 'High'][alertSeverity];

      # --- show the weather alert(s)
      style = ' style="max-width:25rem;padding-bottom:1.5rem;"'
      forecast += '<table style="max-width:35rem;"><tr><td style="vertical-align:top;padding-top:1rem">'
      forecast += '<img src="darksky.widget/images/alert/alert.gif" alt="" />'
      forecast += '</td><td' + style + '>'
      forecast += '<span class="alert-type">'
      forecast += alertTitle
      forecast += '</span>'

      forecast += '<br><span class="alert-region">'
      if lang == 'de' then forecast += 'Region(en): '
      else forecast += ' Region(s): '
      forecast += alertRegions + '</span>'

      forecast += '<br><span class="alert-level">'
      if lang == 'de' then forecast += 'Gefahrenstufe:</span> '
      else forecast += ' Severity Level:</span> '
      forecast += '<span class="' + levelCSS + '">' + alertSeverity + '</span>'

      forecast += '<br><span class="alert-start">'
      if lang == 'de' then forecast += 'Begint: '
      else forecast += 'Starts: '
      forecast += '</span><span class="alert-starttime">'
      forecast += alertTime
      forecast += '</span>'

      forecast += '<br><span class="alert-expires">'
      if lang == 'de' then forecast += 'Endet: '
      else forecast += 'Expires: '
      forecast += '</span><span class="alert-endtime">'
      forecast += alertExpires
      forecast += '</span></td></tr>'

      forecast += '<tr><td colspan="2"><span class="alert-desc">'
      forecast += alertDescription + '</span>'
      forecast = forecast.replace(/\n/g, " ")
      forecast = forecast.replace(/\*/g, "<br>* ")

      forecast += '</td></tr></table>'
      $(domEl).find('.forecast').html(forecast)

  # --- generate the eight days weather columns
  else
    if numberOfDays > 8 then numberOfDays = 8
    if numberOfDays < 1 then numberOfDays = 1

    if display == 'icon' or display == 'iconplus' or display == 'week'
      numberOfDays = 8

      if units == 'ca'
        forecast += '<table><tr>'
      else
        forecast += '<table class="table-bar"><tr>'

      # compute the hottest temperature of the forecast range to set the highest position of the dayBar
      for i in [0..numberOfDays-1]
        dayMaxTemp = Math.round(weatherData.daily.data[i].temperatureHigh)
        if weekMaxTemp <= dayMaxTemp then weekMaxTemp = dayMaxTemp

      for i in [0..numberOfDays-1]
        dayMin = Math.round(weatherData.daily.data[i].temperatureLow.toFixed(1))
        dayMax = Math.round(weatherData.daily.data[i].temperatureHigh.toFixed(1))
        if units == 'ca' then pos = 75
        else pos = 120
        wDayShort   = new Date(weatherData.daily.data[i].time * 1000).getDay()
        if lang == 'de'
          wDayShort = ['So', 'Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa'][wDayShort];
        else
          wDayShort = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'][wDayShort];

        dayIconName = weatherData.daily.data[i].icon
        dayIcon = 'darksky.widget/images/' + iconSet + '/' + dayIconName + '.png'

        wDayBar = (weekMaxTemp - (dayMax * 2)) + pos # position of the bar from top
        dayBar  = (dayMax - dayMin + 5) * 2          # length / height of the bar
        
        # --- show the temperature columns
        forecast += '<td class="weekday-col"><div class="weekday-name">'
        if lang == 'de' then today = 'Heute'
        else today = 'Today'
        if i == 0 then forecast += today
        else forecast += wDayShort
        forecast += '</div><div class="weekday-icon"><img style="height:30px;width:30px;" src="'
        forecast += dayIcon
        forecast += '" alt="" /></div><div class="wdb" style="top:'
        forecast += wDayBar
        forecast += 'px;">'
        forecast += '<span class="temp-high" style="line-height:1.8">' + dayMax + '°</span>'
        forecast += '<br /><div class="db" style="height: '
        forecast += dayBar
        forecast += 'px;">'
        forecast += '</div><br />'
        forecast += '<span class="temp-low" style="line-height:1.4">' + dayMin + '°</span>'
        forecast += '</div></td>'

      forecast += '</tr></table>'
  
      if display is 'icon' or display == 'iconplus' or display == 'week'
        $(domEl).find('.forecast').html(forecast)

    # --- generate the weather messages and put the condition icon in front
    if display == 'text' or display == 'iconplus'
      if display == 'iconplus' then numberOfDays = 3
      for i in [0..numberOfDays-1]

        dayMin     = weatherData.daily.data[i].temperatureLow.toFixed(1)
        dayMax     = weatherData.daily.data[i].temperatureHigh.toFixed(1)
        summary    = weatherData.daily.data[i].summary
        humidity   = weatherData.daily.data[i].humidity * 100 + '%'
        visibility = weatherData.daily.data[i].visibility.toFixed(1)
        if units == 'ca' then unit = '°C'
        else unit = '°F'

        weekDay  = new Date(weatherData.daily.data[i].time * 1000).getDay()
        if lang == 'de'
          wDayShort = ['So', 'Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa'][weekDay];
          wDayLong  = ['Sontag', 'Montag', 'Dienstag', 'Mittwoch', 'Donnerstag', 'Freitag', 'Samstag'][weekDay];
        else
          wDayShort = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'][weekDay];
          wDayLong  = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'][weekDay];

        dayIconName = weatherData.daily.data[i].icon
        dayIcon     = 'darksky.widget/images/' + iconSet + '/' + dayIconName + '.png'

        # --- show the weather messages
        if display != 'iconplus' then style = ' style="max-width:25rem;"'
        else style = ' style="max-width:19rem;"'
        forecast += '<table><tr><td' + style + '>'
        forecast += '<img src="' + dayIcon + '" style="height:50px;width:50px;">'
        forecast += '</td><td' + style + '>'

        forecast += '<span class="headline">'
        if i == 0
          if lang == 'de' then forecast += 'Heute'
          else forecast += 'Today'
          forecast += ' (' + wDayShort + '):'
        else forecast += wDayLong
        forecast += '</span> <span class="temp-low">'

        forecast += dayMin + unit + '</span> - <span class="temp-high">' + dayMax + unit + '</span>'
        forecast += '<br><span class="summary">' + summary + '</span>'

        if lang == 'de'
          forecast += '<br> Luftfeuchtigkeit: ' + humidity
          forecast += ' / Sichtweite: ' + visibility + 'km'
        else
          forecast += '<br> Humidity: ' + humidity
          forecast += ' / Visibility: ' + visibility + 'mi'
        forecast += '</td></tr></table>'

      $(domEl).find('.forecast').html(forecast)

# --- style settings
style: """
  // position of the widget on the screen
  top 8%
  left 2%

  font-family system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto",
    "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue",
    sans-serif

  table
    border-spacing 0
    padding 0
    margin 0
    max-width 28rem

  th, td
    padding 0.1rem 0.5rem;
    margin 0

  td
    display table-cell
    max-width 16rem
    vertical-align middle

  .forecast
    color #c1e1f1
    font-weight 400
    font-size .7rem

  .weather
    border 1px solid #4f4f4f
    border-radius 20px
    background rgba(#000, .2)
    overflow-y scroll;
    padding .5rem

  .text-container
    padding 15px
    float right

  .image-container
    padding 0
    float left

  .location
    color #26b6d0
    font-weight 400
    font-size 1.25rem

  .conditions
    color #26b6d0
    font-weight bold
    font-size .9rem

  .time
    color #93cdda
    font-weight bold
    font-size .75rem
    padding-top .2rem
    padding-bottom .2rem

  .headline
    color #78d8ff
    font-weight 400
    font-size .8rem

  .temp-low
    color #5ebadc
    font-weight 500
    font-size .8rem

  .temp-high
    color #e22e4f
    font-weight 500
    font-size .8rem

  .summary
    color #26b6d0
    font-weight 500
    font-size .75rem

  .image
    float left
    padding 5px 10px 0 10px

  .wind
    color #c1e1f1
    font-size .75rem
    font-weight 300

  // Styles for display = icon

  .table-bar
    padding-bottom 2rem

  .weekday-col
    position relative
    color #fff
    height 10rem
    width 2rem
    white-space nowrap
    text-align center

  .weekday-name
    position absolute
    top 0
    height 1rem
    width 2rem
    font-weight 500

  .weekday-icon
    position absolute
    top 1rem
    height 2rem
    width 2rem

  .wdb
    position absolute
    height 4rem
    width 2rem

  .db
    background-color #fff
    display inline-block
    width .5rem
    padding .2rem
    border-radius .5rem
    border 2px solid #5ebadc

  // Styles for alerts

  .alert-type
    color #e22e4f
    font-weight 800
    font-size 1.4rem
    line-height 1.5

  .alert-region
    color #ddd
    font-weight 300
    font-size .9rem
    line-height 1.5

  .alert-level
    color #ddd
    font-weight 300
    font-size 1rem
    line-height 1.5

  .alert-level0
    color #00f900
    font-size 1rem

  .alert-level1
    color #ffc543
    font-size 1rem

  .alert-level2
    color #db2d36
    font-size 1rem

  .alert-start,
  .alert-expires
    color #ddd
    font-weight 400
    font-size .8rem
    line-height 1.3

  .alert-starttime,
  .alert-endtime
    color #e2ba2e
    font-weight 300
    font-size .8rem
    line-height 1.3

  .alert-desc
    color #c1e1f1
    font-weight 300
    font-size .8rem
    line-height 1.5
"""
