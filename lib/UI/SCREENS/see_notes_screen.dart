import 'package:flutter/material.dart';

class NoteDetailsScreen extends StatelessWidget {
  final String title;
  final String description;
  final String idNote;
  final bool isEditable;

  NoteDetailsScreen({
    required this.title,
    required this.description,
    required this.idNote,
    required this.isEditable,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double screenWidth = constraints.maxWidth;
            double screenHeight = constraints.maxHeight;
            double contentWidth = screenWidth < 600 ? screenWidth * 0.85 : screenWidth * 0.5;

            double shiftLeft = screenWidth * 0.10;
            double shiftDown = screenHeight * 0.10;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 12.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        'Notas',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      left: (64.0 - shiftLeft).clamp(0.0, double.infinity), 
                      right: 24.0,
                      top: shiftDown,
                      bottom: 20.0,
                    ),
                    child: Center(
                      child: SizedBox(
                        width: contentWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Título
                            TextField(
                              readOnly: true,
                              controller: TextEditingController(text: title),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),

                            SizedBox(height: 16),

                            // Descripción
                            TextField(
                              readOnly: true,
                              controller: TextEditingController(text: description),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                height: 1.5,
                              ),
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
