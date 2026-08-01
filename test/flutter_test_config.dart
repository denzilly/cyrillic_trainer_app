import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

/// Runs before every test file in this directory tree. Gives
/// SharedPreferences an in-memory backing so code that reads/writes
/// preferences (sound toggle, word list category selection) works in
/// widget tests without a real platform channel.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  SharedPreferences.setMockInitialValues({});
  await testMain();
}
