import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../localization.dart';
import '../services/auth_service.dart';    
import '../services/token_storage.dart';   

class LoginScreen extends StatefulWidget {
  final VoidCallback onLogin;
  final VoidCallback onChangeTheme;
  final void Function({
    required String email,
    required String name,
    required String username,
  })? onRegister;
  final String locale;
  const LoginScreen({
    super.key,
    required this.onLogin,
    required this.onChangeTheme,
    required this.onRegister,
    required this.locale,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _registerEmailController = TextEditingController();
  final TextEditingController _registerNameController = TextEditingController();
  final TextEditingController _registerPasswordController = TextEditingController();
  final TextEditingController _registerUserController = TextEditingController();
  bool _isRegister = false;
  String? _errorMessage;

  void _tryLogin() async {
  setState(() {
    _errorMessage = null;
  });
  
  final username = _emailController.text.trim();
  final password = _passwordController.text.trim();
  
  // Validar campos vacíos
  if (username.isEmpty || password.isEmpty) {
    setState(() {
      _errorMessage = t('fill_fields', widget.locale);
    });
    return;
  }
  
  try {
    // Usar AuthService real
    final result = await AuthService.login(username, password);
    
    if (result['ok'] == true) {
      // Guardar token y hacer login
      await TokenStorage.save(result['data']['token']);
      widget.onLogin();
    } else {
      setState(() {
        _errorMessage = result['message'] ?? t('wrong_user_pass', widget.locale);
      });
    }
  } catch (e) {
    setState(() {
      _errorMessage = 'Error de conexión: $e';
    });
  }
}
  void _tryRegister() async {
  setState(() {
    _errorMessage = null;
  });
  
  if (_registerEmailController.text.isEmpty ||
      _registerNameController.text.isEmpty ||
      _registerPasswordController.text.isEmpty ||
      _registerUserController.text.isEmpty) {
    setState(() {
      _errorMessage = t('fill_fields', widget.locale);
    });
    return;
  }

  try {
    // Usar el backend real para registro
    final result = await AuthService.register(
      _registerUserController.text.trim(),
      _registerPasswordController.text.trim(),
      _registerEmailController.text.trim(),
      _registerNameController.text.trim(),
    );
    
    if (result['ok'] == true) {
      // SOLO mostrar mensaje de éxito, NO hacer login automático
      setState(() {
        _errorMessage = t('register_success', widget.locale);
        _isRegister = false; // Volver a login
      });
      
      // Limpiar campos
      _registerEmailController.clear();
      _registerNameController.clear();
      _registerPasswordController.clear();
      _registerUserController.clear();
      
    } else {
      setState(() {
        _errorMessage = result['message'] ?? 'Error en el registro';
      });
    }
  } catch (e) {
    setState(() {
      _errorMessage = 'Error de conexión: $e';
    });
  }
}
  @override
  Widget build(BuildContext context) {
    final locale = widget.locale;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.heroGradient),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Colors.white,
                              Theme.of(context).colorScheme.primary.withOpacity(0.15),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.25),
                              blurRadius: 18,
                              spreadRadius: 2,
                              offset: const Offset(0, 6),
                            ),
                          ],
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Image.asset(
                            'assets/logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _isRegister ? t('register', locale) : t('login', locale),
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 24),
                    if (_isRegister) ...[
                      TextField(
                        controller: _registerEmailController,
                        decoration: InputDecoration(
                          labelText: t('email', locale),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          prefixIcon: const Icon(Icons.email_rounded),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _registerNameController,
                        decoration: InputDecoration(
                          labelText: t('name', locale),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          prefixIcon: const Icon(Icons.person_rounded),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _registerUserController,
                        decoration: InputDecoration(
                          labelText: t('user', locale),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          prefixIcon: const Icon(Icons.account_circle_rounded),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _registerPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: t('password', locale),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          prefixIcon: const Icon(Icons.lock_rounded),
                        ),
                      ),
                    ] else ...[
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: t('user', locale),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          prefixIcon: const Icon(Icons.person_rounded),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: t('password', locale),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          prefixIcon: const Icon(Icons.lock_rounded),
                        ),
                      ),
                    ],
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _errorMessage!,
                        style: TextStyle(
                          color: _errorMessage == t('register_success', locale)
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: _isRegister ? _tryRegister : _tryLogin,
                        child: Text(
                          _isRegister ? t('register', locale) : t('login', locale),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isRegister = !_isRegister;
                          _errorMessage = null;
                        });
                      },
                      child: Text(
                        _isRegister
                            ? t('have_account', locale)
                            : t('no_account', locale),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: widget.onChangeTheme,
                      icon: const Icon(Icons.color_lens_rounded),
                      label: Text(t('change_theme', locale)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}