abstract class PreferencesRepository {
  Future<void> saveIncodeInterviewId(String? interviewId);

  Future<String?> get incodeInterviewId;
}
