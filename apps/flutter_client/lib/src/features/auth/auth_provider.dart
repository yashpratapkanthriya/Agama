import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfile {
  final String name;
  final String email;
  final bool isGuest;
  final bool isSyncEnabled;
  final int streakDays;

  const UserProfile({
    this.name = 'Guest Reader',
    this.email = 'guest@agama.local',
    this.isGuest = true,
    this.isSyncEnabled = false,
    this.streakDays = 5,
  });

  UserProfile copyWith({
    String? name,
    String? email,
    bool? isGuest,
    bool? isSyncEnabled,
    int? streakDays,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      isGuest: isGuest ?? this.isGuest,
      isSyncEnabled: isSyncEnabled ?? this.isSyncEnabled,
      streakDays: streakDays ?? this.streakDays,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfile &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          email == other.email &&
          isGuest == other.isGuest &&
          isSyncEnabled == other.isSyncEnabled &&
          streakDays == other.streakDays;

  @override
  int get hashCode => Object.hash(name, email, isGuest, isSyncEnabled, streakDays);
}

class AuthNotifier extends StateNotifier<UserProfile> {
  AuthNotifier([UserProfile? initialProfile])
      : super(initialProfile ?? const UserProfile());

  void toggleSync() {
    state = state.copyWith(isSyncEnabled: !state.isSyncEnabled);
  }

  void setSyncEnabled(bool enabled) {
    state = state.copyWith(isSyncEnabled: enabled);
  }

  void updateProfile({String? name, String? email, bool? isGuest, int? streakDays}) {
    state = state.copyWith(
      name: name,
      email: email,
      isGuest: isGuest,
      streakDays: streakDays,
    );
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, UserProfile>((ref) {
  return AuthNotifier();
});
