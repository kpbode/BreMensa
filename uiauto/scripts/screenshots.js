var forcelanguage  ='de';

// Setup some variables for readability
var target = UIATarget.localTarget();
var app = target.frontMostApp();
var win = app.mainWindow();

// Overwrite the language in NSUserDefaults
// Note that this will only take effect on next run.
// So you have to run this twice.
// Once to set the language, another to actually pick the screenshot.
app.setPreferencesValueForKey([forcelanguage], 'AppleLanguages');

// You can define your own settings of course, for example:
//app.setPreferencesValueForKey("0.85", 'fakePercentageForShots');

// Store current language name for use in filenames
lang = target.frontMostApp().preferencesValueForKey("AppleLanguages")[0];

// Pause for two seconds (screen capture takes a second !)
target.delay(2);

win.buttons()["Info"].tap();

// Pause for two seconds (new screen needs some time to load and appear)
target.delay(2);

// Save screenshot for settings screen
target.captureScreenWithName( lang + "_info");

app.navigationBar().rightButton().tap();

// Pause for two seconds (screen capture takes a second !)
target.delay(2);

target.captureScreenWithName( lang + "_settings");

app.navigationBar().leftButton().tap();
app.navigationBar().leftButton().tap();

target.delay(2);

target.frontMostApp().mainWindow().tableViews()["Mensa Menu"].cells()["Airport"].tap();

target.delay(2);

target.captureScreenWithName( lang + "_mealplan");

target.delay(2);

target.frontMostApp().navigationBar().leftButton().tap();

target.frontMostApp().mainWindow().tableViews()["Mensa Menu"].cells()["Airport"].buttons()["More info, Airport"].tap();

// wait a little until tiles have been loaded
target.delay(4);

target.captureScreenWithName( lang + "_mensaInfo");

target.frontMostApp().navigationBar().leftButton().tap();

target.delay(2);

target.captureScreenWithName( lang + "_home");