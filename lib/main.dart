import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_theme.dart';
import 'core/services/local_storage_service.dart';
import 'core/services/tts_service.dart';
import 'core/services/notification_service.dart';
import 'providers/app_provider.dart';
import 'features/splash/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations for kids
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  ));

  // Initialize services
  try {
    await LocalStorageService().init();
    await TtsService().init();
    await NotificationService().init();
  } catch (e) {
    // Services init error - app will still work
  }

  runApp(const KidEnglishApp());
}

class KidEnglishApp extends StatelessWidget {
  const KidEnglishApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final provider = AppProvider();
        provider.init();
        return provider;
      },
      child: MaterialApp(
        title: 'KidEnglish',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
