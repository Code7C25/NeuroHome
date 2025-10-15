import 'package:flutter/material.dart';

class AppTheme {
    static const LinearGradient heroGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF6EE7B7), // Verde menta
        Color(0xFF3B82F6), // Azul activo
        Color(0xFFF472B6), // Rosa vibrante
      ],
    );
}

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
  String _locale = 'es'; // 'es' para español, 'en' para inglés

  // NUEVO: Datos de usuario
  String? _userEmail;
  String? _userName;
  String? _userUsername;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  void _onLogin() {
    setState(() {
      _loggedIn = true;
    });
  }

  // NUEVO: Recibe datos de registro
  void _onRegister({
    required String email,
    required String name,
    required String username,
  }) {
    setState(() {
      _userEmail = email;
      _userName = name;
      _userUsername = username;
      _loggedIn = true;
    });
  }

  void _onLogout() {
    setState(() {
      _loggedIn = false;
    });
  }

  void _toggleLocale() {
    setState(() {
      _locale = _locale == 'es' ? 'en' : 'es';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3B82F6),
          primary: const Color(0xFF3B82F6),
          secondary: const Color(0xFFF472B6),
          background: const Color(0xFFF0F9FF),
        ),
        scaffoldBackgroundColor: const Color(0xFFF0F9FF),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF3B82F6),
          foregroundColor: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Color(0xFF3B82F6),
        ),
      ),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      home: _loggedIn
          ? HomeScreen(
              onChangeTheme: _toggleTheme,
              onLogout: _onLogout,
              userEmail: _userEmail,
              userName: _userName,
              userUsername: _userUsername,
              locale: _locale,
              onChangeLocale: _toggleLocale,
            )
          : LoginScreen(
              onLogin: _onLogin,
              onChangeTheme: _toggleTheme,
              onRegister: _onRegister, // NUEVO
              locale: _locale,
            ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  final VoidCallback onLogin;
  final VoidCallback onChangeTheme;
  final void Function({
    required String email,
    required String name,
    required String username,
  })? onRegister; // NUEVO
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

  void _tryLogin() {
    setState(() {
      _errorMessage = null;
    });
    final user = _emailController.text.trim();
    final pass = _passwordController.text.trim();
    if (user == "user" && pass == "1111") {
      widget.onLogin();
    } else {
      setState(() {
        _errorMessage = "Usuario o contraseña incorrectos";
      });
    }
  }

  void _tryRegister() {
    setState(() {
      _errorMessage = null;
    });
    if (_registerEmailController.text.isEmpty ||
        _registerNameController.text.isEmpty ||
        _registerPasswordController.text.isEmpty ||
        _registerUserController.text.isEmpty) {
      setState(() {
        _errorMessage = "Completa todos los campos";
      });
      return;
    }
    // Simula registro exitoso y pasa datos al estado principal
    widget.onRegister?.call(
      email: _registerEmailController.text.trim(),
      name: _registerNameController.text.trim(),
      username: _registerUserController.text.trim(),
    );
    // Al volver a login, autocompleta usuario y limpia contraseña
    setState(() {
      _isRegister = false;
      _emailController.text = _registerUserController.text.trim();
      _passwordController.clear();
      _errorMessage = "¡Registro exitoso! Ahora inicia sesión.";
    });
    // Limpia los campos de registro
    _registerEmailController.clear();
    _registerNameController.clear();
    _registerPasswordController.clear();
    _registerUserController.clear();
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
                          labelText: 'Nombre completo',
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
                          labelText: 'Usuario',
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
                          labelText: 'Contraseña',
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
                          labelText: 'Contraseña',
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
                        _errorMessage == "¡Registro exitoso! Ahora inicia sesión." || _errorMessage == "Registration successful! Now login."
                          ? t('register_success', locale)
                          : (_errorMessage == "Completa todos los campos" || _errorMessage == "Complete all fields"
                              ? t('fill_fields', locale)
                              : t('wrong_user_pass', locale)),
                        style: TextStyle(
                          color: _errorMessage == "¡Registro exitoso! Ahora inicia sesión." || _errorMessage == "Registration successful! Now login."
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

class HomeScreen extends StatefulWidget {
  final VoidCallback onChangeTheme;
  final VoidCallback onLogout;
  final String? userEmail;
  final String? userName;
  final String? userUsername;
  final String locale;
  final VoidCallback onChangeLocale;

  const HomeScreen({
    super.key,
    required this.onChangeTheme,
    required this.onLogout,
    this.userEmail,
    this.userName,
    this.userUsername,
    required this.locale,
    required this.onChangeLocale,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _mainDoorOpen = false;
  bool _garageDoorOpen = false;
  bool _livingWindowOpen = false;
  bool _bedroomWindowOpen = false;
  bool _bedroom2WindowOpen = false;
  bool _acOn = false;
  bool _sprinklersOn = false; // Nuevo: regadores
  bool _showTemperature = false; // Nuevo: pantalla de temperatura

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget body;
    if (_currentIndex == 1) {
      body = SettingsScreen(
        onChangeTheme: widget.onChangeTheme,
        onLogout: widget.onLogout,
        userEmail: widget.userEmail,
        userName: widget.userName,
        userUsername: widget.userUsername,
        locale: widget.locale,
        onChangeLocale: widget.onChangeLocale,
      );
    } else {
      body = Stack(
        children: [
          Container(
            decoration: const BoxDecoration(gradient: AppTheme.heroGradient),
          ),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _HeroBanner(
                    title: t('control_home', widget.locale),
                    subtitle: t('subtitle_home', widget.locale),
                    locale: widget.locale,
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      t('air_conditioner', widget.locale) + ' & ' + t('sprinklers', widget.locale),
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.95,
                        ),
                    delegate: SliverChildListDelegate([
                      ControlCard(
                        title: t('air_conditioner', widget.locale),
                        icon: Icons.ac_unit_rounded,
                        isOpen: _acOn,
                        onToggle: () => setState(() => _acOn = !_acOn),
                        typeLabel: t('air_conditioner', widget.locale),
                        activeColor: theme.colorScheme.primary,
                        locale: widget.locale,
                      ),
                      ControlCard(
                        title: t('sprinklers', widget.locale),
                        icon: Icons.grass_rounded,
                        isOpen: _sprinklersOn,
                        onToggle: () => setState(() => _sprinklersOn = !_sprinklersOn),
                        typeLabel: t('sprinklers', widget.locale),
                        activeColor: Colors.green,
                        locale: widget.locale,
                      ),
                      ControlCard(
                        title: t('temperature_screen', widget.locale),
                        icon: Icons.thermostat_rounded,
                        isOpen: _showTemperature,
                        onToggle: () => setState(() => _showTemperature = !_showTemperature),
                        typeLabel: t('temperature_screen', widget.locale),
                        activeColor: Colors.orange,
                        locale: widget.locale,
                      ),
                    ]),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      t('doors', widget.locale),
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.85,
                        ),
                    delegate: SliverChildListDelegate([
                      ControlCard(
                        title: t('main_door', widget.locale),
                        icon: Icons.door_front_door_rounded,
                        isOpen: _mainDoorOpen,
                        onToggle: () =>
                            setState(() => _mainDoorOpen = !_mainDoorOpen),
                        typeLabel: t('doors', widget.locale),
                        activeColor: theme.colorScheme.primary,
                        locale: widget.locale,
                      ),
                      ControlCard(
                        title: t('garage_door', widget.locale),
                        icon: Icons.garage_rounded,
                        isOpen: _garageDoorOpen,
                        onToggle: () =>
                            setState(() => _garageDoorOpen = !_garageDoorOpen),
                        typeLabel: t('doors', widget.locale),
                        activeColor: theme.colorScheme.primary,
                        locale: widget.locale,
                      ),
                    ]),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      t('windows', widget.locale),
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.95,
                        ),
                    delegate: SliverChildListDelegate([
                      ControlCard(
                        title: t('living_window', widget.locale),
                        icon: Icons.window_rounded,
                        isOpen: _livingWindowOpen,
                        onToggle: () => setState(
                          () => _livingWindowOpen = !_livingWindowOpen,
                        ),
                        typeLabel: t('windows', widget.locale),
                        activeColor: theme.colorScheme.primary,
                        locale: widget.locale,
                      ),
                      ControlCard(
                        title: t('bedroom1_window', widget.locale),
                        icon: Icons.sensor_window_rounded,
                        isOpen: _bedroomWindowOpen,
                        onToggle: () => setState(
                          () => _bedroomWindowOpen = !_bedroomWindowOpen,
                        ),
                        typeLabel: t('windows', widget.locale),
                        activeColor: theme.colorScheme.primary,
                        locale: widget.locale,
                      ),
                      ControlCard(
                        title: t('bedroom2_window', widget.locale),
                        icon: Icons.sensor_window_rounded,
                        isOpen: _bedroom2WindowOpen,
                        onToggle: () => setState(
                          () => _bedroom2WindowOpen = !_bedroom2WindowOpen,
                        ),
                        typeLabel: t('windows', widget.locale),
                        activeColor: theme.colorScheme.primary,
                        locale: widget.locale,
                      ),
                    ]),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 60)),
              ],
            ),
          ),
        ],
      );
    }

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: const Text('NeuroHome'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: body,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home_rounded),
            label: t('home', widget.locale),
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings_rounded),
            label: t('settings', widget.locale),
          ),
        ],
      ),
    );
    }
  }




