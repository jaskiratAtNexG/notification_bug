# notification_bug
this is the minimal reproducible code for the issue that we are experiencing in the flutter_notifications_plugin

## steps to reproduce the issue are:
1. add your own google-services.json file from firebase
2. create new campaign for notifications on firebase
3. copy firebase token from console after running the application
4. run the application on release mode using flutter run --release
5. now kill the app
6. and now send the test message from firebase
7. now after clicking on the notification just arrived
8. you will encounter the PlatformException.
