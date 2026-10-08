import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/datasources/local_data.dart';
import 'data/datasources/remote_data.dart';
import 'domain/repositories/flight_repo_impl.dart';
import 'presentation/cubit/flight_cubit.dart';
import 'presentation/screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final repo = FlightRepoImpl(RemoteData(), LocalData());
  runApp(BlocProvider(
    create: (_) => FlightCubit(repo),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorSchemeSeed: const Color(0xFF1565A8),
      fontFamily: 'Poppins'
    ),
    home: const SplashScreen(),
  );
}