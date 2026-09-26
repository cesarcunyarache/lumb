import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lumb/domain/entities/session.dart';

class SessionModel extends Session {
  SessionModel(
      {required super.id,
      required super.date,
      required super.status,
      required super.duration,
      required super.temperature,
      required super.userId,
      super.question,
      super.history});

  factory SessionModel.fromJson(String id, Map<String, dynamic> json) {
    return SessionModel(
      id: id,
      date: json['date'] as Timestamp,
      status: SessionStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => SessionStatus.pending,
      ),
      duration: json['duration'] as int,
      temperature: (json['temperature'] as num).toDouble(),
      userId: json['userId'] as DocumentReference,
      question: json['question'] as String,
      history: json['history'] as List<dynamic>,

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'status': status.name,
      'duration': duration,
      'temperature': temperature,
      'userId': userId,
      'question': question,
      'history': history,
    };
  }

  factory SessionModel.fromEntity(Session session) {
    return SessionModel(
      id: session.id,
      date: session.date,
      status: session.status,
      duration: session.duration,
      temperature: session.temperature,
      userId: session.userId,
      question: session.question,
      history: session.history,
    );
  }
}
