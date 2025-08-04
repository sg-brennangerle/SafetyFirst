import 'package:uuid/uuid.dart';

enum ReportType { text, photo, voice }

class SafetyReport {
  final String id;
  final String reporterName;
  final String jobId;
  final String jobName;
  final String description;
  final DateTime observedAt;
  final DateTime reportedAt;
  final ReportType type;
  final String? photoPath;
  final String? voicePath;
  final String? transcribedText;
  final String? originalLanguage;
  final String? translatedText;

  SafetyReport({
    String? id,
    required this.reporterName,
    required this.jobId,
    required this.jobName,
    required this.description,
    required this.observedAt,
    required this.reportedAt,
    required this.type,
    this.photoPath,
    this.voicePath,
    this.transcribedText,
    this.originalLanguage,
    this.translatedText,
  }) : id = id ?? const Uuid().v4();

  factory SafetyReport.fromJson(Map<String, dynamic> json) {
    return SafetyReport(
      id: json['id'] as String,
      reporterName: json['reporterName'] as String,
      jobId: json['jobId'] as String,
      jobName: json['jobName'] as String,
      description: json['description'] as String,
      observedAt: DateTime.parse(json['observedAt'] as String),
      reportedAt: DateTime.parse(json['reportedAt'] as String),
      type: ReportType.values.firstWhere(
        (e) => e.toString() == 'ReportType.${json['type']}',
      ),
      photoPath: json['photoPath'] as String?,
      voicePath: json['voicePath'] as String?,
      transcribedText: json['transcribedText'] as String?,
      originalLanguage: json['originalLanguage'] as String?,
      translatedText: json['translatedText'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reporterName': reporterName,
      'jobId': jobId,
      'jobName': jobName,
      'description': description,
      'observedAt': observedAt.toIso8601String(),
      'reportedAt': reportedAt.toIso8601String(),
      'type': type.toString().split('.').last,
      'photoPath': photoPath,
      'voicePath': voicePath,
      'transcribedText': transcribedText,
      'originalLanguage': originalLanguage,
      'translatedText': translatedText,
    };
  }

  SafetyReport copyWith({
    String? id,
    String? reporterName,
    String? jobId,
    String? jobName,
    String? description,
    DateTime? observedAt,
    DateTime? reportedAt,
    ReportType? type,
    String? photoPath,
    String? voicePath,
    String? transcribedText,
    String? originalLanguage,
    String? translatedText,
  }) {
    return SafetyReport(
      id: id ?? this.id,
      reporterName: reporterName ?? this.reporterName,
      jobId: jobId ?? this.jobId,
      jobName: jobName ?? this.jobName,
      description: description ?? this.description,
      observedAt: observedAt ?? this.observedAt,
      reportedAt: reportedAt ?? this.reportedAt,
      type: type ?? this.type,
      photoPath: photoPath ?? this.photoPath,
      voicePath: voicePath ?? this.voicePath,
      transcribedText: transcribedText ?? this.transcribedText,
      originalLanguage: originalLanguage ?? this.originalLanguage,
      translatedText: translatedText ?? this.translatedText,
    );
  }
} 