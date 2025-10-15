import 'package:flutter/material.dart';
import '../localization.dart';

class DeviceConnectionScreen extends StatelessWidget {
  final String locale;
  const DeviceConnectionScreen({super.key, required this.locale});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t('device_connection_title', locale)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t('device_connection_subtitle', locale),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 18),
            Text(t('device_connection_desc', locale)),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt_rounded),
              label: Text(t('add_camera', locale)),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(t('coming_soon', locale))),
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.sensors_rounded),
              label: Text(t('add_sensor', locale)),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(t('coming_soon', locale))),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}