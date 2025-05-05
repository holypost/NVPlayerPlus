import 'dart:async';

import 'package:flutter/services.dart';

const MethodChannel _channel = MethodChannel('wakelock_windows');

class WakelockWindows {
  static final WakelockWindows _instance = WakelockWindows._internal();

  factory WakelockWindows() {
    return _instance;
  }

  WakelockWindows._internal();

  Future<void> enable() async {
    // 空实现，仅为了满足接口要求
    await _channel.invokeMethod('enable');
    return;
  }

  Future<void> disable() async {
    // 空实现，仅为了满足接口要求
    await _channel.invokeMethod('disable');
    return;
  }

  Future<bool> get isEnabled async {
    // 假设始终未启用
    return false;
  }
} 