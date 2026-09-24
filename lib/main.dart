import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'screens/main_screen.dart';

import 'controllers/shift_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NurseLogApp());
}

class NurseLogApp extends StatefulWidget {
  const NurseLogApp({super.key});

  @override
  State<NurseLogApp> createState() => _NurseLogAppState();
}

class _NurseLogAppState extends State<NurseLogApp> {
  late final ShiftController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ShiftController();
    _controller.addListener(_onStateChange);
  }

  @override
  void dispose() {
    _controller.removeListener(_onStateChange);
    _controller.dispose();
    super.dispose();
  }

  void _onStateChange() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );

    return MaterialApp(
      title: 'NurseLog',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      home: MainScreen(controller: _controller),
    );
  }
}
