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

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void _onLogin() {
    setState(() {
      _loggedIn = true;
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
            )
          : LoginScreen(
              onLogin: _onLogin,
            ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  final VoidCallback onLogin;
  const LoginScreen({super.key, required this.onLogin});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isRegister = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.heroGradient,
        ),
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
                    Icon(Icons.home_rounded, size: 56, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(height: 16),
                    Text(
                      _isRegister ? 'Registrarse' : 'Iniciar sesión',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Correo electrónico',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        prefixIcon: const Icon(Icons.email_rounded),
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
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          widget.onLogin();
                        },
                        child: Text(_isRegister ? 'Registrarse' : 'Iniciar sesión'),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isRegister = !_isRegister;
                        });
                      },
                      child: Text(_isRegister
                          ? '¿Ya tienes cuenta? Inicia sesión'
                          : '¿No tienes cuenta? Regístrate'),
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
  const HomeScreen({super.key, required this.onChangeTheme});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _mainDoorOpen = false;
  bool _garageDoorOpen = false;
  bool _livingWindowOpen = false;
  bool _bedroomWindowOpen = false;
  bool _acOn = false;

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget body;
    if (_currentIndex == 1) {
      body = SettingsScreen(
        onChangeTheme: widget.onChangeTheme,
      );
    } else {
      body = Stack(
        children: [
          Container(decoration: const BoxDecoration(gradient: AppTheme.heroGradient)),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _HeroBanner(
                    title: 'Controla tu hogar',
                    subtitle: 'Puertas, ventanas y aire acondicionado',
                    onQuickAction: () => setState(() {
                      _mainDoorOpen = false;
                      _garageDoorOpen = false;
                      _livingWindowOpen = false;
                      _bedroomWindowOpen = false;
                      _acOn = false;
                    }),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      'Aire acondicionado',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  sliver: SliverToBoxAdapter(
                    child: ControlCard(
                      title: 'Aire acondicionado',
                      icon: Icons.ac_unit_rounded,
                      isOpen: _acOn,
                      onToggle: () => setState(() => _acOn = !_acOn),
                      typeLabel: 'A/C',
                      activeColor: theme.colorScheme.primary,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      'Puertas',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.95,
                    ),
                    delegate: SliverChildListDelegate([
                      ControlCard(
                        title: 'Puerta Principal',
                        icon: Icons.door_front_door_rounded,
                        isOpen: _mainDoorOpen,
                        onToggle: () => setState(() => _mainDoorOpen = !_mainDoorOpen),
                        typeLabel: 'Puerta',
                        activeColor: theme.colorScheme.primary,
                      ),
                      ControlCard(
                        title: 'Puerta del Garaje',
                        icon: Icons.garage_rounded,
                        isOpen: _garageDoorOpen,
                        onToggle: () => setState(() => _garageDoorOpen = !_garageDoorOpen),
                        typeLabel: 'Puerta',
                        activeColor: theme.colorScheme.primary,
                      ),
                    ]),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      'Ventanas',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.95,
                    ),
                    delegate: SliverChildListDelegate([
                      ControlCard(
                        title: 'Ventana del Salón',
                        icon: Icons.window_rounded,
                        isOpen: _livingWindowOpen,
                        onToggle: () => setState(() => _livingWindowOpen = !_livingWindowOpen),
                        typeLabel: 'Ventana',
                        activeColor: theme.colorScheme.primary,
                      ),
                      ControlCard(
                        title: 'Ventana Dormitorio',
                        icon: Icons.sensor_window_rounded,
                        isOpen: _bedroomWindowOpen,
                        onToggle: () => setState(() => _bedroomWindowOpen = !_bedroomWindowOpen),
                        typeLabel: 'Ventana',
                        activeColor: theme.colorScheme.primary,
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
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded),
            label: 'Ajustes',
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 1
          ? null
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton.extended(
                  onPressed: () => setState(() => _acOn = !_acOn),
                  label: Text(_acOn ? 'Apagar A/C' : 'Encender A/C'),
                  icon: Icon(_acOn ? Icons.power_settings_new : Icons.ac_unit_rounded),
                  heroTag: 'acButton',
                ),
                const SizedBox(height: 12),
                _QuickAllButton(
                  allClosed: _allClosed,
                  onAction: () => setState(() {
                    if (_allClosed) {
                      _mainDoorOpen = true;
                      _garageDoorOpen = true;
                      _livingWindowOpen = true;
                      _bedroomWindowOpen = true;
                      _acOn = true;
                    } else {
                      _mainDoorOpen = false;
                      _garageDoorOpen = false;
                      _livingWindowOpen = false;
                      _bedroomWindowOpen = false;
                      _acOn = false;
                    }
                  }),
                ),
              ],
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  bool get _allClosed =>
      !_mainDoorOpen && !_garageDoorOpen && !_livingWindowOpen && !_bedroomWindowOpen && !_acOn;
}

class SettingsScreen extends StatelessWidget {
  final VoidCallback onChangeTheme;
  const SettingsScreen({super.key, required this.onChangeTheme});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        ListTile(
          leading: const Icon(Icons.color_lens_rounded),
          title: const Text('Cambiar tema'),
          subtitle: const Text('Alterna entre modo claro y oscuro'),
          trailing: ElevatedButton(
            onPressed: onChangeTheme,
            child: const Text('Cambiar'),
          ),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.account_circle_rounded),
          title: const Text('Datos de cuenta'),
          subtitle: const Text('Ver o editar información de tu cuenta'),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Datos de cuenta'),
                content: const Text('Aquí irían los datos de la cuenta del usuario.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cerrar'),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({
    required this.title,
    required this.subtitle,
    required this.onQuickAction,
  });

  final String title;
  final String subtitle;
  final VoidCallback onQuickAction;

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
                child: _GlowCircle(size: 160, color: theme.colorScheme.secondary),
              ),
              Positioned(
                left: -50,
                bottom: -50,
                child: _GlowCircle(size: 180, color: theme.colorScheme.primary.withOpacity(0.35)),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: DefaultTextStyle(
                        style: theme.textTheme.titleLarge!.copyWith(color: Colors.white),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title, style: theme.textTheme.displaySmall?.copyWith(color: Colors.white)),
                            const SizedBox(height: 6),
                            Text(subtitle, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70)),
                            const Spacer(),
                            ElevatedButton.icon(
                              onPressed: onQuickAction,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.secondary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              icon: const Icon(Icons.lock_rounded),
                              label: const Text('Cerrar todo'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.shield_moon_rounded, size: 72, color: theme.colorScheme.primary.withOpacity(0.7)),
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
      width: size, height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.25),
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: 50,
            spreadRadius: 10,
          ),
        ],
      ),
    );
  }
}

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

  const ControlCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.isOpen,
    required this.onToggle,
    required this.typeLabel,
    this.activeColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color color = isOpen ? (activeColor ?? theme.colorScheme.primary) : Colors.grey.shade400;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(10),
              child: Icon(icon, size: 38, color: color),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              isOpen ? '$typeLabel activa' : '$typeLabel desactivada',
              style: theme.textTheme.labelMedium?.copyWith(
                color: color,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: 48,
              height: 38,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.zero,
                  elevation: isOpen ? 6 : 2,
                ),
                onPressed: onToggle,
                child: Icon(
                  isOpen ? Icons.toggle_on_rounded : Icons.toggle_off_rounded,
                  size: 32,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}