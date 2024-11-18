import 'package:flutter/material.dart';
import 'package:panda/providers/carrito_provider.dart';
import 'package:provider/provider.dart';
import 'pages/login_page.dart';
import 'utils/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
   Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CarritoProvider()),
        // Agrega otros providers si los tienes
      ],
      child: MaterialApp(
        title: 'Panda Delivery',
        theme: ThemeData(
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.background,
          fontFamily: 'Poppins',
        ),
        home: const LoginPage(),
      ),
    );
  }
}
