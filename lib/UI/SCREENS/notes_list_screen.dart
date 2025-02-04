import 'package:flutter/material.dart';
import 'package:hidden_pass/DOMAIN/MODELS/notes_model.dart';
import 'package:hidden_pass/UI/WIDGETS/notes_widgets/note_item_widget.dart';

class NotesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<NoteModel> notesList = [
      NoteModel(title: "Nota 1", description: "Enim cupidatat quis non ut."),
      NoteModel(title: "Nota 2", description: "Enim cupidatat quis non ut."),
      NoteModel(title: "Nota 3", description: "Enim cupidatat quis non ut."),
      NoteModel(title: "Nota 4", description: "Enim cupidatat quis non ut."),
      NoteModel(title: "Nota 5", description: "Enim cupidatat quis non ut."),
      NoteModel(title: "Nota 6", description: "Enim cupidatat quis non ut."),
      NoteModel(title: "Nota 7", description: "Enim cupidatat quis non ut."),
      NoteModel(title: "Nota 8", description: "Enim cupidatat quis non ut."),
      NoteModel(title: "Nota 9", description: "Enim cupidatat quis non ut."),
      NoteModel(title: "Nota 10", description: "Enim cupidatat quis non ut."),
      NoteModel(title: "Nota 11", description: "Enim cupidatat quis non ut."),
    ];

    return Scaffold(
      //bottomNavigationBar: bottomNavigationBarWidget(context),
      body: ListView.builder(
        itemCount: notesList.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) => Column(
          children: [
            NoteItemWidget(
              title: notesList[index].title,
              description: notesList[index].description,
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
        shrinkWrap: true,
      ),
    );
  }
}
