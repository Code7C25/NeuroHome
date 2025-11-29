import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../localization.dart';
import '../services/auth_service.dart';    
import '../services/token_storage.dart';   

class LoginScreen extends StatefulWidget {
  final VoidCallback onLogin;
  final Function(Map<String, dynamic>)? onLoginWithData;
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
    this.onLoginWithData,
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
        // Guardar token
        await TokenStorage.save(result['data']['token']);
        
        // Obtener datos del usuario de la respuesta
        final userData = result['data']['user'];
        
        // Usar el nuevo callback si está disponible, sino el antiguo
        if (widget.onLoginWithData != null) {
          widget.onLoginWithData!({
            'email': userData['email'] ?? '',
            'name': userData['name'] ?? '',
            'username': userData['username'] ?? username,
          });
        } else {
          widget.onLogin();
        }
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

    final email = _registerEmailController.text.trim();
    final name = _registerNameController.text.trim();
    final username = _registerUserController.text.trim();
    final password = _registerPasswordController.text.trim();

    // Validación 1: Campos vacíos
    if (email.isEmpty || name.isEmpty || username.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = t('fill_fields', widget.locale);
      });
      return;
    }

    // Validación 2: Email válido
    if (!_isValidEmail(email)) {
      setState(() {
        _errorMessage = widget.locale == 'es' 
            ? 'Ingresa un email válido (ej: usuario@dominio.com)'
            : 'Enter a valid email (ex: user@domain.com)';
      });
      return;
    }

    // Validación 3: Nombre muy corto
    if (name.length < 2) {
      setState(() {
        _errorMessage = widget.locale == 'es'
            ? 'El nombre debe tener al menos 2 caracteres'
            : 'Name must be at least 2 characters long';
      });
      return;
    }

    // Validación 4: Usuario muy corto
    if (username.length < 3) {
      setState(() {
        _errorMessage = widget.locale == 'es'
            ? 'El usuario debe tener al menos 3 caracteres'
            : 'Username must be at least 3 characters long';
      });
      return;
    }

    // Validación 5: Contraseña segura
    if (password.length < 6) {
      setState(() {
        _errorMessage = widget.locale == 'es'
            ? 'La contraseña debe tener al menos 6 caracteres'
            : 'Password must be at least 6 characters long';
      });
      return;
    }

    try {
      // Usar el backend real para registro
      final result = await AuthService.register(username, password, email, name);
      
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

  // Método para validar email
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    );
    return emailRegex.hasMatch(email);
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
                      TextFormField(
                        controller: _registerEmailController,
                        decoration: InputDecoration(
                          labelText: t('email', locale),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          prefixIcon: const Icon(Icons.email_rounded),
                          hintText: widget.locale == 'es' ? 'ejemplo@mail.com' : 'example@mail.com',
                        ),
                        keyboardType: TextInputType.emailAddress,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value != null && value.isNotEmpty && !_isValidEmail(value)) {
                            return widget.locale == 'es' 
                                ? 'Email no válido'
                                : 'Invalid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _registerNameController,
                        decoration: InputDecoration(
                          labelText: t('name', locale),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          prefixIcon: const Icon(Icons.person_rounded),
                          hintText: widget.locale == 'es' ? 'Mínimo 2 caracteres' : 'At least 2 characters',
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value != null && value.isNotEmpty && value.length < 2) {
                            return widget.locale == 'es'
                                ? 'Mínimo 2 caracteres'
                                : 'At least 2 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _registerUserController,
                        decoration: InputDecoration(
                          labelText: t('user', locale),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          prefixIcon: const Icon(Icons.account_circle_rounded),
                          hintText: widget.locale == 'es' ? 'Mínimo 3 caracteres' : 'At least 3 characters',
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value != null && value.isNotEmpty && value.length < 3) {
                            return widget.locale == 'es'
                                ? 'Mínimo 3 caracteres'
                                : 'At least 3 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _registerPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: t('password', locale),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          prefixIcon: const Icon(Icons.lock_rounded),
                          hintText: widget.locale == 'es' ? 'Mínimo 6 caracteres' : 'At least 6 characters',
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value != null && value.isNotEmpty && value.length < 6) {
                            return widget.locale == 'es'
                                ? 'Mínimo 6 caracteres'
                                : 'At least 6 characters';
                          }
                          return null;
                        },
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