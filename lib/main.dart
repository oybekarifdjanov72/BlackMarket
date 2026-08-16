import 'package:black_market/src/core/utils/di/injection.dart';
import 'package:black_market/src/core/consts/AppColors.dart';
import 'package:black_market/src/core/consts/AppRouter.dart';
import 'package:black_market/src/core/utils/responsive/AppResponsive.dart';
import 'package:black_market/src/features/basket/cubit/BasketCubit.dart';
import 'package:black_market/src/features/auth/cubit/AuthCubit.dart';
import 'package:black_market/src/features/favorites/cubit/FavoritesCubit.dart';
import 'package:black_market/src/features/home/presentation/cubit/HomeCubit.dart';
import 'package:black_market/src/features/home/presentation/widget/BottomNavigationBarWidget.dart';
import 'package:black_market/src/features/profile/cubit/ProfileCubit.dart';
import 'package:black_market/src/features/settings/cubit/SettingsCubit.dart';
import 'package:black_market/src/features/splash/screens/SplashScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => FavoriteCubit()),
        BlocProvider(create: (_) => BasketCubit()),
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => ProfileCubit()),
        BlocProvider(create: (context) => sl<HomeCubit>()),
        BlocProvider(create: (context) => SettingsCubit()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snap) {
        return ToastificationWrapper(
          child: MaterialApp(
            title: 'Black Market (Remastered)',
            debugShowCheckedModeBanner: false,
            onGenerateRoute: AppRouter.onGenerateRoute,
            builder: (context, child) {
              final media = MediaQuery.of(context);
              return MediaQuery(
                data: media.copyWith(
                  // Prevent system font scaling from causing massive overflows on small devices.
                  textScaler: media.textScaler.clamp(
                    minScaleFactor: 0.8,
                    maxScaleFactor: 1.1,
                  ),
                ),
                child: ResponsiveBreakpoints.builder(
                  child: child ?? const SizedBox.shrink(),
                  // Target: Small Phone (320-360), Standard Phone (360-600), Tablet (600+).
                  breakpoints: const [
                    Breakpoint(start: 0, end: 350, name: AppBreakpoints.smallMobile),
                    Breakpoint(start: 351, end: 600, name: MOBILE),
                    Breakpoint(start: 601, end: 1200, name: TABLET),
                    Breakpoint(start: 1201, end: double.infinity, name: 'DESKTOP'),
                  ],
                ),
              );
            },
            theme: ThemeData(
              useMaterial3: true,
              scaffoldBackgroundColor: AppColors.instance.white,
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.instance.cyanAccent,
                brightness: Brightness.light,
              ),
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              scaffoldBackgroundColor: AppColors.instance.black,
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.instance.cyanAccent,
                brightness: Brightness.dark,
              ),
            ),
            themeMode: ThemeMode.system,
            home: snap.connectionState == ConnectionState.waiting
                ? const Center(child: CircularProgressIndicator())
                : snap.hasData
                    ? const BottomNavigationBarWidget()
                    : const SplashScreen(),
          ),
        );
      },
    );
  }
}