class SettingsScreen extends StatelessWidget {
  final VoidCallback onChangeTheme;
  final VoidCallback onLogout;
  final String? userEmail;
  final String? userName;
  final String? userUsername;
  final String locale;
  final VoidCallback onChangeLocale;

  const SettingsScreen({
    super.key,
    required this.onChangeTheme,
    required this.onLogout,
    required this.userEmail,
    required this.userName,
    required this.userUsername,
    required this.locale,
    required this.onChangeLocale,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        ListTile(
          leading: const Icon(Icons.color_lens_rounded),
          title: Text(t('change_theme', locale)),
          subtitle: Text(locale == 'es'
              ? 'Alterna entre modo claro y oscuro'
              : 'Switch between light and dark mode'),
          trailing: ElevatedButton(
            onPressed: onChangeTheme,
            child: Text(t('change_theme', locale)),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.language_rounded),
          title: Text(t('change_language', locale)),
          subtitle: Text(locale == 'es'
              ? 'Cambia entre español e inglés'
              : 'Switch between Spanish and English'),
          trailing: ElevatedButton(
            onPressed: onChangeLocale,
            child: Text(locale == 'es' ? 'EN' : 'ES'),
          ),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.account_circle_rounded),
          title: Text(t('account_data', locale)),
          subtitle: Text(t('account_data_sub', locale)),
          onTap: () {
            showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              builder: (context) => Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Icon(Icons.account_circle_rounded, size: 60),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      t('email_label', locale),
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    Text(userEmail ?? t('no_account', locale)),
                    const SizedBox(height: 12),
                    Text(
                      t('name_label', locale),
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    Text(userName ?? t('no_account', locale)),
                    const SizedBox(height: 12),
                    Text(
                      t('user_label', locale),
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    Text(userUsername ?? t('no_account', locale)),
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(t('close', locale)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.devices_other_rounded),
          title: Text(t('connect_devices', locale)),
          subtitle: Text(t('connect_devices_sub', locale)),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const DeviceConnectionScreen(),
              ),
            );
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout_rounded, color: Colors.red),
          title: Text(t('logout', locale), style: const TextStyle(color: Colors.red)),
          onTap: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(t('logout_confirm', locale)),
                content: Text(t('logout_question', locale)),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(t('cancel', locale)),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(t('logout', locale)),
                  ),
                ],
              ),
            );
            if (confirm == true) {
              onLogout();
            }
          },
        ),
      ],
    );
  }
}

