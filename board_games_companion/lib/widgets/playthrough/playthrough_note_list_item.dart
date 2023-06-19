import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../common/app_colors.dart';
import '../../common/dimensions.dart';
import '../../models/hive/playthrough_note.dart';

class PlaythroughNoteListItem extends StatelessWidget {
  const PlaythroughNoteListItem({
    super.key,
    required this.note,
    required this.onTap,
    required this.onDelete,
  });

  final PlaythroughNote note;
  final void Function(PlaythroughNote note) onTap;
  final void Function(PlaythroughNote note) onDelete;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(note),
      child: Slidable(
        endActionPane: ActionPane(
          extentRatio: 0.25,
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              icon: Icons.delete,
              onPressed: (_) => onDelete(note),
              backgroundColor: AppColors.redColor,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.standardSpacing),
                child: Text(note.text, textAlign: TextAlign.justify),
              ),
            )
          ],
        ),
      ),
    );
  }
}
