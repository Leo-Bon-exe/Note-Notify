import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:not_uygulamasi/models/note_model.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';


var deletedBox = Hive.box<Note>('deleted_notes');


final deletednoteListProvider =
    StateNotifierProvider<DeletedNoteListManager, List<Note>>((ref) {
  return DeletedNoteListManager([
    if (deletedBox.isEmpty == false)
      for (int i = 0; i < deletedBox.length; i++) deletedBox.getAt(i) as Note
  ]);
});

class DeletedNoteListManager extends StateNotifier<List<Note>> {
  DeletedNoteListManager([List<Note>? initialNotes])
      : super(initialNotes ?? []);

  void storeDeletedNote(Note note) {
    
    state = [note, ...state];
    deletedBox.clear();
    deletedBox.addAll(state);
  }

  void removeDeleted(String id) {
   
    state = state.where((element) => element.id != id).toList();
    deletedBox.clear();
    deletedBox.addAll(state);
  }
}
