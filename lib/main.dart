import 'package:flutter/material.dart';
import 'package:swim_success/app/app.dart';
import 'package:swim_success/core/di/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  runApp(const SwimSuccessApp());
}
