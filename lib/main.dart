import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica1/auth/bloc/auth_bloc.dart';
import 'package:practica1/favorites/bloc/favorite_bloc.dart';
import 'package:practica1/favorites/bloc/music_bloc.dart';
import 'package:practica1/favorites/home_page.dart';
import 'package:practica1/login/login_page.dart';

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiBlocProvider(providers: [
    BlocProvider(create: (context) => MusicBloc()),
    BlocProvider(create: (context) => FavoriteBloc()),
    BlocProvider(
      create: (context) => AuthBloc()..add(VerifyAuthEvent()),
    ),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.grey,
          primarySwatch: Colors.grey,
          colorScheme: ColorScheme(
              brightness: Brightness.dark,
              primary: Colors.black,
              onPrimary: Colors.black,
              secondary: Colors.white,
              error: Colors.red,
              onError: Colors.orange,
              onSecondary: Colors.white,
              background: Colors.grey,
              onBackground: Colors.grey,
              surface: Color.fromARGB(234, 27, 26, 26),
              onSurface: Colors.white)),
      home: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Favor de autenticarse"),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthSuccessState) {
            return HomePage();
          } else if (state is UnAuthState ||
              state is AuthErrorState ||
              state is SignOutSuccessState) {
            return LoginPage();
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
