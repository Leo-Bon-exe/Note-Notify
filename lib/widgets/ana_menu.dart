import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:not_uygulamasi/widgets/appbar_widgets.dart';
import 'package:not_uygulamasi/widgets/note_list_item.dart';
import 'package:not_uygulamasi/widgets/sol_menu_bar.dart';
import 'menu_icon.dart';
import 'add_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

late AnimationController kontrol;



StateProvider<bool> solMenuAcikMi = StateProvider<bool>((ref) {
  return false;
});

class AnaMenu extends ConsumerStatefulWidget {
  const AnaMenu({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => AnaMenuState();
}

class AnaMenuState extends ConsumerState<AnaMenu>
    with SingleTickerProviderStateMixin {
  late double ekranYuksekligi, ekranGenisligi;
  late Animation<double> scaleAnimation;
  late Animation<double> updateAnimation;
  final Duration _duration = const Duration(milliseconds: 400);
  final Stream<int> stream = streamController.stream;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
    kontrol = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    scaleAnimation = Tween(begin: 1.0, end: 0.7).animate(kontrol);
    updateAnimation = Tween(begin: 1.0, end: 1.0).animate(kontrol);

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Allow Notifications'),
            content: const Text('Our app would like to send you notifications'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Don\'t Allow',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ),
              TextButton(
                  onPressed: () => AwesomeNotifications()
                      .requestPermissionToSendNotifications()
                      .then((_) => Navigator.pop(context)),
                  child: const Text(
                    'Allow',
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ))
            ],
          ),
        );
      }
    });

    stream.listen((index) {
      setState(() {});
    });
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

  @override
  Widget build(BuildContext context) {
    ekranYuksekligi = MediaQuery.of(context).size.height;
    ekranGenisligi = MediaQuery.of(context).size.width;
    return AnimatedPositioned(
      duration: _duration,
      top: 0,
      bottom: 0,
      left: ref.watch(solMenuAcikMi) ? 0.5 * ekranGenisligi : 0,
      right: ref.watch(solMenuAcikMi) ? -0.5 * ekranGenisligi : 0,
      child: ScaleTransition(
        scale: scaleAnimation,
        child: Stack(children: [
          InkWell(
            onTap: () {
              if (ref.watch(solMenuAcikMi)) {
                SolMenuBarState().reverse();
                AnaMenuState().reverse();
                ref.read(solMenuAcikMi.notifier).update((state) => !state);
              } else {}
            },
            child: Material(
              borderRadius: ref.watch(solMenuAcikMi)
                  ? const BorderRadius.all(Radius.circular(30))
                  : null,
              elevation: 8,
              color:
                  ref.watch(darkBool) ? const Color(0xFF343442) : Colors.white,
              clipBehavior: Clip.hardEdge,
              child: Column(
                children: [
                  Row(
                    children: [
                       SizedBox(
                        height: 6.5.h,
                        width: 10.w,
                      ),
                      SizedBox(
                          width: 30.w,
                          height: 3.2.h,
                          child: Text(
                            ref.watch(neSecili),
                          )),
                       SizedBox(
                        width: 50.w,
                      ),
                    ],
                  ),
                   SizedBox(
                    height: 0.5.h,
                  ),
                  const NoteItem(),
                ],
              ),
            ),
          ),
          const MenuIcon(),
          const RealSearchButton(),
          const AddButton(),
          const CustomButtonTest(),
        ]),
      ),
    );
  }
}
