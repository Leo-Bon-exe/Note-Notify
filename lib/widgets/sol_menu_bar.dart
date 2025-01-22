import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:iconforest_grommet_icons/grommet_icons.dart';
import 'package:language_picker/language_picker_dropdown.dart';
import 'package:language_picker/languages.dart';
import 'package:ndialog/ndialog.dart';
import 'package:not_uygulamasi/widgets/deleted_page.dart';
import 'package:not_uygulamasi/widgets/note_list_item.dart';


late AnimationController kontrol;

var box = Hive.box<bool>('bool');

StateProvider<bool> darkBool = StateProvider<bool>((ref) {
  if (box.isEmpty) {
    box.add(false);
  }
  bool value = (box.getAt(0)) as bool;
  return value;
});


class SolMenuBar extends ConsumerStatefulWidget {
  const SolMenuBar({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => SolMenuBarState();
}

class SolMenuBarState extends ConsumerState<SolMenuBar>
    with SingleTickerProviderStateMixin {
  late Animation<Offset> _solMenuAnimation;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
    kontrol = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    _solMenuAnimation =
        Tween(begin: const Offset(-1, 0), end: const Offset(0, 0))
            .animate(CurvedAnimation(parent: kontrol, curve: Curves.easeIn));
  }

  void forward() {
    kontrol.forward();
  }

  void reverse() {
    kontrol.reverse();
  }

  @override
  void dispose() {
    kontrol.dispose();
    super.dispose();
  }

  void stateset() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _solMenuAnimation,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll<Color>(Colors.blue[700]!),
                ),
                onPressed: () {
                  showLanguageSheet(context, stateset);
                },
                icon: const Icon(
                  Icons.language,
                  color: Colors.black,
                  size: 24.0,
                ),
                label: const Text(
                  'language',
                  style: TextStyle(color: Color.fromARGB(255, 225, 222, 222)),
                ).tr(),
              ),

              ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll<Color>(Colors.blue[700]!),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SecondPage()));
                },
                icon: const GrommetIcons(GrommetIcons.trash),
                label: const Text(
                  'trash',
                  style: TextStyle(color: Color.fromARGB(255, 225, 222, 222)),
                ).tr(),
              ),
              ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll<Color>(Colors.blue[700]!),
                ),
                onPressed: () {
                  showAboutDialog(context: context,
                  applicationIcon: const Image(
                    image:  AssetImage("assets/images/ic_launcher.png"),
                    width: 70,
                    color: null,
                  ),
                  applicationVersion: '1.0.7',

                  );
                },
                icon: const GrommetIcons(GrommetIcons.circle_information),
                label: const Text(
                  'info',
                  style: TextStyle(color: Color.fromARGB(255, 225, 222, 222)),
                ).tr(),
              ),
              DayNightSwitcher(
                isDarkModeEnabled: ref.watch(darkBool),
                onStateChanged: (isDarkModeEnabled) {
                  box.putAt(0, isDarkModeEnabled);
                  ref
                      .read(darkBool.notifier)
                      .update((state) => isDarkModeEnabled);
                  streamController.add(3);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


void showLanguageSheet(BuildContext context, void Function() stateset) {
  languageBuilder(language) => Padding(
      padding: const EdgeInsets.only(left: 10), child: Text(language.name));
  final supportedLanguages = [
    Languages.english,
    Languages.japanese,
    Languages.turkish,
    Languages.russian,
    Languages.portuguese,
    Languages.norwegian,
    Languages.korean,
    Languages.italian,
    Languages.indonesian,
    Languages.hindi,
    Languages.greek,
    Languages.german,
    Languages.french,
    Languages.spanish,
    Languages.danish,
    Languages.czech,
  ];

  NDialog(
    dialogStyle:
        DialogStyle(backgroundColor: const Color.fromARGB(255, 46, 46, 58)),
    actions: <Widget>[
      Container(
        height: 100,
        width: 300,
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            LanguagePickerDropdown(
                itemBuilder: languageBuilder,
                languages: supportedLanguages,
                onValuePicked: (Language language) {
                  debugPrint(language.isoCode);
                  EasyLocalization.of(context)!
                      .setLocale(Locale(language.isoCode));
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      stateset();
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "done",
                      style: TextStyle(color: Colors.black),
                    ).tr()),
              ],
            ),
          ],
        ),
      ),
    ],
  ).show(context, dismissable: false);
}

void showAlarmInfoSheet(BuildContext context) {
  NDialog(
    dialogStyle:
        DialogStyle(backgroundColor: const Color.fromARGB(255, 46, 46, 58)),
    actions: <Widget>[
      Container(
        height: 240,
        width: 400,
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: const Text('alarm',
                      style:
                          TextStyle(color: Color.fromARGB(255, 210, 208, 208)))
                  .tr(),
            )
          ],
        ),
      ),
    ],
  ).show(context);
}
