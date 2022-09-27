import 'preferences_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesRepositoryImpl implements PreferencesRepository {
  static const String _incodeInterviewId = 'incodeInterviewId';

  @override
  Future<void> saveIncodeInterviewId(String? interviewId) async {
    final prefs = await SharedPreferences.getInstance();
    if (interviewId != null) {
      await prefs.setString(_incodeInterviewId, interviewId);
    } else {
      await prefs.remove(_incodeInterviewId);
    }
  }

  @override
  Future<String?> get incodeInterviewId async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_incodeInterviewId);
    return value;
  }

}
