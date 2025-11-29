import 'package:flutter/material.dart';
import 'dart:async';
import '../app_theme.dart';
import '../localization.dart';
import 'settings_screen.dart';
import 'single_camera_screen.dart';
import '../widgets/hero_banner.dart';
import '../widgets/control_card.dart';
import '../services/token_storage.dart';
import '../services/sensor_service.dart';
import '../services/control_service.dart';

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
  // Estados para controles manuales
  bool _mainDoorOpen = false;
  bool _gateOpen = false;
  bool _luzEncendida = false;
  
  // Datos en tiempo real de sensores
  double _currentTemperature = 0.0;
  double _currentHumidity = 0.0;
  bool _realMainDoor = false;
  DateTime _lastUpdate = DateTime.now();
  Timer? _sensorTimer;
  bool _sensorsConnected = false;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadSensorData();
    _sensorTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _loadSensorData();
    });
  }

  @override
  void dispose() {
    _sensorTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadSensorData() async {
    try {
      final result = await SensorService.getSensorData();
      if (result['ok'] == true && mounted) {
        final data = result['data'];
        final previousDoorState = _realMainDoor;
        
        setState(() {
          _currentTemperature = data['temperature']?.toDouble() ?? 0.0;
          _currentHumidity = data['humidity']?.toDouble() ?? 0.0;
          _realMainDoor = data['mainDoor'] ?? false;
          _lastUpdate = DateTime.parse(data['lastUpdate']);
          _sensorsConnected = true;
          _mainDoorOpen = _realMainDoor;
        });
        
        if (_realMainDoor && !previousDoorState) {
          _showDoorAlert();
        }
      } else {
        setState(() {
          _sensorsConnected = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _sensorsConnected = false;
        });
      }
    }
  }

  void _showDoorAlert() {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '🚨 ${t('door_alert', widget.locale)}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }

  void _refreshSensorData() {
    _loadSensorData();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('📡 ${t('updating_sensors', widget.locale)}'),
        backgroundColor: AppTheme.darkAccent,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _navigateToCamera() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SingleCameraScreen(locale: widget.locale),
      ),
    );
  }

  Widget _buildHomeContent(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    
    return Stack(
      children: [
        // FONDO CON GRADIENTE MEJORADO
        Container(
          decoration: isDark 
              ? AppTheme.getDarkGradientDecoration()
              : const BoxDecoration(gradient: AppTheme.heroGradient),
        ),
        
        // EFECTO DE PARTÍCULAS SUTILES (opcional)
        if (isDark) ...[
          _buildAnimatedBackground(),
        ],
        
        SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // BANNER HERO MEJORADO
              SliverToBoxAdapter(
                child: HeroBanner(
                  title: t('control_home', widget.locale),
                  subtitle: t('subtitle_home', widget.locale),
                  locale: widget.locale,
                ),
              ),
              
              const SliverToBoxAdapter(child: SizedBox(height: 8)),
              
              // SECCIÓN: MONITOREO EN VIVO
              _buildSectionTitle('Cámara y Sensores', theme, Icons.monitor_heart_rounded),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.95,
                  ),
                  delegate: SliverChildListDelegate([
                    // Cámara de seguridad
                    ControlCard(
                      title: t('security_camera', widget.locale),
                      icon: Icons.videocam_rounded,
                      isOpen: true,
                      onToggle: _navigateToCamera,
                      typeLabel: 'Streaming',
                      activeColor: Colors.blue,
                      locale: widget.locale,
                      isDark: isDark,
                    ),
                    // Sensor de temperatura/humedad
                    ControlCard(
                      title: t('temperature', widget.locale),
                      icon: Icons.thermostat_rounded,
                      isOpen: true,
                      onToggle: _refreshSensorData,
                      typeLabel: '${_currentTemperature.toStringAsFixed(1)}°C - ${_currentHumidity.toStringAsFixed(1)}%',
                      activeColor: _getTemperatureColor(_currentTemperature),
                      locale: widget.locale,
                      isDark: isDark,
                    ),
                  ]),
                ),
              ),

              // Indicador de última actualización
              _buildLastUpdateIndicator(isDark),

              const SliverToBoxAdapter(child: SizedBox(height: 8)),

              // SECCIÓN: PUERTAS
              _buildSectionTitle(t('doors', widget.locale), theme, Icons.door_front_door_rounded),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  delegate: SliverChildListDelegate([
                    ControlCard(
                      title: t('main_door', widget.locale),
                      icon: Icons.door_front_door_rounded,
                      isOpen: _mainDoorOpen,
                      onToggle: () async {
                        setState(() => _mainDoorOpen = !_mainDoorOpen);
                        final action = _mainDoorOpen ? 'OPEN' : 'CLOSE';
                        final success = await ControlService.sendCommand('puerta', action);

                        if (!success && mounted) {
                          setState(() => _mainDoorOpen = !_mainDoorOpen);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Error al controlar la puerta'),
                              backgroundColor: Colors.red[400],
                            ),
                          );
                        }
                      },
                      typeLabel: _realMainDoor ? 
                        '${t('open', widget.locale)} (${t('sensor', widget.locale)})' : 
                        '${t('closed', widget.locale)} (${t('sensor', widget.locale)})',
                      activeColor: _mainDoorOpen ? theme.colorScheme.primary : Colors.grey,
                      locale: widget.locale,
                      isDark: isDark,
                    ),
                  ]),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 8)),

              // SECCIÓN: EXTERIORES (Portón y Luces)
              _buildSectionTitle('Exteriores', theme, Icons.forest_rounded),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.95,
                  ),
                  delegate: SliverChildListDelegate([
                    ControlCard(
                      title: 'Portón',
                      icon: Icons.fence_rounded,
                      isOpen: _gateOpen,
                      typeLabel: 'Acceso',
                      activeColor: Colors.green,
                      locale: widget.locale,
                      isDark: isDark,
                      onToggle: () async {
                        setState(() => _gateOpen = !_gateOpen);
                        final action = _gateOpen ? 'OPEN' : 'CLOSE';
                        final success = await ControlService.sendCommand('porton', action);
                        if (!success && mounted) {
                          setState(() => _gateOpen = !_gateOpen);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Error al conectar con el portón'),
                              backgroundColor: Colors.red[400],
                            ),
                          );
                        }
                      },
                    ),
                    
                    ControlCard(
                      title: 'Luz Patio',
                      icon: Icons.lightbulb_rounded,
                      isOpen: _luzEncendida,
                      typeLabel: 'RGB',
                      activeColor: Colors.orange,
                      locale: widget.locale,
                      isDark: isDark,
                      onToggle: () async {
                        setState(() => _luzEncendida = !_luzEncendida);
                        final action = _luzEncendida ? 'ON' : 'OFF';
                        final success = await ControlService.sendCommand('luz', action);
                        if (!success && mounted) {
                          setState(() => _luzEncendida = !_luzEncendida);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Error al controlar luz'),
                              backgroundColor: Colors.red[400],
                            ),
                          );
                        }
                      },
                    ),
                  ]),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),
        ),
      ],
    );
  }

  // FONDO ANIMADO PARA TEMA OSCURO
  Widget _buildAnimatedBackground() {
    return IgnorePointer(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topLeft,
            radius: 1.5,
            colors: [
              AppTheme.darkAccent.withOpacity(0.1),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme, IconData icon) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
        child: Row(
          children: [
            Icon(
              icon,
              color: theme.colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLastUpdateIndicator(bool isDark) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkSurface.withOpacity(0.5) : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppTheme.darkTextSecondary.withOpacity(0.3) : Colors.grey.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.update_rounded,
              size: 16,
              color: isDark ? AppTheme.darkTextSecondary : Colors.grey[600],
            ),
            const SizedBox(width: 8),
            Text(
              '${t('last_update', widget.locale)}: ${_formatLastUpdate()}',
              style: TextStyle(
                color: isDark ? AppTheme.darkTextSecondary : Colors.grey[600],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
      body = _buildHomeContent(theme);
    }

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: const Text(
          'NeuroHome',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // Indicador de sensores con mejor diseño
          Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.darkSurface : Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _sensorsConnected 
                  ? Colors.green.withOpacity(0.5)
                  : Colors.grey.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _sensorsConnected ? Icons.sensors_rounded : Icons.sensors_off_rounded,
                  color: _sensorsConnected ? Colors.green : Colors.grey,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  _sensorsConnected ? 'Online' : 'Offline',
                  style: TextStyle(
                    color: _sensorsConnected ? Colors.green : Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.logout_rounded,
              color: isDark ? AppTheme.darkTextPrimary : theme.colorScheme.primary,
            ),
            tooltip: t('logout', widget.locale),
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (i) => setState(() => _currentIndex = i),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          backgroundColor: isDark ? AppTheme.darkSurface : Colors.white,
          indicatorColor: isDark ? AppTheme.darkAccent : theme.colorScheme.primary,
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
      ),
    );
  }

  Color _getTemperatureColor(double temperature) {
    if (temperature < 15) return Colors.blue;
    if (temperature > 28) return Colors.red;
    return Colors.orange;
  }

  String _formatLastUpdate() {
    final now = DateTime.now();
    final difference = now.difference(_lastUpdate);
    
    if (difference.inSeconds < 60) {
      return 'hace ${difference.inSeconds} seg';
    } else if (difference.inMinutes < 60) {
      return 'hace ${difference.inMinutes} min';
    } else {
      return 'hace ${difference.inHours} h';
    }
  }
}