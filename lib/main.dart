import 'package:black_market/src/core/utils/consts/AppColors.dart';
import 'package:black_market/src/core/utils/consts/AppRouter.dart';
import 'package:black_market/src/features/auth/cubit/AuthCubit.dart';
import 'package:black_market/src/features/favorites/cubit/FavoritesCubit.dart';
import 'package:black_market/src/features/home/cubit/HomeCubit.dart';
import 'package:black_market/src/features/home/widget/BottomNavigationBarWidget.dart';
import 'package:black_market/src/features/profile/cubit/ProfileCubit.dart';
import 'package:black_market/src/features/settings/cubit/SettingsCubit.dart';
import 'package:black_market/src/features/splash/screens/SplashScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => FavoriteCubit(),),
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => ProfileCubit()),
        BlocProvider(create: (context) => HomeCubit()..loadMore()),
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
            title: 'Black Market (remastered)',
            debugShowCheckedModeBanner: false,
            onGenerateRoute: AppRouter.onGenerateRoute,
            theme: ThemeData(
              scaffoldBackgroundColor: AppColors.instance.black,
              colorScheme: ColorScheme.light(),
            ),
            home: snap.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : snap.hasData
                ? BottomNavigationBarWidget()
                : SplashScreen(),
          ),
        );
      },
    );
  }
}
