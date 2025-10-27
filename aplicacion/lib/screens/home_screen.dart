import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../localization.dart';
import 'settings_screen.dart';
import '../widgets/hero_banner.dart';
import '../widgets/control_card.dart';
import '../services/token_storage.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onChangeTheme;
  final VoidCallback? onLogout;
  final String locale;
  final VoidCallback? onChangeLocale;
  final String? userName;
  final String? userUsername;

  const HomeScreen({
    Key? key,
    required this.onChangeTheme,
    this.onLogout,
    this.locale = 'es',
    this.onChangeLocale,
    this.userName,
    this.userUsername,
  }) : super(key: key);

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
  bool _sprinklersOn = false;
  bool _showTemperature = false;

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget body;
    if (_currentIndex == 1) {
      body = SettingsScreen(
        onChangeTheme: widget.onChangeTheme,
        onLogout: widget.onLogout ?? () {},
        userName: widget.userName,
        userUsername: widget.userUsername,
        locale: widget.locale,
        onChangeLocale: widget.onChangeLocale ?? () {},
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
                  child: HeroBanner(
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
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Cerrar sesión',
            onPressed: () async {
              await TokenStorage.delete();
              if (widget.onLogout != null) {
                widget.onLogout!();
              }
            },
          ),
        ],
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