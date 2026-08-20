import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_hub_app/screens/main_layout_screen.dart';
import '../cubits/profile/profile_cubit.dart';
import '../cubits/watchlist/watchlist_cubit.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      if (FirebaseAuth.instance.currentUser != null) {
        context.read<ProfileCubit>().fetchProfileData();
        context.read<WatchlistCubit>().fetchWatchlist();
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => FirebaseAuth.instance.currentUser == null
              ? const LoginScreen()
              : const MainLayoutScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF52B3B),
      body: Center(child: Image.asset('assets/Frame 40.png', width: 150)),
    );
  }
}
