// lib/src/shared/services/notification_service.dart

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitflow/src/features/habits/domain/habit_model.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/foundation.dart';


class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // 1. Initialize timezone database
    tz.initializeTimeZones();

    // 2. Setup initialization settings for Android and iOS
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon'); // Ensure you have drawable/app_icon.png

    final DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    
    // 3. Initialize the plugin
    await _notificationsPlugin.initialize(initializationSettings);
  }

  void onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) {
    // Handle notification tapped while app is in the foreground for older iOS versions
    print('id $id');
  }

  Future<void> requestPermissions() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await _notificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      await _notificationsPlugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    }
  }

  // Helper function to calculate the next scheduled time
  tz.TZDateTime _nextInstanceOfTime(int day, {int hour = 8, int minute = 0}) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    
    // Day mapping: 1=Monday...7=Sunday for plugin, matches our model
    while (scheduledDate.weekday != day) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    // If the scheduled date is in the past for today, schedule it for the next week.
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 7));
    }
    return scheduledDate;
  }

  Future<void> scheduleHabitNotification(Habit habit) async {
    // Assuming a default time for now, e.g., 8:00 AM.
    // You would fetch this from the habit's 'schedule' field in a real implementation.
    const int notificationHour = 8;
    
    for (int day in habit.weekdays) {
      await _notificationsPlugin.zonedSchedule(
        // Use a unique ID derived from habit ID and day
        // This allows cancelling/updating notifications for a specific habit on a specific day
        habit.id.hashCode + day,
        'Habit Reminder',
        'Time for: ${habit.title}',
        _nextInstanceOfTime(day, hour: notificationHour),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'habit_channel_id',
            'Habit Reminders',
            channelDescription: 'Notifications for habit reminders',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime, // This makes it repeat weekly
      );
    }
  }

  Future<void> cancelHabitNotifications(Habit habit) async {
    for (int day in habit.weekdays) {
      await _notificationsPlugin.cancel(habit.id.hashCode + day);
    }
  }
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});