// Nueva pantalla para conectar dispositivos
class DeviceConnectionScreen extends StatelessWidget {
  const DeviceConnectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conectar dispositivos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Conexión de cámaras y sensores',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 18),
            const Text(
              'Aquí podrás conectar y configurar tus cámaras, sensores y otros dispositivos inteligentes compatibles con NeuroHome.',
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt_rounded),
              label: const Text('Agregar cámara'),
              onPressed: () {
                // Aquí iría la lógica para conectar una cámara
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Funcionalidad próximamente')),
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.sensors_rounded),
              label: const Text('Agregar sensor'),
              onPressed: () {
                // Aquí iría la lógica para conectar un sensor
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Funcionalidad próximamente')),
                );
              },
            ),
            // Puedes agregar más botones para otros dispositivos aquí
          ],
        ),
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({
    required this.title,
    required this.subtitle,
    required this.locale, // <-- Añade esto
  });

  final String title;
  final String subtitle;
  final String locale; // <-- Añade esto

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          height: 160,
          decoration: BoxDecoration(
            gradient: AppTheme.heroGradient,
            border: Border.all(color: Colors.white12),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -40,
                top: -30,
                child: _GlowCircle(
                  size: 160,
                  color: theme.colorScheme.secondary,
                ),
              ),
              Positioned(
                left: -50,
                bottom: -50,
                child: _GlowCircle(
                  size: 180,
                  color: theme.colorScheme.primary.withOpacity(0.35),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: DefaultTextStyle(
                        style: theme.textTheme.titleLarge!.copyWith(
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: theme.textTheme.displaySmall?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              subtitle,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.85),
                        border: Border.all(
                          color: theme.colorScheme.primary.withOpacity(0.5),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withOpacity(0.15),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Image.asset(
                          'assets/logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  const _GlowCircle({required this.size, required this.color});
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.25),
        boxShadow: [BoxShadow(color: color, blurRadius: 50, spreadRadius: 10)],
      ),
    );
  }
}

