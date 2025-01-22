import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
 import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ndialog/ndialog.dart';
import 'package:not_uygulamasi/notifications/notifications.dart';
import 'package:not_uygulamasi/providers/deleted_manager.dart';

import 'package:not_uygulamasi/widgets/appbar_widgets.dart';
import 'package:not_uygulamasi/widgets/sol_menu_bar.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import '../providers/all_providers.dart';


const int maxFailedLoadAttemps = 7;

StreamController<int> streamController = StreamController<int>.broadcast();

TextEditingController textItemController = TextEditingController();

class NoteItem extends ConsumerStatefulWidget {
  const NoteItem({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NoteItemState();
}

class _NoteItemState extends ConsumerState<NoteItem> {
  @override
  Widget build(BuildContext context) {
    return ViewBuilder(streamController.stream);
  }
}

class ViewBuilder extends ConsumerStatefulWidget {
  const ViewBuilder(this.stream, {Key? key}) : super(key: key);
  final Stream<int> stream;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ViewBuilderState();
}

class _ViewBuilderState extends ConsumerState<ViewBuilder> {
  @override
  void initState() {
    super.initState();

    widget.stream.listen((index) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    textItemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          itemBuilder: (context, index) {
            return Dismissible(
                direction: DismissDirection.startToEnd,
                background: const Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Icon(Icons.delete),
                      Icon(Icons.arrow_right_alt_sharp)
                    ],
                  ),
                ),
                key: Key(ref.watch(noteListProvider)[index].id),
                onDismissed: (direction) {
                  cancelScheduledNotifications(
                      ref.watch(noteListProvider)[index].id);
                  ref
                      .read(deletednoteListProvider.notifier)
                      .storeDeletedNote(ref.watch(noteListProvider)[index]);
                  ref
                      .read(noteListProvider.notifier)
                      .remove(ref.watch(noteListProvider)[index].id);
                },
                child: ListItem(index));
          },
          itemCount: ref.watch(noteListProvider).length),
    );
  }
}

class ListItem extends ConsumerStatefulWidget {
  final int index;
  const ListItem(this.index, {Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ListItemState();
}

class _ListItemState extends ConsumerState<ListItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 1,bottom: 1),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 0.6.w),
        child: ExpansionTileCard(
          
          initialElevation: 3,
          baseColor: Colors.white.withOpacity(0.8),
          elevation: 3,
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AlarmIcon(widget.index),
              PinSwitch(widget.index),
            ],
          ),
          title:
              Text(ref.watch(noteListProvider)[widget.index].icerik, maxLines: 3),
          children: [
            const Divider(
              thickness: 5.0,
              height: 1.0,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 1.w)),
            ),
            Row(
              children: [
                 SizedBox(
                  width: 3.w,
                ),
                BigScreenShow(widget.index),
                SizedBox(
                  width: 3.w,
                ),
                CopyMethodIcon(widget.index),
                SizedBox(
                  width: 66.w,
                ),
                EditIcon(widget.index),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CopyMethodIcon extends ConsumerStatefulWidget {
  final int index;
  const CopyMethodIcon(this.index, {Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CopyMethodIconState();
}

class _CopyMethodIconState extends ConsumerState<CopyMethodIcon> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: const Icon(Icons.copy_outlined),
      onTap: () async {
        await Clipboard.setData(ClipboardData(
                text: ref.watch(noteListProvider)[widget.index].icerik))
            .then((_) => {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      duration: Duration(seconds: 2),
                      content: Text("Copied to clipboard !")))
                });
      },
    );
  }
}

class BigScreenShow extends ConsumerStatefulWidget {
  final int index;
  const BigScreenShow(this.index, {Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BigScreenShowState();
}

class _BigScreenShowState extends ConsumerState<BigScreenShow> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: const Icon(Icons.fullscreen_rounded, size: 30),
      onTap: () {
        bigScreenIcerik(context, ref, widget.index);
      },
    );
  }
}

class AlarmIcon extends ConsumerStatefulWidget {
  const AlarmIcon(this.index, {Key? key}) : super(key: key);

  final int index;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AlarmIconState();
}

class _AlarmIconState extends ConsumerState<AlarmIcon> {
  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.alarm,
      color: ref.watch(noteListProvider)[widget.index].alarmVarmi
          ? const Color.fromARGB(255, 5, 189, 8)
          : Colors.black,
    );
  }
}

