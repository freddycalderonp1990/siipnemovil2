import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';

/// Deduplica entregas del mismo mensaje, no futuras alertas del mismo registro.
String operativoPushIdentity(RemoteMessage message) {
  final String messageId = message.messageId?.trim() ?? '';
  if (messageId.isNotEmpty) return 'fcm:$messageId';

  final keys = message.data.keys.toList()..sort();
  final data = <String, dynamic>{
    for (final key in keys) key: message.data[key],
  };
  return jsonEncode(<Object?>[
    message.sentTime?.millisecondsSinceEpoch,
    data,
    message.notification?.title,
    message.notification?.body,
  ]);
}
