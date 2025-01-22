import 'package:easy_localization/easy_localization.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:not_uygulamasi/providers/deleted_manager.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../providers/all_providers.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'trash',
            style: TextStyle(color: Color.fromARGB(255, 225, 222, 222)),
          ).tr(),
        ),
        backgroundColor: const Color.fromARGB(255, 32, 32, 41),
        body: const SafeArea(
          child: DeletedShow(),
        ),
      ),
    );
  }
}

class DeletedShow extends ConsumerStatefulWidget {
  const DeletedShow({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => DeletedShowState();
}

class DeletedShowState extends ConsumerState<DeletedShow>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deletedNotes = ref.watch(deletednoteListProvider);
    return ListView.builder(
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
              key: Key(deletedNotes[index].id),
              onDismissed: (direction) {
                ref.read(deletednoteListProvider.notifier).removeDeleted(
                    deletedNotes[index].id);
                setState(() {});
              },
              child: DeletedPage(index));
        },
        itemCount: deletedNotes.length);
  }
}

class DeletedPage extends ConsumerStatefulWidget {
  final int index;
  const DeletedPage(this.index, {Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DeletedPageState();
}

class _DeletedPageState extends ConsumerState<DeletedPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 0.6.w),
      child: ExpansionTileCard(
        title: Text(ref.watch(deletednoteListProvider)[widget.index].icerik,
            maxLines: 3),
        trailing: RestoreWidget(widget.index),
      ),
    );
  }
}

class RestoreWidget extends ConsumerStatefulWidget {
  final int index;
  const RestoreWidget(this.index, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RestoreWidgetState();
}

class _RestoreWidgetState extends ConsumerState<RestoreWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: const Icon(Icons.restore),
      onTap: () {
        ref
            .read(noteListProvider.notifier)
            .addDeletedNote(ref.watch(deletednoteListProvider)[widget.index]);
        ref
            .read(deletednoteListProvider.notifier)
            .removeDeleted(ref.watch(deletednoteListProvider)[widget.index].id);
      },
    );
  }
}