// ignore: unused_element
class _QuickAllButton extends StatelessWidget {
  const _QuickAllButton({required this.allClosed, required this.onAction});
  final bool allClosed;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onAction,
      label: Text(allClosed ? 'Abrir todo' : 'Cerrar todo'),
      icon: Icon(allClosed ? Icons.lock_open_rounded : Icons.lock_rounded),
      backgroundColor: Theme.of(context).colorScheme.secondary,
      foregroundColor: Colors.white,
    );
  }
}

// ControlCard widget definition
class ControlCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isOpen;
  final VoidCallback onToggle;
  final String typeLabel;
  final Color? activeColor;
  final String locale; // <-- Añade esto

  const ControlCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.isOpen,
    required this.onToggle,
    required this.typeLabel,
    this.activeColor,
    required this.locale, // <-- Añade esto
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color color = isOpen
        ? (activeColor ?? theme.colorScheme.primary)
        : Colors.grey.shade400;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                isOpen ? t('open', locale) : t('closed', locale),
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                typeLabel,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const Map<String, Map<String, String>> appTexts = {
  'es': {
    'login': 'Iniciar sesión',
    'register': 'Registrarse',
    'email': 'Correo electrónico',
    'name': 'Nombre completo',
    'user': 'Usuario',
    'password': 'Contraseña',
    'no_account': '¿No tienes cuenta? Regístrate',
    'have_account': '¿Ya tienes cuenta? Inicia sesión',
    'change_theme': 'Cambiar tema',
    'change_language': 'Cambiar idioma',
    'settings': 'Ajustes',
    'home': 'Inicio',
    'control_home': 'Controla tu hogar',
    'subtitle_home': 'Puertas, ventanas y aire acondicionado',
    'air_conditioner': 'Aire acondicionado',
    'sprinklers': 'Regadores',
    'temperature_screen': 'Pantalla Temperatura',
    'doors': 'Puertas',
    'main_door': 'Puerta Principal',
    'garage_door': 'Puerta del Garaje',
    'windows': 'Ventanas',
    'living_window': 'Ventana Comedor',
    'bedroom1_window': 'Ventana Dormitorio 1',
    'bedroom2_window': 'Ventana Dormitorio 2',
    'open': 'Abierto',
    'closed': 'Cerrado',
    'account_data': 'Datos de cuenta',
    'account_data_sub': 'Ver o editar información de tu cuenta',
    'email_label': 'Correo electrónico:',
    'name_label': 'Nombre completo:',
    'user_label': 'Usuario:',
    'close': 'Cerrar',
    'connect_devices': 'Conectar dispositivos',
    'connect_devices_sub': 'Cámaras, sensores y más',
    'logout': 'Cerrar sesión',
    'logout_confirm': '¿Cerrar sesión?',
    'logout_question': '¿Estás seguro de que deseas cerrar la sesión?',
    'cancel': 'Cancelar',
    'register_success': '¡Registro exitoso! Ahora inicia sesión.',
    'fill_fields': 'Completa todos los campos',
    'wrong_user_pass': 'Usuario o contraseña incorrectos',
  },
  'en': {
    'login': 'Login',
    'register': 'Register',
    'email': 'Email',
    'name': 'Full name',
    'user': 'Username',
    'password': 'Password',
    'no_account': "Don't have an account? Register",
    'have_account': 'Already have an account? Login',
    'change_theme': 'Change theme',
    'change_language': 'Change language',
    'settings': 'Settings',
    'home': 'Home',
    'control_home': 'Control your home',
    'subtitle_home': 'Doors, windows and air conditioning',
    'air_conditioner': 'Air Conditioner',
    'sprinklers': 'Sprinklers',
    'temperature_screen': 'Temperature Screen',
    'doors': 'Doors',
    'main_door': 'Main Door',
    'garage_door': 'Garage Door',
    'windows': 'Windows',
    'living_window': 'Living Room Window',
    'bedroom1_window': 'Bedroom 1 Window',
    'bedroom2_window': 'Bedroom 2 Window',
    'open': 'Open',
    'closed': 'Closed',
    'account_data': 'Account Data',
    'account_data_sub': 'View or edit your account information',
    'email_label': 'Email:',
    'name_label': 'Full name:',
    'user_label': 'Username:',
    'close': 'Close',
    'connect_devices': 'Connect devices',
    'connect_devices_sub': 'Cameras, sensors and more',
    'logout': 'Logout',
    'logout_confirm': 'Logout?',
    'logout_question': 'Are you sure you want to logout?',
    'cancel': 'Cancel',
    'register_success': 'Registration successful! Now login.',
    'fill_fields': 'Complete all fields',
    'wrong_user_pass': 'Incorrect username or password',
  }
};

String t(String key, String locale) => appTexts[locale]?[key] ?? key;
