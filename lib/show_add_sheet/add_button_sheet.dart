import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ndialog/ndialog.dart';
import 'package:not_uygulamasi/notifications/notifications.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../widgets/appbar_widgets.dart';

import '../providers/all_providers.dart';

TextEditingController textController = TextEditingController();

void showAddTaskBottomSheet(BuildContext context, WidgetRef ref, showInterAd) {
  NDialog(
    dialogStyle:
        DialogStyle(backgroundColor: const Color.fromARGB(255, 46, 46, 58)),
    actions: <Widget>[
      Container(
        height: 50.h,
        width: 100.w,
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ListTile(
              title: TextFormField(
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(255, 197, 194, 194),
                  ),
                  controller: textController,
                  autofocus: true,
                  maxLines: 8,
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [TaskCheckBox(), DateTimePicker()],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    child: const Text("cancel").tr(),
                    onPressed: () => Navigator.pop(context)),
                TextButton(
                  child: const Text("done").tr(),
                  onPressed: () {
                    // showInterAd();
                    String uid = UniqueKey().hashCode.toString();
                    ref.read(noteListProvider.notifier).addNote(
                        textController.text,
                        ref.watch(checkBox),
                        ref.watch(isPinned),
                        ref.watch(alarmDateTime),
                        uid);
                    ref.read(noteListProvider.notifier).pin();
                    if (ref.watch(checkBox)) {
                      createNoteReminderNotification(
                          ref.watch(alarmDateTime), uid, textController.text);
                    }
                    print(alarmDateTime);
                    ref.read(neSecili.notifier).state = "";
                    textController.clear();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  ).show(context, dismissable: false);
}

class TaskCheckBox extends ConsumerStatefulWidget {
  const TaskCheckBox({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TaskCheckBoxState();
}

class _TaskCheckBoxState extends ConsumerState<TaskCheckBox> {
  @override
  Widget build(BuildContext context) {
    return CupertinoSwitch(
        value: ref.watch(checkBox),
        onChanged: (value) {
          ref.read(checkBox.notifier).state = value;
          debugPrint(ref.read(checkBox).toString());
        });
  }
}

class DateTimePicker extends ConsumerStatefulWidget {
  const DateTimePicker({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DateTimePicker();
}

class _DateTimePicker extends ConsumerState<DateTimePicker> {
  @override
  Widget build(BuildContext context) {
    if (ref.watch(checkBox) == true) {
      return ElevatedButton(
          onPressed: () {
            picker.DatePicker.showTimePicker(
              context,
              showSecondsColumn: false,
              onConfirm: (time) {
                ref.read(alarmDateTime.notifier).state = time;
              },
            );
          },
          child: Title(
              color: Colors.red,
              child: Text(
                  "${ref.watch(alarmDateTime).hour.toString().padLeft(2, "0")}:${ref.watch(alarmDateTime).minute.toString().padLeft(2, "0")}")));
    } else {
      return const Icon(Icons.alarm_add);
    }
  }
}
