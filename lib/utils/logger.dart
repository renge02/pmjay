import 'dart:developer';

import 'package:flutter/foundation.dart';

logger(String message, {DateTime? dateTime, StackTrace? stackTrace}) {
  if (kDebugMode && !kReleaseMode) {
    log(message, time: dateTime ?? DateTime.now(), stackTrace: stackTrace);
  }
}
