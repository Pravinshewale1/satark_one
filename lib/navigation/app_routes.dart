import 'package:flutter/material.dart';
import '../screens/dashboard_screen.dart';
import '../screens/scam_check_screen.dart';
import '../screens/report_scam_screen.dart';
import '../screens/alerts_screen.dart';
import '../screens/settings_screen.dart';

class AppRoutes {
  static const String dashboard = '/';
  static const String check = '/check';
  static const String report = '/report';
  static const String alerts = '/alerts';
  static const String settings = '/settings';

  static Map<String, WidgetBuilder> routes = {
    dashboard: (context) => const DashboardScreen(),
    check: (context) => const ScamCheckScreen(),
    report: (context) => const ReportScamScreen(),
    alerts: (context) => const AlertsScreen(),
    settings: (context) => const SettingsScreen(),
  };
}