void editNotes(context, ref, index, showInterAd) {
  textItemController.text = ref.watch(noteListProvider)[index].icerik;
  bool gelenAlarm = ref.read(noteListProvider)[index].alarmVarmi;

  NDialog(
    dialogStyle:
        DialogStyle(backgroundColor: const Color.fromARGB(255, 46, 46, 58)),
    content: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            height: 70.h,
            width: 80.w,
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
                      controller: textItemController,
                      maxLines: 13,
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AlarmSwitch(index),
                    DateTimePickerForItems(index),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        child: const Text("cancel").tr(),
                        onPressed: () {
                          Navigator.pop(context);
                          ref.read(noteListProvider.notifier).alarmToggle(
                              ref.watch(noteListProvider)[index].id,
                              gelenAlarm);
                        }),
                    TextButton(
                      child: const Text("done").tr(),
                      onPressed: () {
                        // NoteListManager(statenotifier) içindeki void fonksiyonlara ulaşmak için .notifier kullanılır
                        //Note classı içindeki değerlere ulaşmak için direkt notelistprovider(statenotifierprovider) la index değerinden ulaşılır
                        ref.read(noteListProvider.notifier).edit(
                            ref.watch(noteListProvider)[index].id,
                            textItemController.text,
                            ref.watch(noteListProvider)[index].alarmVarmi,
                            ref.watch(noteListProvider)[index].alarmZamani);
                        // showInterAd();
                        if (ref.watch(noteListProvider)[index].alarmVarmi) {
                          cancelScheduledNotifications(
                              ref.watch(noteListProvider)[index].id);
                          createNoteReminderNotification(
                              ref.watch(noteListProvider)[index].alarmZamani,
                              ref.watch(noteListProvider)[index].id,
                              ref.watch(noteListProvider)[index].icerik);
                        } else {
                          cancelScheduledNotifications(
                              ref.watch(noteListProvider)[index].id);
                        }
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  ).show(context, dismissable: false);
}

class EditIcon extends ConsumerStatefulWidget {
  final int index;
  const EditIcon(this.index, {Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditIconState();
}

class _EditIconState extends ConsumerState<EditIcon> {
  InterstitialAd? _interAd;
  int _attempt = 0;

  void createAd() {
    InterstitialAd.load(
        adUnitId: dotenv.env['INTERSITITIAL_AD']!,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _interAd = ad;
            _attempt = 0;
          },
          onAdFailedToLoad: (error) {
            _attempt++;
            _interAd = null;
            if (_attempt >= maxFailedLoadAttemps) {
              createAd();
            }
          },
        ));
  }

  void showInterAd() {
    if (_interAd != null) {
      _interAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          createAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          createAd();
        },
      );
      _interAd!.show();
    }
  }

  @override
  void initState() {
    super.initState();
    MobileAds.instance.initialize();
    createAd();
  }

  @override
  void dispose() {
    super.dispose();
    _interAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: const Icon(Icons.edit),
      onTap: () {
        editNotes(context, ref, widget.index, showInterAd);
        ref
            .read(noteListProvider.notifier)
            .editToggle(ref.watch(noteListProvider)[widget.index].id);

        debugPrint(ref.watch(noteListProvider)[widget.index].edit.toString());
      },
    );
  }
}

void bigScreenIcerik(BuildContext context, WidgetRef ref, int index) {
  NDialog(
    dialogStyle: DialogStyle(titleDivider: true),
    //title: const Text("", textAlign: TextAlign.center).tr(),
    actions: <Widget>[
      Container(
        height: 450,
        width: 550,
        decoration: BoxDecoration(
            color: ref.watch(darkBool)
                ? const Color.fromARGB(255, 80, 80, 100)
                : Colors.white,
            border: Border.all(color: const Color.fromARGB(255, 80, 80, 100)),
            boxShadow: const [
              BoxShadow(color: Color.fromARGB(255, 80, 80, 100))
            ]),
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: ListTile(
                    title: Align(
                        alignment: Alignment.topCenter,
                        child: SelectableText(
                            ref.watch(noteListProvider)[index].icerik)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  ).show(context);
}

class PinSwitch extends ConsumerStatefulWidget {
  final int index;

  const PinSwitch(
    this.index, {
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PinSwitch();
}

class _PinSwitch extends ConsumerState<PinSwitch> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: ref.watch(noteListProvider)[widget.index].isPinned
          ? const Icon(
              Icons.push_pin,
              size: 20,
              color: Colors.orange,
            )
          : const Icon(
              Icons.push_pin,
              size: 20,
            ),
      onTap: () {
        ref
            .read(noteListProvider.notifier)
            .pinned(ref.watch(noteListProvider)[widget.index].id);
        ref.read(noteListProvider.notifier).latest();
        ref.read(noteListProvider.notifier).pin();
        ref.read(neSecili.notifier).state = "";
      },
    );
  }
}

class AlarmSwitch extends ConsumerStatefulWidget {
  final int index;

  const AlarmSwitch(
    this.index, {
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AlarmSwitch();
}

class _AlarmSwitch extends ConsumerState<AlarmSwitch> {
  @override
  Widget build(BuildContext context) {
    return CupertinoSwitch(
        value: ref.watch(noteListProvider)[widget.index].alarmVarmi,
        onChanged: (value) {
          // Alarm widgetındaki indexi almak için widget.index kullanılır
          ref
              .read(noteListProvider.notifier)
              .alarmToggle(ref.watch(noteListProvider)[widget.index].id, value);
          debugPrint(
              ref.watch(noteListProvider)[widget.index].alarmVarmi.toString());
        });
  }
}

class DateTimePickerForItems extends ConsumerStatefulWidget {
  final int index;

  const DateTimePickerForItems(
    this.index, {
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DateTimePickerForItems();
}

class _DateTimePickerForItems extends ConsumerState<DateTimePickerForItems> {
  @override
  Widget build(BuildContext context) {
    if (ref.watch(noteListProvider)[widget.index].alarmVarmi == true) {
      return ElevatedButton(
          onPressed: () {
            picker.DatePicker.showTimePicker(
              context,
              showSecondsColumn: false,
              onConfirm: (time) {
                ref.read(alarmDateTime.notifier).state = time;
                ref.read(noteListProvider.notifier).changeAlarm(
                    ref.watch(noteListProvider)[widget.index].id, time);
              },
            );
          },
          child: Title(
              color: Colors.red,
              child: Text(
                  "${ref.watch(noteListProvider)[widget.index].alarmZamani.hour.toString().padLeft(2, "0")}:${ref.watch(noteListProvider)[widget.index].alarmZamani.minute.toString().padLeft(2, "0")}")));
    } else {
      return const Icon(Icons.alarm_add);
    }
  }
}
