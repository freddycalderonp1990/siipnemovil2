part of 'notifications_bloc.dart';

sealed class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object> get props => [];
}

class NotificationStatusChanged extends NotificationsEvent {
  final NotificationPermissionStatus status;

  const NotificationStatusChanged(this.status);

  @override
  List<Object> get props => [status];
}
