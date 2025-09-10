import 'package:flutter/material.dart';

class AppTheme {
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0E224F),
      Color(0xFF0A1738),
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
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      home: HomeScreen(
        onChangeTheme: _toggleTheme,
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

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget body;
    if (_currentIndex == 2) {
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
                    subtitle: 'Puertas y ventanas • Seguro y rápido',
                    onQuickAction: () => setState(() {
                      _mainDoorOpen = false;
                      _garageDoorOpen = false;
                      _livingWindowOpen = false;
                      _bedroomWindowOpen = false;
                    }),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      'Puertas',
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 6,
                      mainAxisSpacing: 6,
                      childAspectRatio: 0.95, // Más cuadrado y compacto
                    ),
                    delegate: SliverChildListDelegate([
                      ControlCard(
                        title: 'Puerta Principal',
                        icon: Icons.door_front_door_rounded,
                        isOpen: _mainDoorOpen,
                        onToggle: () => setState(() => _mainDoorOpen = !_mainDoorOpen),
                        typeLabel: 'Puerta',
                      ),
                      ControlCard(
                        title: 'Puerta del Garaje',
                        icon: Icons.garage_rounded,
                        isOpen: _garageDoorOpen,
                        onToggle: () => setState(() => _garageDoorOpen = !_garageDoorOpen),
                        typeLabel: 'Puerta',
                      ),
                    ]),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      'Ventanas',
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 6,
                      mainAxisSpacing: 6,
                      childAspectRatio: 0.95,
                    ),
                    delegate: SliverChildListDelegate([
                      ControlCard(
                        title: 'Ventana del Salón',
                        icon: Icons.window_rounded,
                        isOpen: _livingWindowOpen,
                        onToggle: () => setState(() => _livingWindowOpen = !_livingWindowOpen),
                        typeLabel: 'Ventana',
                      ),
                      ControlCard(
                        title: 'Ventana Dormitorio',
                        icon: Icons.sensor_window_rounded,
                        isOpen: _bedroomWindowOpen,
                        onToggle: () => setState(() => _bedroomWindowOpen = !_bedroomWindowOpen),
                        typeLabel: 'Ventana',
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
        title: const Text('Escenas y Dispositivos'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: body,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.devices_other_outlined),
            selectedIcon: Icon(Icons.devices_rounded),
            label: 'Dispositivos',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded),
            label: 'Ajustes',
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 2
          ? null
          : _QuickAllButton(
              allClosed: _allClosed,
              onAction: () => setState(() {
                if (_allClosed) {
                  _mainDoorOpen = true;
                  _garageDoorOpen = true;
                  _livingWindowOpen = true;
                  _bedroomWindowOpen = true;
                } else {
                  _mainDoorOpen = false;
                  _garageDoorOpen = false;
                  _livingWindowOpen = false;
                  _bedroomWindowOpen = false;
                }
              }),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  bool get _allClosed =>
      !_mainDoorOpen && !_garageDoorOpen && !_livingWindowOpen && !_bedroomWindowOpen;
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
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 160,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0E224F),
                Color(0xFF0A1738),
              ],
            ),
            border: Border.all(color: Colors.white12),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -40,
                top: -30,
                child: _GlowCircle(size: 160, color: Colors.white24),
              ),
              Positioned(
                left: -50,
                bottom: -50,
                child: _GlowCircle(size: 180, color: const Color(0xFF1B4EA1).withOpacity(0.35)),
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
                            Text(title, style: theme.textTheme.displaySmall),
                            const SizedBox(height: 6),
                            Text(subtitle, style: theme.textTheme.bodyMedium),
                            const Spacer(),
                            ElevatedButton.icon(
                              onPressed: onQuickAction,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
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
                    const Icon(Icons.shield_moon_rounded, size: 72, color: Colors.white70),
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

  const ControlCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.isOpen,
    required this.onToggle,
    required this.typeLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 38, color: isOpen ? Colors.green : Colors.grey),
            const SizedBox(height: 8),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(fontSize: 16),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text(
              isOpen ? '$typeLabel activa' : '$typeLabel desactivada',
              style: theme.textTheme.labelMedium?.copyWith(
                color: isOpen ? Colors.green : Colors.grey,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            IconButton(
              icon: Icon(
                isOpen ? Icons.toggle_on_rounded : Icons.toggle_off_rounded,
                color: isOpen ? Colors.green : Colors.grey,
                size: 34,
              ),
              onPressed: onToggle,
              tooltip: isOpen ? 'Desactivar' : 'Activar',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }
}
