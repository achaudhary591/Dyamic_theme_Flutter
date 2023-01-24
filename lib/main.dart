import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ThemeData _themeData = ThemeData();
  SharedPreferences? _prefs;


  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _themeData,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Dynamic Theme'),
        ),
        body: Column(
          children: <Widget>[
            Text('Current theme: ${_themeData.brightness}'),
            ElevatedButton(
              onPressed: () {
                _changeTheme(ThemeData.light());
              },
              child: Text('Change to light theme'),
            ),
            ElevatedButton(
              onPressed: () {
                _changeTheme(ThemeData.dark());
              },
              child: Text('Change to dark theme'),
            ),
            ElevatedButton(
              onPressed: () {
                Brightness deviceBrightness =
                    MediaQuery.of(context).platformBrightness;
                _changeTheme(deviceBrightness == Brightness.light
                    ? ThemeData.light()
                    : ThemeData.dark());
                _prefs!.setString(
                    'theme',
                    deviceBrightness == Brightness.light
                        ? ThemeMode.light.toString()
                        : ThemeMode.dark.toString());
              },
              child: Text('Change to device theme'),
            ),
          ],
        ),
      ),
    );
  }

  void _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    String? theme = _prefs!.getString('theme');
    if (theme == null) {
      Brightness deviceBrightness = MediaQuery.of(context).platformBrightness;
      theme = deviceBrightness == Brightness.light
          ? ThemeMode.light.toString()
          : ThemeMode.dark.toString();
      _prefs!.setString('theme', theme);
    }
    if (theme == ThemeMode.light.toString()) {
      _themeData = ThemeData.light();
    } else if (theme == ThemeMode.dark.toString()) {
      _themeData = ThemeData.dark();
    }
    setState(() {});
  }

  void _changeTheme(ThemeData theme) {
    setState(() {
      _themeData = theme;
    });
    _prefs!.setString(
        'theme',
        theme == ThemeData.light()
            ? ThemeMode.light.toString()
            : ThemeMode.dark.toString());
  }
}
