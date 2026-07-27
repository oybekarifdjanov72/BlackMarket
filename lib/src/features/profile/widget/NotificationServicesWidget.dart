import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'NotificationsModel.dart';

class AutoNotificationService {
  static const _notifKey = 'notifications';
  static final Uuid _uuid = const Uuid();

  static const Map<String, Duration> _intervals = {
    'abandoned_cart': Duration(hours: 24),
    'inactive_cart': Duration(days: 3),
    'favorites_no_purchase': Duration(days: 2),
    'active_no_purchase': Duration(days: 1),
    'cleared_cart': Duration(days: 1),
  };

  static Future<void> checkAndSendAll({
    required int cartCount,
    required int favoritesCount,
    required bool hasPurchases,
    required DateTime? lastPurchaseDate,
    required DateTime lastAppOpen,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();

    await _trySend(
      prefs: prefs,
      id: 'abandoned_cart',
      title: '🛒 Items left in cart',
      description: 'You still have items waiting in your cart',
      condition: cartCount > 0,
    );

    await _trySend(
      prefs: prefs,
      id: 'inactive_cart',
      title: '🕒 We saved your cart',
      description: 'Your items are still waiting for you',
      condition: cartCount > 0 && now.difference(lastAppOpen) >= Duration(days: 3),
    );

    await _trySend(
      prefs: prefs,
      id: 'favorites_no_purchase',
      title: '❤️ Your favorites are popular',
      description: 'Don\'t miss out on your favorite items',
      condition: favoritesCount > 0 && !hasPurchases,
    );

    await _trySend(
      prefs: prefs,
      id: 'active_no_purchase',
      title: '👀 Looking around?',
      description: 'Check out today\'s best deals',
      condition: !hasPurchases,
    );

    await _trySend(
      prefs: prefs,
      id: 'cleared_cart',
      title: '🤔 Changed your mind?',
      description: 'New deals might interest you',
      condition: cartCount == 0 && !hasPurchases,
    );
  }


  static Future<void> _trySend({
    required SharedPreferences prefs,
    required String id,
    required String title,
    required String description,
    required bool condition,
  }) async {
    if (!condition) return;

    final lastSentRaw = prefs.getString('${id}_last_sent');
    DateTime? lastSent = lastSentRaw != null ? DateTime.parse(lastSentRaw) : null;
    final now = DateTime.now();

    final interval = _intervals[id] ?? Duration(days: 1);

    if (lastSent == null || now.difference(lastSent) >= interval) {
      await _sendNotification(id: id, title: title, description: description);
      await prefs.setString('${id}_last_sent', now.toIso8601String());
    }
  }

  static Future<void> _sendNotification({
    required String id,
    required String title,
    required String description,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_notifKey) ?? [];

    final notification = AppNotification(
      id: _uuid.v4(),
      title: title,
      description: description,
      date: DateTime.now(),
      isRead: false,
    ).toJson();

    list.insert(0, jsonEncode(notification));
    await prefs.setStringList(_notifKey, list);
  }

  static Future<List<AppNotification>> getNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(_notifKey) ?? [];
    return rawList.map((e) => AppNotification.fromJson(jsonDecode(e))).toList();
  }

  static Future<void> clearAllNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_notifKey);
    for (var key in _intervals.keys) {
      await prefs.remove('${key}_last_sent');
    }
  }
}

class AppOpenTracker {
  static const _key = 'last_app_open';

  static Future<DateTime> getLastOpen() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    return raw != null ? DateTime.parse(raw) : DateTime.now();
  }

  static Future<void> saveNow() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, DateTime.now().toIso8601String());
  }
}
