import 'dart:convert';

// For Cloud Notifications

class TextNotification {
    String title;
    String screenType;
    int notificationId;
    DateTime sentAt;

    TextNotification({
        required this.title,
        required this.screenType,
        required this.notificationId,
        required this.sentAt,
    });

    factory TextNotification.fromJson(Map<String, dynamic> json) => TextNotification(
        title: json["title"],
        screenType: json["screen"],
        notificationId: json["id"] is String ? int.parse(json["id"]) : 0,
        sentAt: DateTime.parse(json["sent_at"]),
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "screen": screenType,
        "id": notificationId,
        "sent_at": sentAt.toIso8601String(),
    };
}

