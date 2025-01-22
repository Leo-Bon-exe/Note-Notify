import 'package:hive_flutter/adapters.dart';
part 'note_model.g.dart';

@HiveType(typeId: 0)
class Note {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String icerik;
  @HiveField(2)
  final DateTime timeCreated;
  @HiveField(3)
  bool alarmVarmi = false;
  @HiveField(4)
  bool isPinned = false;
  @HiveField(5)
  bool edit = false;
  @HiveField(6)
  final DateTime alarmZamani;

  Note(
      {required this.id,
      required this.edit,
      required this.icerik,
      required this.timeCreated,
      required this.isPinned,
      required this.alarmVarmi,
      required this.alarmZamani});
}
