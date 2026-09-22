part of 'notifications_bloc.dart';

enum NotificationPermissionStatus {
  notDetermined,
  authorized,
  denied,
  provisional,
}

class NotificationsState extends Equatable {
  final NotificationPermissionStatus status;

  const NotificationsState({
    this.status = NotificationPermissionStatus.notDetermined,
  });

  NotificationsState copyWith({
    NotificationPermissionStatus? status,
  }) {
    return NotificationsState(
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [status];
}
