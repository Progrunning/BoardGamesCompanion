// ignore_for_file: library_private_types_in_public_api

import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'playthrough_note_view_model.g.dart';

@injectable
class PlaythroughNoteViewModel = _PlaythroughNoteViewModel with _$PlaythroughNoteViewModel;

abstract class _PlaythroughNoteViewModel with Store {}
