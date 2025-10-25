import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  ThemeMode _themeMode = ThemeMode.light;
  bool _loggedIn = false;
  String _locale = 'es';

  String? _userEmail;
  String? _userName;
  String? _userUsername;

  void _toggleTheme() => setState(() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  });

  void _toggleLocale() => setState(() {
    _locale = _locale == 'es' ? 'en' : 'es';
  });

  void _onLogin() => setState(() => _loggedIn = true);

  void _onRegister({required String email, required String name, required String username}) {
    setState(() {
      _userEmail = email;
      _userName = name;
      _userUsername = username;
      _loggedIn = true;
    });
  }

  void _onLogout() => setState(() => _loggedIn = false);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: _loggedIn
          ? HomeScreen(
              onChangeTheme: _toggleTheme,
              onLogout: _onLogout, // <-- pasar callback de logout
            )
          : LoginScreen(
              onLogin: _onLogin, // <-- pasar callback para iniciar sesión
              onChangeTheme: _toggleTheme,
              onRegister: _onRegister,
              locale: _locale,
            ),
    );
  }
}
