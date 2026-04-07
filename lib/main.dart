import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'core/controllers/auth_controller.dart';
import 'core/controllers/cart_controller.dart';
import 'core/extensions/routes.dart';
import 'core/extensions/sizer.dart';
import 'core/resources/app_colors.dart';
import 'ui/view/splash_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final prefs = await SharedPreferences.getInstance();
  final isSwapped = prefs.getBool('isSwapped') ?? false;

  runApp(Phoenix(child: MyApp(isSwapped: isSwapped)));
}

class MyApp extends StatelessWidget {
  final bool isSwapped;
  const MyApp({super.key, required this.isSwapped});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context, debug: true);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController(), lazy: true),
        ChangeNotifierProvider(create: (_) => ThemeManager(isSwapped)),
        ChangeNotifierProvider(create: (_) => CartController()),
      ],
      child: Consumer<ThemeManager>(
        builder: (context, themeManager, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            navigatorKey: AppRoutes.navigatorKey,
            title: 'PAANI',
            theme: AppTheme.lightTheme.copyWith(
              textTheme: GoogleFonts.interTextTheme(
                AppTheme.lightTheme.textTheme,
              ),
            ),
            builder: (context, child) => GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              behavior: HitTestBehavior.translucent,
              child: child,
            ),
            home: const SplashView(),
          );
        },
      ),
    );
  }
}
