import 'dart:async';
import 'dart:io';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_analytics/observer.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:outfitters/UI/Notifiers/CartNotifier.dart';
import 'package:outfitters/UI/Notifiers/ConnectionNotifier.dart';
import 'package:outfitters/UI/Notifiers/HomeScreenNotifier.dart';
import 'package:outfitters/UI/Notifiers/NewFilters.dart';
import 'package:outfitters/UI/Notifiers/WishNotifer.dart';
import 'package:outfitters/UI/Screens/BottamNavigation.dart';
import 'package:outfitters/UI/Screens/Splash.dart';
import 'package:outfitters/UI/Screens/firebaseInappmessaging.dart';
import 'package:outfitters/Utils/Constant.dart';
import 'package:outfitters/Utils/GraphQlHelper.dart';
import 'package:outfitters/Utils/Helper.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'package:firebase_core/firebase_core.dart';

// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     'high_importance_channel', // id
//     'High Importance Notifications', // title
//     'High Importance Notifications',
//     // importance: i.high,
//     playSound: true);
//
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print('A bg message just showed up : ${message.messageId}');
// }

// FlutterLocalNotificationsPlugin fltNotification =
//     FlutterLocalNotificationsPlugin();

String token;
// Future<void> main() async {
//   Crashlytics.instance.enableInDevMode = false;
//   FlutterError.onError = Crashlytics.instance.recordFlutterError;
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runZoned(() {
//     runApp(MyApp());
//   }, onError: Crashlytics.instance.recordError);
//   runApp(MyApp());
//}
const _kShouldTestAsyncErrorOnInit = false;

// Toggle this for testing Crashlytics in your app locally.
const _kTestingCrashlytics = true;

Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp();
    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    // await FirebaseMessaging.instance
    //     .setForegroundNotificationPresentationOptions(
    //   alert: true,
    //   badge: true,
    //   sound: true,
    // );
    // token = await FirebaseMessaging.instance.getToken();
    // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    ByteData data =
        await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
    SecurityContext.defaultContext
        .setTrustedCertificatesBytes(data.buffer.asUint8List());

    runApp(MyApp());
  }, (error, stackTrace) {
    // FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}

String Token;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  // // static FirebaseAnalytics analytics = new FirebaseAnalytics();
  // static FirebaseInAppMessaging fiam = FirebaseInAppMessaging.instance;

  // static FirebaseAnalyticsObserver observer =
  //     new FirebaseAnalyticsObserver(analytics: analytics);

  static Color lightPrimary = Colors.white;
  static Color darkPrimary = Colors.black;
  static Color lightBG = Colors.white;
  static Color darkBG = Colors.black;

  // FlutterLocalNotificationsPlugin localNotificationsPlugin =
  //     new FlutterLocalNotificationsPlugin();
  var now = DateTime.now();
  callmessage() async {
    await FirebaseMessagingData.fiam.triggerEvent('first_open');
  }

  @override
  void initState() {
    Token = token;

    print("<< getting token>>>>====================={$token}!!!!!");
    super.initState();
    callmessage();
  }

  @override
  void dispose() {
    // painterBloc1.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    final graphqlconnection = GraphQlHelper();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartNotifier()),
        ChangeNotifierProvider(create: (_) => WishNotifier()),
        ChangeNotifierProvider(create: (_) => FilterNotifier()),
        ChangeNotifierProvider(create: (_) => HomeScreenNotifier()),
        StreamProvider<ConnectivityStatus>(
          initialData: null,
          create: (context) =>
              ConnectionNotifier().connectionStatusController.stream,
        )
      ],
      child: GraphQLProvider(
        client: graphqlconnection.client,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: Constant.appName,
          theme: ThemeData(
            fontFamily: "BentonSans",
            backgroundColor: lightBG,
            // textSelectionHandleColor: Colors.black,
            // textSelectionColor: Colors.black,
            primaryColor: lightPrimary,
            accentColor: darkPrimary,
            primaryColorLight: darkPrimary,
            scaffoldBackgroundColor: lightBG,
            // cursorColor: darkPrimary,
            appBarTheme: AppBarTheme(
              elevation: 0,
              textTheme: TextTheme(
                headline1: TextStyle(
                  fontFamily: "BentonSans",
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          // theme: Constant.lightTheme,
          // navigatorObservers: <NavigatorObserver>[observer],
          // navigatorObservers: <NavigatorObserver>[observer],

          home: FutureBuilder<bool>(
              future: Helper.getPreferenceBoolean('remember'),
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data) {
                    return BottamNavigation();
                  } else {
                    return SplashScreen();
                  }
                } else {
                  return SizedBox();
                }
              }),
        ),
      ),
    );
  }
}
