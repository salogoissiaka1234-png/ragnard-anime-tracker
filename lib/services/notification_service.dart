import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tzdata.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(settings);
  }

  // Planifie un rappel hebdomadaire le jour de diffusion d'un anime suivi
  Future<void> scheduleWeeklyReminder({
    required int id,
    required String animeTitle,
    required int weekday, // 1 = lundi ... 7 = dimanche
    required int hour,
    required int minute,
  }) async {
    await _plugin.zonedSchedule(
      id,
      'Nouvel épisode disponible !',
      '$animeTitle sort un nouvel épisode aujourd\'hui 🎬',
      _nextInstanceOfWeekday(weekday, hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'anime_reminders',
          'Rappels anime',
          channelDescription: 'Rappels de sortie d\'épisodes',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  Future<void> cancelReminder(int id) async {
    await _plugin.cancel(id);
  }

  tz.TZDateTime _nextInstanceOfWeekday(int weekday, int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, hour, minute);

    while (scheduled.weekday != weekday || scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
