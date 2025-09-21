import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/express_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const ExpressWidgetApp());
}

class ExpressWidgetApp extends StatelessWidget {
  const ExpressWidgetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ExpressProvider(),
      child: MaterialApp(
        title: '快递取件码助手',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            elevation: 2,
          ),
        ),
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}