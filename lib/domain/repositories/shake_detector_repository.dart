abstract class ShakeDetectorRepository {
  void startListening(Function() onPhoneShake);
  void pausedListening();
  void resumeListening();
  void stopListening();
}
