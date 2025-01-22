import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:not_uygulamasi/widgets/ana_menu.dart';
import 'package:not_uygulamasi/widgets/sol_menu_bar.dart';

class MenuIcon extends ConsumerWidget {
  const MenuIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Positioned(
        top: 12,
      left: 12,
      child: InkWell(
        child: const Icon(
          Icons.menu_rounded,
          size: 27,
        ),
        onTap: () {
          ref.read(solMenuAcikMi)
              ? SolMenuBarState().reverse()
              : SolMenuBarState().forward();
          ref.read(solMenuAcikMi)
              ? AnaMenuState().reverse()
              : AnaMenuState().forward();
          ref.read(solMenuAcikMi.notifier).update((state) => !state);
        },
      ),
    );
  }
}
