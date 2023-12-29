import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:notification_testing/notification_model.dart';
import 'package:notification_testing/notification_service.dart';
import 'package:notification_testing/print_payload_received.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    await NotificationService.init();

    runApp(const MyApp());
  }, (error, stack) => print(error));
}

@pragma('vm:entry-point')
Future<void> _messageHandler(RemoteMessage event) async {
  print("FirebaseMessaging recieved ${event.data}");
  print("FirebaseMessaging recieved ${event.notification?.body}");
  // NotificationService.navigateToScreen(payload: "");
  // if (event.data.containsKey('wzrk_pn')) {
  //   //* clevertap push notification
  //   var data = jsonEncode(event.data);
  //   await CleverTapPlugin.createNotification(data);
  // }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Flutter Notification bug',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Notification bug'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    getToken();
    firebaseMessage();
    super.initState();
  }

  getToken() async {
    try {
      String? token =
          await FirebaseMessaging.instance.getToken(); //use refresh function
      // String? previousToken = PreferenceUtils.getString('firebaseToken');
      // Logger().e("token $token");

      // if (token != null && token != previousToken) {
      //   await PreferenceUtils.setString('firebaseToken', token);
      //   // ignore: unused_local_variable
      //   Map<String, dynamic>? result = await User()
      //       .saveUserDetails(data: {'firebaseToken': token}, context: context);
      // }
      print(token);
    } catch (_) {}
  }

  firebaseMessage() async {
    FirebaseMessaging.onBackgroundMessage(_messageHandler);
    FirebaseMessaging.onMessage.listen(createFCMNotification);
    FirebaseMessaging.onMessageOpenedApp.listen(onOpenFCMNotification);
  }

  createFCMNotification(RemoteMessage event) async {
    print("message handler called for foreground state");
    String screenType = event.data['screen'] ?? "";
    int notificationId = int.parse(event.data['id'] ?? "211232");
    String title = event.notification?.title ?? "";
    String body = event.notification?.body ?? "";

    print(
        "createFCMNotification screenType $screenType, Data: ${event.data}, Body: ${event.notification?.body}");
    TextNotification genericObj = TextNotification(
        title: title,
        screenType: "none",
        notificationId: notificationId,
        sentAt: DateTime.parse(
            event.data["sent_at"] ?? DateTime.now().toUtc().toString()));
    NotificationService.showNotification(
        title: title,
        body: body,
        payload: json.encode(genericObj.toJson()),
        id: notificationId);
  }

  onOpenFCMNotification(RemoteMessage event) async {
    String screenType = event.data['screen'] ?? "";
    int notificationId = int.tryParse(event.data['id']) ?? 211232;
    String title = event.notification?.title ?? "";
    String body = event.notification?.body ?? "";
    String payloadString = json.encode(event.data);

    print(
        "onOpenFCMNotification screenType $screenType, Data: ${event.data}, Body: ${event.notification?.body}");

    try {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return PrintPayloadReceived(payload: payloadString);
    }));
    } catch(e) {
      print('"dcdscdscsdc');
      print(e);
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            // Text(
            //   '$_counter',
            //   style: Theme.of(context).textTheme.headlineMedium,
            // ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
