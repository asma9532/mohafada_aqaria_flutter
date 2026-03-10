import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';  // ← أضف هذا السطر
import 'package:provider/provider.dart';
import 'config/theme.dart';
import 'config/routes.dart';
import 'providers/auth_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'المحافظة العقارية',
        debugShowCheckedModeBanner: false,
        
        // الدعم العربي
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ar', 'AE'),
        ],
        locale: const Locale('ar', 'AE'),
        
        // الثيم
        theme: AppTheme.appTheme,
        
        // التنقل
        initialRoute: AppRoutes.home,
        routes: AppRoutes.getRoutes(),
      ),
    );
  }
}