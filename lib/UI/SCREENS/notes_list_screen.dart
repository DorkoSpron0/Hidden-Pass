import 'package:flutter/material.dart';
import 'package:hidden_pass/UI/WIDGETS/notes_widgets/note_item_widget.dart';

class NotesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //bottomNavigationBar: bottomNavigationBarWidget(context),
      body: ListView.builder(
        itemCount: 20,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) => Column(
          children: [
            NoteItemWidget(),
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
