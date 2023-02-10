class MeisoTime {
  final int timeMinutes;
  final String timeDisplayString;

//<editor-fold desc="Data Methods">

  const MeisoTime({
    required this.timeMinutes,
    required this.timeDisplayString,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MeisoTime &&
          runtimeType == other.runtimeType &&
          timeMinutes == other.timeMinutes &&
          timeDisplayString == other.timeDisplayString);

  @override
  int get hashCode => timeMinutes.hashCode ^ timeDisplayString.hashCode;

  @override
  String toString() {
    return 'MeisoTime{' +
        ' timeMinutes: $timeMinutes,' +
        ' timeDisplayString: $timeDisplayString,' +
        '}';
  }

  MeisoTime copyWith({
    int? timeMinutes,
    String? timeDisplayString,
  }) {
    return MeisoTime(
      timeMinutes: timeMinutes ?? this.timeMinutes,
      timeDisplayString: timeDisplayString ?? this.timeDisplayString,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'timeMinutes': this.timeMinutes,
      'timeDisplayString': this.timeDisplayString,
    };
  }

  factory MeisoTime.fromMap(Map<String, dynamic> map) {
    return MeisoTime(
      timeMinutes: map['timeMinutes'] as int,
      timeDisplayString: map['timeDisplayString'] as String,
    );
  }

//</editor-fold>
}