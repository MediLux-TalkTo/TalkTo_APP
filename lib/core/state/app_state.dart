import '../../features/onboarding/profile_setup_screen.dart';

class AppState {
  static List<ProfileData> profiles = const [ProfileData(name: '어머니')];

  static void setProfiles(List<ProfileData> newProfiles) {
    profiles = List<ProfileData>.from(newProfiles);
  }

  static List<ProfileData> get safeProfiles {
    if (profiles.isEmpty) {
      return const [ProfileData(name: '어머니')];
    }
    return profiles;
  }
}
