import 'dart:async';

import 'package:flutter/services.dart';

import 'wakelock_windows.dart';

class WakelockWindowsPlugin {
  static final WakelockWindows _wakelock = WakelockWindows();

  static Future<void> enable() async {
    await _wakelock.enable();
  }

  static Future<void> disable() async {
    await _wakelock.disable();
  }

  static Future<bool> get isEnabled async {
    return await _wakelock.isEnabled;
  }
} 