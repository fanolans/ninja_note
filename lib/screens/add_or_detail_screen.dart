// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note/models/note_model.dart';
import 'package:note/providers/notes_provider.dart';
import 'package:note/utils/loading_overlay.dart';
import 'package:provider/provider.dart';

class AddOrDetailScreen extends StatefulWidget {
  static const routeName = '/AddOrDetailScreen';

  const AddOrDetailScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _AddOrDetailScreenState createState() => _AddOrDetailScreenState();
}

class _AddOrDetailScreenState extends State<AddOrDetailScreen> {
  Note _note = Note(
    id: '',
    title: '',
    note: '',
  );
  bool _init = true;

  final _formKey = GlobalKey<FormState>();

  void submitNote() async {
    if (_formKey.currentState != null) {
      _formKey.currentState!.save();
    }
    LoadingOverlay.show(context);

    try {
      final now = DateTime.now();
      _note = _note.copyWith(
        updatedAt: now,
        createdAt: now,
      );
      final notesProvider = Provider.of<NotesProvider>(context, listen: false);
      if (_note.id.isEmpty) {
        await notesProvider.addNote(_note);
      } else {
        await notesProvider.updateNote(_note);
      }
      LoadingOverlay.hide(context);
    } catch (e) {
      await showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            title: const Text('Eror'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Tutup'),
              ),
            ],
          );
        },
      );
    }
    Navigator.of(context).pop();
  }

  @override
  void didChangeDependencies() {
    if (_init) {
      String? id = ModalRoute.of(context)!.settings.arguments as String?;
      if (id != null) {
        _note = Provider.of<NotesProvider>(context).getNote(id);
      }
      _init = false;
    }

    super.didChangeDependencies();
  }

  String _convertData(DateTime dateTime) {
    int diff = DateTime.now().difference(dateTime).inDays;
    if (diff >= 1) return DateFormat('dd-MM-yyyy').format(dateTime);
    return DateFormat('hh:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: submitNote,
              child: const Text(
                'Simpan',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _note.title,
                        decoration: const InputDecoration(
                          hintText: 'Judul',
                          border: InputBorder.none,
                        ),
                        onSaved: (newValue) {
                          _note = _note.copyWith(title: newValue);
                        },
                      ),
                      TextFormField(
                        initialValue: _note.note,
                        decoration: const InputDecoration(
                          hintText: 'Tulis catatan disini...',
                          border: InputBorder.none,
                        ),
                        onSaved: (newValue) {
                          _note = _note.copyWith(note: newValue);
                        },
                        maxLines: null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_note.updatedAt != null)
            Positioned(
              bottom: 10,
              right: 10,
              child: Text('Terakhir diubah: ${_convertData(_note.updatedAt!)}'),
            ),
        ],
      ),
    );
  }
}
