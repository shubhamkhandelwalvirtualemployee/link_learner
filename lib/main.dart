import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:link_learner/core/constants/app_images.dart';
import 'package:link_learner/core/constants/color_constants.dart';
import 'package:link_learner/core/constants/route_names.dart';
import 'package:link_learner/presentation/booking/provider/booking_provider.dart';
import 'package:link_learner/presentation/booking_and_search/provider/booking_search_provider.dart';
import 'package:link_learner/presentation/bottom_nav_bar/provider/bottom_nav_bar_provider.dart';
import 'package:link_learner/presentation/login_signup/provider/login_signup_provider.dart';
import 'package:link_learner/presentation/onboarding/provider/onboarding_provider.dart';
import 'package:link_learner/presentation/profile/provider/profile_provider.dart';
import 'package:link_learner/routes/app_routes.dart';
import 'package:link_learner/routes/route_manager.dart';
import 'package:link_learner/widgets/asset_images.dart';
import 'package:link_learner/widgets/common_elevated_button.dart';
import 'package:provider/provider.dart';

String? fcmToken;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  // await dotenv.load(fileName: ".env");

  // await Firebase.initializeApp();
  // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  //   alert: true,
  //   sound: true,
  //   badge: true,
  // );

  // FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

@pragma('vm:entry-point')
Future<void> backgroundHandler(RemoteMessage message) async {
  // await Firebase.initializeApp();
  // if (Platform.isIOS) {
  //   if (message.data.containsKey('badgeCount')) {
  //     final badgeCount = int.tryParse(message.data['badgeCount']) ?? 0;
  //     BadgeManager.updateBadgeCount(badgeCount);
  //   }
  // }
}

