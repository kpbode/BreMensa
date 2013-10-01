function takeScreenshot() {
	var target = UIATarget.localTarget();
	var app = target.frontMostApp();
	var win = app.mainWindow();
	win.tapWithOptions({ x: 10, y: 10, touchCount: 5 });	
}

// Setup some variables for readability
var target = UIATarget.localTarget();
var app = target.frontMostApp();
var win = app.mainWindow();

// Overwrite the language in NSUserDefaults
// Note that this will only take effect on next run.
// So you have to run this twice.
// Once to set the language, another to actually pick the screenshot.
//app.setPreferencesValueForKey([forcelanguage], 'AppleLanguages');
//app.setPreferencesValueForKey('de_DE', 'AppleLocale');

var strings = {};
strings['de'] = {};
strings['de']['mensaMenu'] = 'Mensaauswahl';
strings['de']['moreInfoAirport'] = 'Weitere Infos, Airport';

strings['en'] = {};
strings['en']['mensaMenu'] = 'Mensamenu';
strings['en']['moreInfoAirport'] = 'More info, Airport';

UIALogger.logMessage('languages: ' + target.frontMostApp().preferencesValueForKey("AppleLanguages"));

var language = target.frontMostApp().preferencesValueForKey("AppleLanguages")[0];
UIALogger.logMessage('language: ' + language);

// Pause for two seconds (screen capture takes a second !)
target.delay(2);

win.buttons()["Info"].tap();

// Pause for two seconds (new screen needs some time to load and appear)
target.delay(2);

// Save screenshot for settings screen
//target.captureScreenWithName( lang + "_info");
takeScreenshot();

app.navigationBar().rightButton().tap();

// Pause for two seconds (screen capture takes a second !)
target.delay(2);

takeScreenshot();

app.navigationBar().leftButton().tap();
app.navigationBar().leftButton().tap();

target.delay(2);

target.frontMostApp().mainWindow().tableViews()[strings[language]['mensaMenu']].cells()["Airport"].tap();

target.delay(5);

takeScreenshot();

target.delay(2);

target.frontMostApp().navigationBar().leftButton().tap();

target.frontMostApp().mainWindow().tableViews()[strings[language]['mensaMenu']].cells()["Airport"].buttons()[0].tap();

// wait a little until tiles have been loaded
target.delay(4);

takeScreenshot();

target.frontMostApp().navigationBar().leftButton().tap();

target.delay(2);

takeScreenshot();
