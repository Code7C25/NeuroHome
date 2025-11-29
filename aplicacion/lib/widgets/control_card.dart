import 'package:flutter/material.dart';
import '../localization.dart';
import '../app_theme.dart'; // ← AGREGAR ESTE IMPORT

class ControlCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isOpen;
  final VoidCallback onToggle;
  final String typeLabel;
  final Color? activeColor;
  final String locale;
  final bool? isDark; // ← NUEVO PARÁMETRO OPCIONAL

  const ControlCard({
    super.key,
    required this.title,
    required this.icon,
    required this.isOpen,
    required this.onToggle,
    required this.typeLabel,
    this.activeColor,
    required this.locale,
    this.isDark, // ← NUEVO PARÁMETRO
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool darkMode = isDark ?? (theme.brightness == Brightness.dark);
    
    final Color color = isOpen
        ? (activeColor ?? theme.colorScheme.primary)
        : (darkMode ? Colors.grey.shade600 : Colors.grey.shade400);
    
    final Color cardColor = darkMode ? AppTheme.darkCard : Colors.white;
    final Color textColor = darkMode ? AppTheme.darkTextPrimary : Colors.grey[800]!;
    final Color secondaryTextColor = darkMode ? AppTheme.darkTextSecondary : Colors.grey[600]!;

    return Card(
      elevation: 8, // ← MEJOR ELEVACIÓN
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: cardColor, // ← COLOR DINÁMICO
      shadowColor: darkMode ? Colors.black.withOpacity(0.3) : Colors.grey.withOpacity(0.2),
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ICONO CON FONDO MEJORADO
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isOpen 
                      ? color.withOpacity(0.15)
                      : (darkMode ? AppTheme.darkSurface.withOpacity(0.5) : Colors.grey.shade100),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon, 
                  size: 32, // ← TAMAÑO AJUSTADO
                  color: color,
                ),
              ),
              const SizedBox(height: 16), // ← MÁS ESPACIO
              
              // TÍTULO
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: textColor, // ← COLOR DINÁMICO
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              
              // ESTADO (ABIERTO/CERRADO)
              Text(
                isOpen ? t('open', locale) : t('closed', locale),
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              
              // TIPO (LABEL)
              Text(
                typeLabel,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: secondaryTextColor, // ← COLOR DINÁMICO
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}