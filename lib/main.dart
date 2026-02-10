import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './data_provider.dart';
import './screens/signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize DataProvider
  final dataProvider = DataProvider();
  await dataProvider.initializeData();
  await dataProvider.initializeSampleData();

  runApp(MyApp(dataProvider: dataProvider));
}

class MyApp extends StatelessWidget {
  final DataProvider dataProvider;

  const MyApp({super.key, required this.dataProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: dataProvider)],
      child: MaterialApp(
        title: 'Student Academic Platform',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A2C5A)),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1A2C5A),
            elevation: 0,
          ),
        ),
        home: const SignUpScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
