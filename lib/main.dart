import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubits/auth/auth_cubit.dart';
import 'cubits/home/home_cubit.dart';
import 'screens/splash_screen.dart';
import 'cubits/profile/profile_cubit.dart';
import 'cubits/edit-profile/edit_profile_cubit.dart';
import 'cubits/watchlist/watchlist_cubit.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeCubit>(create: (context) => HomeCubit()),
        BlocProvider<ProfileCubit>(create: (context) => ProfileCubit()),
        BlocProvider<EditProfileCubit>(create: (context) => EditProfileCubit()),
        BlocProvider<WatchlistCubit>(create: (context) => WatchlistCubit()),
        BlocProvider<AuthCubit>(create: (context) => AuthCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: const SplashScreen(),
      ),
    );
  }
}
