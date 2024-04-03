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
  OneSignal.initialize('44659ce6-937c-4e6f-a97c-9893a3ed5f02');
  runApp(const MyApp());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  OneSignal.Notifications.requestPermission(true);

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
