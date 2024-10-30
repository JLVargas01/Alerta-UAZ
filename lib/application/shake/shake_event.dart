abstract class ShakeEvent {}

class EnabledShake extends ShakeEvent {}

class DisabledShake extends ShakeEvent {}

class ListenShake extends ShakeEvent {
  final String status;

  ListenShake(this.status);
}
