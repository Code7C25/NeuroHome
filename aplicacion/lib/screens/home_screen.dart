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
import '../services/control_service.dart'; // ✅ Importación agregada

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
  bool _luzEncendida = false; // ✅ NUEVA VARIABLE PARA LA LUZ
  
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
    // Actualizar cada 5 segundos
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
          
          // Sincronizar estado visual con datos reales
          _mainDoorOpen = _realMainDoor;
        });
        
        // Mostrar alerta si la puerta se abrió
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
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(gradient: AppTheme.heroGradient),
        ),
        SafeArea(
          child: CustomScrollView(
            slivers: [
              // Banner Hero
              SliverToBoxAdapter(
                child: HeroBanner(
                  title: t('control_home', widget.locale),
                  subtitle: t('subtitle_home', widget.locale),
                  locale: widget.locale,
                ),
              ),
              
              // SECCIÓN: MONITOREO EN VIVO
              _buildSectionTitle('Cámara y Sensores', theme),
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
                    // Cámara de seguridad
                    ControlCard(
                      title: t('security_camera', widget.locale),
                      icon: Icons.videocam_rounded,
                      isOpen: true,
                      onToggle: _navigateToCamera,
                      typeLabel: 'Streaming',
                      activeColor: Colors.blue,
                      locale: widget.locale,
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
                    ),
                  ]),
                ),
              ),

              // Indicador de última actualización
              _buildLastUpdateIndicator(),

              // SECCIÓN: PUERTAS
              _buildSectionTitle(t('doors', widget.locale), theme),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                      onToggle: () async {
                        // Cambio visual inmediato
                        setState(() => _mainDoorOpen = !_mainDoorOpen);
                        
                        // Enviar comando (Lógica inversa: si visual es abierto -> enviar OPEN)
                        final action = _mainDoorOpen ? 'OPEN' : 'CLOSE';
                        final success = await ControlService.sendCommand('puerta', action);

                        if (!success && mounted) {
                           setState(() => _mainDoorOpen = !_mainDoorOpen); // Revertir
                           ScaffoldMessenger.of(context).showSnackBar(
                             const SnackBar(content: Text('Error al controlar la puerta')),
                           );
                        }
                      },
                      typeLabel: _realMainDoor ? 
                        '${t('open', widget.locale)} (${t('sensor', widget.locale)})' : 
                        '${t('closed', widget.locale)} (${t('sensor', widget.locale)})',
                      activeColor: _mainDoorOpen ? theme.colorScheme.primary : Colors.grey,
                      locale: widget.locale,
                    ),
                  ]),
                ),
              ),

              // SECCIÓN: EXTERIORES (Portón y Luces)
              _buildSectionTitle('Exteriores', theme),
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
                    // 1. TARJETA PORTÓN
                    ControlCard(
                      title: 'Portón', // O usa t('gate', widget.locale)
                      icon: Icons.fence_rounded,
                      isOpen: _gateOpen,
                      typeLabel: 'Acceso',
                      activeColor: Colors.green,
                      locale: widget.locale,
                      onToggle: () async {
                        setState(() => _gateOpen = !_gateOpen);
                        final action = _gateOpen ? 'OPEN' : 'CLOSE';
                        final success = await ControlService.sendCommand('porton', action);
                        if (!success && mounted) {
                          setState(() => _gateOpen = !_gateOpen);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Error al conectar con el portón'), backgroundColor: Colors.red),
                          );
                        }
                      },
                    ),
                    
                    // 2. ✅ NUEVA TARJETA: LUZ PATIO
                    ControlCard(
                      title: 'Luz Patio',
                      icon: Icons.lightbulb_rounded,
                      isOpen: _luzEncendida,
                      typeLabel: 'RGB',
                      activeColor: Colors.orange,
                      locale: widget.locale,
                      onToggle: () async {
                        setState(() => _luzEncendida = !_luzEncendida);
                        final action = _luzEncendida ? 'ON' : 'OFF';
                        final success = await ControlService.sendCommand('luz', action);
                        if (!success && mounted) {
                          setState(() => _luzEncendida = !_luzEncendida);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Error al controlar luz'), backgroundColor: Colors.red),
                          );
                        }
                      },
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

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
      sliver: SliverToBoxAdapter(
        child: Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildLastUpdateIndicator() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.update_rounded,
              size: 16,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 8),
            Text(
              '${t('last_update', widget.locale)}: ${_formatLastUpdate()}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
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
        title: const Text('NeuroHome'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              _sensorsConnected ? Icons.sensors_rounded : Icons.sensors_off_rounded,
              color: _sensorsConnected ? Colors.green : Colors.grey,
            ),
            tooltip: _sensorsConnected ? 
              '${t('sensors_connected', widget.locale)}' : 
              '${t('sensors_disconnected', widget.locale)}',
            onPressed: _refreshSensorData,
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
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