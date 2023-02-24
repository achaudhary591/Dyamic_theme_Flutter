import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool _isDarkMode = false;
  bool _isSystemThemeEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadTheme();
    _subscribeToBrightnessChanges();
  }

  Future<void> _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isDarkMode = prefs.getBool('isDarkMode');
    if (isDarkMode == null) {
      // If the 'isDarkMode' preference is not set, use the device default theme.
      Brightness platformBrightness = WidgetsBinding.instance!.window.platformBrightness;
      isDarkMode = platformBrightness == Brightness.dark;
    }
    setState(() {
      _isDarkMode = isDarkMode!;
    });
  }

  Future<void> _toggleTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = value;
      _isSystemThemeEnabled = false; // Disable the system theme when the user manually selects a theme
      prefs.setBool('isDarkMode', value);
    });
  }

  void _subscribeToBrightnessChanges() {
    WidgetsBinding.instance!.window.onPlatformBrightnessChanged = () {
      if (_isSystemThemeEnabled) {
        Brightness platformBrightness = WidgetsBinding.instance!.window.platformBrightness;
        setState(() {
          _isDarkMode = platformBrightness == Brightness.dark;
        });
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      title: 'Dynamic Theme',
      debugShowCheckedModeBanner: false,
      theme: _isDarkMode ? ThemeData.dark(useMaterial3: true) : ThemeData.light(useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Dark/Light Theme Switcher'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Change theme using switch',
              ),
              Switch(
                value: _isDarkMode,
                onChanged: _toggleTheme,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
