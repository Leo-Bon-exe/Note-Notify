import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:not_uygulamasi/models/note_model.dart';
import 'package:not_uygulamasi/providers/note_list_manager.dart';

final noteListProvider =
    StateNotifierProvider<NoteListManager, List<Note>>((ref) {

  return NoteListManager([
    
    if (box.isEmpty == false)
      for (int i = 0; i < box.length; i++) box.getAt(i) as Note
  ]);
});



StateProvider<bool> checkBox = StateProvider<bool>((ref) {
  return false;
});

StateProvider<bool> isPinned = StateProvider<bool>((ref) {
  return false;
});

StateProvider<DateTime> alarmDateTime = StateProvider<DateTime>((ref) {
  return DateTime.now();
});




