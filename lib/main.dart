import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cars/bloc/app_bottom_form/app_bottom_form.dart';
import 'package:cars/bloc/car_order_bloc/car_order_bloc.dart';
import 'package:cars/bloc/position_bloc/position_bloc.dart';
import 'package:cars/bloc/user/user_cubit.dart';
import 'package:cars/bloc/live_search_bloc/live_search_bloc.dart';
import 'package:cars/pages/chats_page.dart';
import 'package:cars/pages/loading_page.dart';
import 'package:cars/repository/repo.dart';
import 'package:cars/res/styles.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'bloc/route_from_to/route_from_to.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: await getApplicationDocumentsDirectory());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  OneSignal.initialize('f0640bb0-a332-455c-a8a2-83fe4c7cc76a');
  OneSignal.Notifications.requestPermission(true);
  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic notifications',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white,
      ),
    ],
  );

  await AwesomeNotifications().requestPermissionToSendNotifications(
    permissions: [
      NotificationPermission.Alert,
      NotificationPermission.Sound,
      NotificationPermission.Badge,
      NotificationPermission.Vibration,
      NotificationPermission.Light,
      NotificationPermission.FullScreenIntent,
    ],
  );

  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        playSound: true,
        onlyAlertOnce: true,
        channelGroupKey: 'basic_channel_group',
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: Color(0xFF9D50DD),
        importance: NotificationImportance.High,
        groupAlertBehavior: GroupAlertBehavior.Children,
        defaultPrivacy: NotificationPrivacy.Private,
        channelShowBadge: true,
        criticalAlerts: true,
        vibrationPattern: highVibrationPattern,
      ),
    ],
    channelGroups: [
      NotificationChannelGroup(
        channelGroupName: 'Basic group',
        channelGroupKey: 'basic_channel_group',
      ),
    ],
    debug: true,
  );

  await AwesomeNotifications().requestPermissionToSendNotifications(
    permissions: [
      NotificationPermission.FullScreenIntent,
    ],
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    var repo = Repository();
    var userCubit = UserCubit();
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserCubit>(
          create: (BuildContext context) => userCubit,
        ),
        BlocProvider<LiveSearchBloc>(
          create: (BuildContext context) => LiveSearchBloc(repo: repo),
        ),
        BlocProvider<RouteFromToCubit>(
          create: (BuildContext context) => RouteFromToCubit(),
        ),
        BlocProvider<AppBottomFormCubit>(
          create: (BuildContext context) => AppBottomFormCubit(),
        ),
        BlocProvider<CarOrderBloc>(
          create: (BuildContext context) =>
              CarOrderBloc(repo: repo, user: userCubit),
        ),
        BlocProvider<PositionBloc>(
          create: (BuildContext context) => PositionBloc(repo: repo),
        ),
      ],
      child: GetMaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en', ''),
          Locale('ru', ''),
        ],
        home: MaterialApp(
          title: 'Cars App',
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            DefaultWidgetsLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('en', ''),
            Locale('ru', ''),
          ],
          theme: ThemeData(
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            }),
            colorScheme: ColorScheme.fromSeed(
              seedColor: blue,
            ),
            useMaterial3: true,
          ),

          home: LoadingPage(),
        ),
      ),
    );
  }
}
