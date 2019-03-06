# DarkSky Widget
([Zur deutschen Version][1])  
A Übersicht widget to display the current weather for a location along with the option of a single and up to a 8-day forecast. To use it you need a apiKey from [darksky][2], which can be obtained for free by registering on their website as developer.
The free apiKey is restricted to 1000 calls per day. The widget refresh is set by default to 15 minutes (96 times per day).
The widget is usable in the Englisch and the German language.

## Examples for the Display Modes
By default the widget has 4 display modes plus alert mode:
### Display mode: day with weather alert
![Display mode: Text][image-5]
### Display mode: day
![Display mode: Text][image-1]
### Display mode: icon
![Display mode: Icon][image-2]
### Display mode: iconplus
![Display mode: IconPlus][image-3]
### Display mode: text
![Display mode: Text][image-4]
### Display mode: week
![Display mode: Text][image-6]

## Prerequisites

If you're not already using it anyway, install [Homebrew][4]. "The missing package manager for macOS."  

``` 
$ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
``` 

Then Install Übersicht:

``` 
$ brew cask install ubersicht
``` 

(Alternatively, you can download and install **Übersicht** from it's [website][6].)  
  
Clone this repository and move it into the Übersicht widgets folder:  

``` 
$ git clone https://github.com/DeltaOS2/darksky.widget.git
$ mv darksky.widget/ ~/Library/Application\ Support/Übersicht/widgets/
``` 

Start or restart Übersicht. The widget should appear in the Übersicht menu.

## Customization
Edit the **index.coffee** and review/modify the following items:

- The **iconSet** variable on line **10**. This is the main weather icon that is displayed. Take a look at the folders in the „images“ folder and decide which you like best. There are two iconSets delivered to choose between. The default is **color** but the widget also includes a mono colored set. -- If you want to build your own icon set from other icons make sure to name them with the same names as the delivered icons.
- The **numberOfDays** variable on line **13** controls how many days of forecast are shown. At the current time DarkSky returns a max of 8 days (including today). The widget will reset any value larger than 8 back to 8.
- With the **showAlerts** variable on line **19**, you can turn the display of alerts on and off.
- The **numberOfAlerts** variable on line **1** controls how many weather alerts will be displayed.
- The **display** mode variable on the lines **22** to **27** controls the display mode.
  - display = **day** displays just the banner with the todays conditions.
  - display = **text** displays the banner plus the **numberOfDays** you've set as text with a the weather condition icon in front.
  - display = **icon** displays the banner plus the forecast for 8 days as little icons.
  - display = **iconplus** displays all of the **icon**-mode plus 3 days as text.
  - display = **week** displays just 7 days as graph (with small icons)
- Edit the **latitude** and **longitude** of the location you wish to display the weather details for in lines **30** & **31**.
- Edit the **apiKey** on line **37** to set your DarkSky API key. Visit [darksky developer login][3] to register and generate a free API key.
- The **lang** variable on lines **40** and **41** controls the displayed language. The options are German and English.
- The **units** variable on lines **44** and **45** controls what units are displayed. You can chose **ca** to display Celsius degrees and kilometer or **us** to display Fahrenheit and miles.
- The widget location on your screen can be changed by changing **top** and **left** in the **style**-section (line **361** and **362**).

---

<a id="deutsch"></a>

# DarkSky Widget
Ein Übersicht widget zur Darstellung der Wetterkonditionen an einem bestimmten Ort. Es bietet verschiedene Optionen. Es kann ein einzelner Tag oder bis zu 8 Tagen dargestellt werden.
Um das widget benutzen zu können, braucht man einen apiKey von [darksky][2]. Man kann den Key kostenlos erhalten wenn man sich dort als Developer registriert.
Der Key erlaubt bis zu 1000 Aufrufe pro Tag. Die Aktualisierungsrate des widgets ist auf "alle 15 Minuten" gesetzt. Das entspricht 96 Aufrufen pro Tag.

## Vorbereitung

Fall nicht bereits geschehen, installiere [Homebrew][5]. "Den fehlende Paketmanager für macOS."  

``` 
$ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
``` 

Danach installiere Übersicht:

``` 
$ brew cask install ubersicht
``` 

(Alternativ kannst du **Übersicht** von seiner [WebSeite][6] herunterladen und installieren.)  
  
Klone dieses Repository und verschiebe es in das Übersicht widgets Verzeichnis:  

``` 
$ git clone https://github.com/DeltaOS2/darksky.widget.git
$ mv darksky.widget/ ~/Library/Application\ Support/Übersicht/widgets/
``` 

Starte Übersicht oder starte es neu. Das widget sollte jetzt im Übersicht-Menü erscheinen.


## Einstellungen

Editiere die Datei **index.coffee** und modifiziere folgende Einstellungen:

- Die **iconSet** Variable in Zeile **10**. Hier läßt sich das Wetter Icon auswählen, dass angezeigt wird. Schaue in das Verzeichnis „images“ und deren Unterverzeichnisse und wähle nach eigenem Geschmack. Die Vorgabe ist **color** aber das Widget hat auch einen einfarbigen Symbolsatz. -- Falls du dir deinen eigenen Symbolsatz zusammenstellen willst, so achte darauf, dass die Namen entsprechend angepasst werden.
- Die **numberOfDays** Variable in Zeile **13** bestimmt wieviele Tage angezeigt werden. Im Moment bietet DarkSky die Option zur Anzeige von bis zu 8 Tagen (inklusive Heute). Sollte eine größere Zahl als 8 eingegeben werden wird automatisch die maximale Anzahl angezeigt.
- Mit der **showAlerts** Variablen in Zeile **19** wird die Anzeige von Alarmen ein- bzw. ausgeschaltet.
- Die **numberOfAlerts** Variable in Zeile **15** bestimmt wieviele Wetter-Alarme angezeigt werden.
- Die **display** Modus Variable in den Zeilen **18** bis **21** bestimmt die Darstellung des widgets.
	- display = **day** zeigt nur das Banner und die heutigen Konditionen an.
	- display = **text** zeigt das Banner plus der Anzahl der in  **numberOfDays** gewählten Tage als Text mit dem vorangestellten Wetterzustands-Icon an.
	- display = **icon** zeigt das Banner plus der Vorhersage für 8 Tage als kleine Icons an.
	- display = **iconplus** zeigt den **icon**-Modus plus 3 Tage als Text an.
	- display = **week** zeigt nur die Woche als Graphen mit den kleinen Symbolen an.
- Trage den Längen- und Breitengrad des Orts in den Zeilen **30** & **31** ein für den die Wetterdaten angezeigt werden sollen.
- Trage den DarkSky **apiKey** in Zeile **37** ein. Falls du noch keinen hast, besuche [darksky developer login][3] und registriere dich um einen kostenlosen Key zu erhalten.
- Die **lang** Variable in den Zeilen **40** und **41** bestimmt die angezeigte Sprache. Zur Auswahl stehen deutsch und englisch.
- Die **units** Variable in den Zeilen **44** und **45** bestimmt welche Einheiten angezeigt werden. Es kann zwischen **ca** zur Anzeige von Grad-Celsius und Kilometer oder **us** zur Anzeige von Fahrenheit and Meilen gewählt werden.
- Die Position des widgets auf dem Bildschirm kann durch ändern von **top** und **left** in der **style**-Sektion (Zeile **361** und **362**) eingestellt werden.



[1]:#deutsch
[2]:https://darksky.net
[3]:https://darksky.net/dev
[4]:https://brew.sh
[5]:https://brew.sh/index_de
[6]:http://tracesof.net/uebersicht/

[image-1]:screenshots/display-day.png?raw=true
[image-2]:screenshots/display-icon.png?raw=true
[image-3]:screenshots/display-iconplus.png?raw=true
[image-4]:screenshots/display-text.png?raw=true
[image-5]:screenshots/alert.png?raw=true
[image-6]:screenshots/display-week.png?raw=true
