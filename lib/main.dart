// 這裡是app的進入點

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state_management/providers.dart';
import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: appProviders,
      child: const MyApp(),
    ),
  );
}