class _MyAppState extends State<MyApp> {
  late final StreamSubscription<InternetStatus> _internetSubscription;
  bool _isNoInternetDialogVisible = false;
  // late FirebaseMessaging _messaging;
  late final FlutterLocalNotificationsPlugin _localNotifications;
  final _appLinks = AppLinks();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _handleIncomingLinks();
    _setupInternetListener();
  }

  void _handleIncomingLinks() async {
    // For app already opened
    _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) _handleUri(uri);
    });

    // For cold start
    final initialLink = await _appLinks.getInitialLink();
    if (initialLink != null) {
      _handleUri(initialLink);
    }
  }

  void _handleUri(Uri uri) async {}

  void _handleForegroundNotification(RemoteMessage message) {
    print('Foreground Notification: ${message.notification?.title}');
    if (message.notification != null) {
      if (Platform.isIOS) {
      } else {
        _showLocalNotification(
          title: message.notification?.title,
          body: message.notification?.body,
          payload: message.data['payload'] ?? '',
        ).then((_) {});
      }
    }
  }

  Future<void> _initializeNotifications() async {
    // _messaging = FirebaseMessaging.instance;

    // Request permissions
    // NotificationSettings settings = await _messaging.requestPermission(
    //   alert: true,
    //   badge: true,
    //   sound: true,
    // );

    // if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    //   fcmToken = await _messaging.getToken();
    //   print("✅ FCM Token: $fcmToken");

    //   if (fcmToken != null) {}

    //   // Foreground push handler

    //   // Firebase foreground notifications
    //   FirebaseMessaging.onMessage.listen(_handleForegroundNotification);

    //   // Firebase background/tapped notifications
    //   FirebaseMessaging.onMessageOpenedApp.listen(
    //     _handleBackgroundNotification,
    //   );

    //   // Firebase terminated state notification
    //   // RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    //   // if (initialMessage != null) {
    //   //   _handleTerminatedNotification(initialMessage);
    //   // }
    // } else {
    //   print('⚠️ User declined or has not accepted notification permissions.');
    // }

    // Local notification setup
    _localNotifications = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@drawable/ic_notification');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          defaultPresentAlert: true,
          defaultPresentBadge: true,
          defaultPresentSound: true,
          requestProvisionalPermission: true,
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) async {
        _handleNotificationTap(response.payload ?? "");
      },
    );
  }

  // BACKGROUND NOTIFICATION
  void _handleBackgroundNotification(RemoteMessage message) {
    if (Platform.isIOS) {
      // if (message.data.containsKey('badgeCount')) {
      //   final badgeCount = int.tryParse(message.data['badgeCount']) ?? 0;
      //   BadgeManager.updateBadgeCount(badgeCount);
      // }
    }
  }

  // TERMINATE STATE NOTIFICATION
  void _handleTerminatedNotification(RemoteMessage message) {
    if (Platform.isIOS) {
      // if (message.data.containsKey('badgeCount')) {
      //   final badgeCount = int.tryParse(message.data['badgeCount']) ?? 0;
      //   BadgeManager.updateBadgeCount(badgeCount);
      // }
    }
  }

  void _handleNotificationTap(String payload) {
    print('Notification Tapped with payload: $payload');
  }

  Future<void> _showLocalNotification({
    required String? title,
    required String? body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          playSound: true,
          'default_channel',
          'Default Channel',
          channelDescription: 'This is the default notification channel.',
          importance: Importance.high,
          priority: Priority.high,
          showWhen: true,
        );

    NotificationDetails notificationDetails = const NotificationDetails(
      android: androidNotificationDetails,
    );

    await _localNotifications.show(
      0,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  void _setupInternetListener() {
    InternetConnection().hasInternetAccess.then((hasInternet) {
      if (!hasInternet) {
        _showNoInternetDialog();
      }
    });

    _internetSubscription = InternetConnection().onStatusChange.listen((
      InternetStatus status,
    ) {
      final bool isOnline = status == InternetStatus.connected;
      if (!isOnline) {
        _showNoInternetDialog();
      } else {
        _dismissNoInternetDialogIfAny();
      }
    });
  }

  void _showNoInternetDialog() {
    if (_isNoInternetDialogVisible) return;
    final context = navigatorKey.currentContext;
    if (context == null) return;
    _isNoInternetDialogVisible = true;
    AppRoutes.push(context, RouteNames.noNetworkScreen);
  }

  void _dismissNoInternetDialogIfAny() {
    if (!_isNoInternetDialogVisible) return;
    final context = navigatorKey.currentContext;
    if (context == null) return;
    Navigator.of(context, rootNavigator: true).pop();
    _isNoInternetDialogVisible = false;
  }

  @override
  void dispose() {
    _internetSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<OnboardingProvider>(
          create: (context) => OnboardingProvider(),
        ),
        ChangeNotifierProvider<LoginSignupProvider>(
          create: (context) => LoginSignupProvider(),
        ),
        ChangeNotifierProvider<ProfileProvider>(
          create: (context) => ProfileProvider(),
        ),
        ChangeNotifierProvider<BookingSearchProvider>(
          create: (context) => BookingSearchProvider(),
        ),
        ChangeNotifierProvider<BottomNavProvider>(
          create: (context) => BottomNavProvider(),
        ),
        ChangeNotifierProvider<BookingProvider>(
          create: (context) => BookingProvider(),
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [],
        title: 'Link Learner',
        theme: ThemeData(fontFamily: "Geist", useMaterial3: true),
        initialRoute: RouteNames.onboardingScreen,
        onGenerateRoute: RouteManager.onGenerateRoute,
      ),
    );
  }
}

class NoNetworkScreen extends StatefulWidget {
  const NoNetworkScreen({super.key});

  @override
  State<NoNetworkScreen> createState() => _NoNetworkScreenState();
}

class _NoNetworkScreenState extends State<NoNetworkScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.whiteColor,
      body: Stack(
        children: [
          // Main content
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  assetImages(AppImages.notNetwork, height: 150, width: 150),
                  const SizedBox(height: 10),
                  const Text(
                    'No Network!',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Please check your internet \nconnection and try again',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: ColorConstants.disabledColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 50,
                    child: Row(
                      children: [
                        Expanded(
                          child: elevatedButton(
                            onTap: () {},
                            title: "Try again",
                            backgroundColor: ColorConstants.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: 60,
            left: 10,
            child: IconButton(
              icon: const Icon(
                Icons.close,
                color: ColorConstants.primaryTextColor,
                size: 24,
              ),
              onPressed: () => AppRoutes.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
