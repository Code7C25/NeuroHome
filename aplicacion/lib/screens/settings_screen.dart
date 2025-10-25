import 'package:flutter/material.dart';
import '../localization.dart';
import 'device_connection_screen.dart';

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
                builder: (context) => DeviceConnectionScreen(locale: locale),
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