class KokoroVoice {
  final String voiceId;
  final String name;
  final String language;
  final String gender;
  final String? traits;
  final String targetQuality;
  final String overallGrade;

  const KokoroVoice({
    required this.voiceId,
    required this.name,
    required this.language,
    required this.gender,
    this.traits,
    required this.targetQuality,
    required this.overallGrade,
  });
}
