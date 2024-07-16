import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:imago/common/firebase/analytics/firebase_analytics.dart';
import 'package:imago/core/service_locator/service_locator.dart';
import 'package:imago/core/theme/app_theme.dart';
import 'package:imago/env/env.dart';
import 'package:imago/features/home_page/presentation/cubit/home_page_cubit.dart';
import 'package:imago/features/home_page/presentation/pages/homepage.dart';
import 'package:imago/firebase_options.dart';

Future<void> main() async {
  AppEnvironment.setupEnv(Environment.prod);
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  FirebaseAnalyticsService().logAndOpen();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeScreenCubit(sl()),
      child: MaterialApp(
        navigatorObservers: <NavigatorObserver>[
          FirebaseAnalyticsService().getAnalyticObserver(),
        ],
        title: 'Flutter Demo',
        theme: AppTheme.darkThemeMode,
        home: HomePage(),
      ),
    );
  }
}
