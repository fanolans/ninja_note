import 'package:note/database/database_helper.dart';

class Note {
  final String id;
  final String title;
  final String note;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  bool isPinned;

  Note({
    required this.id,
    required this.title,
    required this.note,
    this.updatedAt,
    this.createdAt,
    this.isPinned = false,
  });

  Note.fromDb(Map<String, dynamic> data)
      : id = data[DatabaseHelper.tableNotesId],
        title = data[DatabaseHelper.tableNotesTitle],
        note = data[DatabaseHelper.tableNotesNote],
        isPinned = data[DatabaseHelper.tableNotesIsPinned] == 1,
        updatedAt = DateTime.parse(data[DatabaseHelper.tableNotesUpdatedAt]),
        createdAt = DateTime.parse(data[DatabaseHelper.tableNotesCreatedAt]);

  Map<String, dynamic> toDb() {
    return {
      DatabaseHelper.tableNotesId: id,
      DatabaseHelper.tableNotesTitle: title,
      DatabaseHelper.tableNotesNote: note,
      DatabaseHelper.tableNotesIsPinned: isPinned ? 1 : 0,
      DatabaseHelper.tableNotesUpdatedAt: updatedAt!.toIso8601String(),
      DatabaseHelper.tableNotesCreatedAt: createdAt!.toIso8601String(),
    };
  }

  Note copyWith({
    String? id,
    String? title,
    String? note,
    DateTime? updatedAt,
    DateTime? createdAt,
    bool? isPinned,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      note: note ?? this.note,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      isPinned: isPinned ?? this.isPinned,
    );
  }
}
