import 'package:cloud_firestore/cloud_firestore.dart';

enum SessionStatus { pending, finished, missed }

class Session {
  String id;
  Timestamp date;
  SessionStatus status;
  int duration;
  double temperature;
  DocumentReference? userId;
  String? question;
  List<dynamic>? history = [];

  Session({
    required this.id,
    required this.date,
    required this.status,
    required this.duration,
    required this.temperature,
    this.question = '',
    this.userId,
    this.history ,
  });

  @override
  String toString() {
    return 'Session{id: $id, date: $date, status: $status, duration: $duration, temperature: $temperature, userId: $userId}';
  }


static List<Session> generateTherapySessions({
  required int painLevel, // 0 a 4 según el mapa de _painLevels
  required int frequencyLevel, // 0 a 4 según el mapa de _frequencyLevels
  DateTime? startDate,
}) {
  // Mapa de configuración de dolor (temperatura, duración, etc.)

  final Map<int, Map<String, dynamic>> therapyConfig = {
    0: { // Muy leve (muy frío)
      "temperatureRange": [28.0, 30.0],
      "duration": _getFrequencyMinutes(frequencyLevel), // minutos
      "sessions": 1,
      "restDays": 2,
    },
    1: { // Leve
      "temperatureRange": [31.0, 32.0],
      "duration": _getFrequencyMinutes(frequencyLevel), // minutos
      "sessions": 4,
      "restDays": 1,
    },
    2: { // Moderado
      "temperatureRange": [33.0, 35.0],
      "duration": _getFrequencyMinutes(frequencyLevel), // minutos
      "sessions": 1,
      "restDays": 1,
    },
    3: { // Fuerte
      "temperatureRange": [35.0, 38.0],
      "duration": _getFrequencyMinutes(frequencyLevel), // minutos
      "sessions": 1,
      "restDays": 1,
    },
    4: { // Muy fuerte
      "temperatureRange": [38.0, 40.0],
      "duration": _getFrequencyMinutes(frequencyLevel), // minutos
      "sessions": 1,
      "restDays": 1,
    },
  };

  // Obtener la configuración del nivel de dolor
  final config = therapyConfig[painLevel]!;

  // Rango de temperatura según el nivel de dolor
  final double minTemp = config["temperatureRange"][0];
  final double maxTemp = config["temperatureRange"][1];
  final int duration = config["duration"];
  final int numSessions = config["sessions"];
  final int restDays = config["restDays"];

  // Fecha de inicio
  DateTime currentDate = startDate ?? DateTime.now();
  List<Session> sessions = [];

  // Generar las sesiones diarias
  for (int i = 0; i < numSessions; i++) {
    sessions.add(
      Session(
        id: 'session_${currentDate.millisecondsSinceEpoch}',
        date: Timestamp.fromDate(currentDate),
        status: SessionStatus.pending,
        duration: duration * 60,
        history: [_randomInRange(minTemp, maxTemp)],
        temperature: _randomInRange(minTemp, maxTemp),
      ),
    );
    // Incrementar un día para la próxima sesión
    currentDate = currentDate.add(const Duration(days: 1));
  }

  // Agregar días de descanso entre series
  currentDate = currentDate.add(Duration(days: restDays));

  return sessions;
}

// Función para calcular el intervalo de frecuencia basado en el valor seleccionado
static int  _getFrequencyMinutes(int frequencyLevel) {
  switch (frequencyLevel) {
    case 0:
      return 0; // Nunca
    case 1:
      return 5; // Rara vez
    case 2:
      return 10; // De vez en cuando
    case 3:
      return 20; // A menudo
    case 4:
      return 25; // Todo el tiempo
    default:
      return 15; // Valor por defecto
  }
}

// Función auxiliar para generar valores aleatorios dentro de un rango
static double _randomInRange(double min, double max) {
  return min + (max - min) * (DateTime.now().millisecondsSinceEpoch % 100 / 100.0);
}
}
