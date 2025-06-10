import 'package:flutter/material.dart';

/// Константы приложения, такие как цвета, строки и т.д.
class AppConstants {
  static const String appName = 'Simple Calendar';
  
  // Цвета Material Design
  static const Color primaryColor = Color(0xFF6200EE);
  static const Color primaryVariantColor = Color(0xFF3700B3);
  static const Color secondaryColor = Color(0xFF03DAC6);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  
  // Ключи для локального хранилища
  static const String eventsKey = 'calendar_events';
}