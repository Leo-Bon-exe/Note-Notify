import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:not_uygulamasi/models/note_model.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';


var box = Hive.box<Note>('notes');


class NoteListManager extends StateNotifier<List<Note>> {
 
  NoteListManager([List<Note>? initialNotes]) : super(initialNotes ?? []);

  void addNote(String icerik, bool alarmVarmi, bool isPinned,
      DateTime alarmZamani, String uid) {
    state = [
      Note(
          id: uid,
          alarmVarmi: alarmVarmi,
          isPinned: isPinned,
          alarmZamani: alarmZamani,
          icerik: icerik,
          edit: false,
          timeCreated: DateTime.now()),
      ...state
    ];
 
    box.clear();
    box.addAll(state);
  }

  void addDeletedNote(Note note) {

    state = [note, ...state];

    box.clear();
    box.addAll(state);
  }

  void search(String text) {
    state = [
      for (var note in state)
        if (note.icerik.toLowerCase().contains(text.toLowerCase())) note,
      for (var note in state)
        if (note.icerik.toLowerCase().contains(text.toLowerCase()) == false)
          note
    ];
    box.clear();
    box.addAll(state);
  }

  void pin() {
    state = [
      for (var note in state)
        if (note.isPinned) note,
      for (var note in state)
        if (!note.isPinned) note
    ];
    box.clear();
    box.addAll(state);
  }

  void latest() {
    state.sort((a, b) => b.timeCreated.compareTo(a.timeCreated));
  }

  void oldest() {
    state.sort((a, b) => a.timeCreated.compareTo(b.timeCreated));
  }

  void alarmToggle(String id, bool alarm) {
    state = [
      for (var note in state)
        if (note.id == id)
          Note(
              id: note.id,
              icerik: note.icerik,
              timeCreated: note.timeCreated,
              alarmVarmi: alarm,
              isPinned: note.isPinned,
              edit: note.edit,
              alarmZamani: note.alarmZamani)
        else
          note
    ];
    box.clear();
    box.addAll(state);
  }

  void pinned(String id) {
    state = [
      for (var note in state)
        if (note.id == id)
          Note(
              id: note.id,
              icerik: note.icerik,
              timeCreated: note.timeCreated,
              alarmVarmi: note.alarmVarmi,
              isPinned: !note.isPinned,
              edit: note.edit,
              alarmZamani: note.alarmZamani)
        else
          note
    ];
    box.clear();
    box.addAll(state);
  }

  void changeAlarm(String id, DateTime date) {
    state = [
      for (var note in state)
        if (note.id == id)
          Note(
              id: note.id,
              icerik: note.icerik,
              timeCreated: note.timeCreated,
              alarmVarmi: note.alarmVarmi,
              edit: note.edit,
              isPinned: note.isPinned,
              alarmZamani: date)
        else
          note
    ];
    box.clear();
    box.addAll(state);
  }

  void editToggle(String id) {
    state = [
      for (var note in state)
        if (note.id == id)
          Note(
              id: note.id,
              icerik: note.icerik,
              timeCreated: note.timeCreated,
              alarmVarmi: note.alarmVarmi,
              isPinned: note.isPinned,
              edit: !note.edit,
              alarmZamani: note.alarmZamani)
        else
          note
    ];
    box.clear();
    box.addAll(state);
  }

  void edit(String id, String newDescription, bool alarm, DateTime zaman) {
    state = [
      for (var note in state)
        if (note.id == id)
          Note(
              id: note.id,
              icerik: newDescription,
              timeCreated: note.timeCreated,
              alarmVarmi: alarm,
              edit: note.edit,
              isPinned: note.isPinned,
              alarmZamani: zaman)
        else
          note
    ];
    box.clear();
    box.addAll(state);
  }

  void remove(String id) {
    state = state.where((element) => element.id != id).toList();
    box.clear();
    box.addAll(state);
  }
}
