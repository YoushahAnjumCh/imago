import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imago/core/service_locator/service_locator.dart';
import 'package:imago/core/theme/app_theme.dart';
import 'package:imago/env/env.dart';
import 'package:imago/features/home_page/presentation/cubit/home_page_cubit.dart';
import 'package:imago/features/home_page/presentation/pages/homepage.dart';
import 'package:imago/firebase_options.dart';

Future<void> main() async {
  AppEnvironment.setupEnv(Environment.prod);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeScreenCubit(sl()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Imago',
        theme: AppTheme.darkThemeMode,
        home: HomePage(),
      ),
    );
  }
}
