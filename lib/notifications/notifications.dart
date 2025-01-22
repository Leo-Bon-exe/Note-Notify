import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:easy_localization/easy_localization.dart';

Future<void> createNoteReminderNotification(
    DateTime notificationSchedule, String uid, String icerik) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: int.parse(uid),
      channelKey: 'scheduled_channel',
      title: Emojis.shape_red_circle + ('notify').tr(),
      body: icerik,
      notificationLayout: NotificationLayout.BigText,
      fullScreenIntent: false,
      category: NotificationCategory.Reminder,
      wakeUpScreen: true,
    ),
    schedule: NotificationCalendar(
      hour: notificationSchedule.hour,
      minute: notificationSchedule.minute,
      second: 0,
      millisecond: 0,
      repeats: true,
    ),
  );
}

Future<void> cancelScheduledNotifications(String uid) async {
  await AwesomeNotifications().cancel(int.parse(uid));
}
