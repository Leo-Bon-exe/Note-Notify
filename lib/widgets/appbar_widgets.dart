import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:not_uygulamasi/providers/all_providers.dart';
import 'package:not_uygulamasi/widgets/note_list_item.dart';
import 'package:not_uygulamasi/widgets/sol_menu_bar.dart';
import 'package:searchbar_animation/searchbar_animation.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

StateProvider<String> neSecili = StateProvider<String>((ref) {
  return "";
});

class SearchSort extends ConsumerStatefulWidget {
  const SearchSort({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchSortState();
}

class _SearchSortState extends ConsumerState<SearchSort> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search_rounded,
              size: 27,
            )),
      ],
    );
  }
}

class RealSearchButton extends ConsumerStatefulWidget {
  const RealSearchButton({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RealSearchButtonState();
}

class _RealSearchButtonState extends ConsumerState<RealSearchButton> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -4,
      right: 40,
      child: SearchBarAnimation(
        textEditingController: controller,
        hintText: (''),
        isOriginalAnimation: false,
        buttonBorderColour: Colors.black,
        searchBoxWidth: 81.w,
        durationInMilliSeconds: 400,
        buttonShadowColour: const Color(0xFF343442),
        buttonColour:
            ref.watch(darkBool) ? const Color(0xFF343442) : Colors.white,
        onChanged: (String value) {
          ref.read(noteListProvider.notifier).search(value);
        },
        searchBoxColour: const Color.fromARGB(255, 225, 222, 222),
        buttonWidget: const Icon(
          Icons.search,
          color: Colors.black,
        ),
        onPressButton: (isOpen) {
         
        },
        onCollapseComplete: () {
          ref.read(noteListProvider.notifier).latest();
          ref.read(noteListProvider.notifier).pin();
          
          controller.clear();
          FocusScope.of(context).unfocus();
        },
        onFieldSubmitted: (String value) {
          debugPrint('onFieldSubmitted value $value');
        },
        trailingWidget: InkWell(
            onTap: (() => controller.clear()), child: const Icon(Icons.clear)),
        secondaryButtonWidget: const Icon(Icons.search_off),
      ),
    );
  }
}

class CustomButtonTest extends ConsumerStatefulWidget {
  const CustomButtonTest({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomButtonTestState();
}

class _CustomButtonTestState extends ConsumerState<CustomButtonTest> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 11,
      right: 12,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          customButton: const Icon(
            Icons.sort,
            size: 27,
          ),
          customItemsHeights:
              List<double>.filled(MenuItems.firstItems.length, 48),
          items: [
            ...MenuItems.firstItems.map(
              (item) => DropdownMenuItem<MenuItem>(
                value: item,
                child: MenuItems.buildItem(item),
              ),
            ),
          ],
          onChanged: (value) {
            MenuItems.onChanged(context, value as MenuItem);
            switch (value) {
              case MenuItems.oldFirst:
                ref.read(noteListProvider.notifier).oldest();
                ref.read(neSecili.notifier).state = "~${('oldestSort').tr()}";
                
                streamController.add(1);

                break;
              case MenuItems.newFirst:
                ref.read(noteListProvider.notifier).latest();
                ref.read(neSecili.notifier).state = "~${('latestSort').tr()}";
                streamController.add(2);
              
                break;
              case MenuItems.all:
                ref.read(noteListProvider.notifier).latest();
                ref.read(noteListProvider.notifier).pin();
                ref.read(neSecili.notifier).state = "";
                streamController.add(3);
               
                break;
            }
          },
          itemHeight: 48,
          itemPadding: const EdgeInsets.only(left: 20),
          dropdownWidth: 70,
          dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
          dropdownDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.blue[700],
          ),
          dropdownElevation: 8,
          offset: const Offset(-42, 0),
        ),
      ),
    );
  }
}

class MenuItem {
  final String text;
  final IconData icon;

  const MenuItem({
    required this.text,
    required this.icon,
  });
}

class MenuItems {
  static const List<MenuItem> firstItems = [oldFirst, newFirst, all];

  static const oldFirst = MenuItem(
    text: '',
    icon: MdiIcons.sortCalendarDescending,
  );
  static const newFirst =
      MenuItem(text: '', icon: MdiIcons.sortCalendarAscending);
  static const all = MenuItem(text: '', icon: MdiIcons.sortVariantRemove);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(
          item.icon,
          color: Colors.white,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          item.text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  static onChanged(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.oldFirst:
        //Do something
        break;
      case MenuItems.newFirst:
        //Do something
        break;
      case MenuItems.all:
        //Do something
        break;
    }
  }
}
