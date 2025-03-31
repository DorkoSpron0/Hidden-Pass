import 'package:flutter/material.dart';
import 'package:hidden_pass/DOMAIN/MODELS/notes_model.dart';
import 'package:hidden_pass/UI/PROVIDERS/id_user_provider.dart';
import 'package:hidden_pass/UI/PROVIDERS/token_auth_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class NotesListScreen extends StatefulWidget {
  @override
  _NotesListScreenState createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  List<NoteModel> notesList = [];
  bool isLoading = true;

  Future<void> fetchNotes() async {
    final userId = context.read<IdUserProvider>().idUser;
    final token = context.read<TokenAuthProvider>().token;

    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Debe de estar logueado para poder realizar este proceso')),
      );
      return;
    }

    final url = Uri.parse('http://localhost:8081/api/v1/hidden_pass/notes/$userId');

    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        setState(() {
          notesList = data.map((noteData) {
            return NoteModel(
              noteData['id_priority']['name'],
              noteData['title'],
              noteData['description'],
            );
          }).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Error al cargar las notas');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = 16.0;

    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : notesList.isEmpty
              ? Center(child: Text('No tienes notas guardadas'))
              : CustomScrollView(
                  slivers: <Widget>[
                    SliverPadding(
                      padding: EdgeInsets.only(top: 16.0),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            final note = notesList[index];
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                              child: Column(
                                children: [
                                  Slidable(
                                    key: Key(note.title),
                                    startActionPane: ActionPane(
                                      motion: BehindMotion(),
                                      extentRatio: 0.4,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.symmetric(vertical: 4.0),
                                          decoration: BoxDecoration(
                                            color: Colors.red, // Red background for delete
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                          child: SlidableAction(
                                            onPressed: (context) {
                                              print('Delete ${note.title}');
                                              // Implement your delete logic here
                                            },
                                            foregroundColor: Colors.white,
                                            icon: Icons.delete_outline, // Trash can icon
                                            label: '',
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(vertical: 4.0),
                                          decoration: BoxDecoration(
                                            color: Colors.blue, // Blue background for edit
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                          child: SlidableAction(
                                            onPressed: (context) {
                                              print('Edit ${note.title}');
                                            },
                                            foregroundColor: Colors.white,
                                            icon: Icons.edit_outlined, // Pencil icon
                                            label: '',
                                          ),
                                        ),
                                      ],
                                    ),
                                    endActionPane: ActionPane(
                                      motion: BehindMotion(),
                                      extentRatio: 0.3,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.symmetric(vertical: 4.0),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                          child: SlidableAction(
                                            onPressed: (context) {
                                              print('Delete ${note.title}');
                                              // Implement your delete logic here
                                            },
                                            foregroundColor: Colors.white,
                                            icon: Icons.delete_outline,
                                            label: '',
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(vertical: 4.0),
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                          child: SlidableAction(
                                            onPressed: (context) {
                                              print('Edit ${note.title}');
                                            },
                                            foregroundColor: Colors.white,
                                            icon: Icons.edit_outlined,
                                            label: '',
                                          ),
                                        ),
                                      ],
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey.shade800,
                                            width: 1.0,
                                          ),
                                        ),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => NoteDetailScreen(note: note),
                                            ),
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(width: 16),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      note.title,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    SizedBox(height: 4),
                                                    Text(
                                                      note.description,
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 12),
                                              Icon(
                                                Icons.copy_rounded,
                                                color: Colors.grey,
                                                size: 20,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          childCount: notesList.length,
                        ),
                      ),
                    ),
                  ],
                ),
      backgroundColor: Colors.grey.shade900,
    );
  }
}

class NoteDetailScreen extends StatelessWidget {
  final NoteModel note;

  NoteDetailScreen({required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(note.title),
        backgroundColor: Colors.grey.shade800,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              note.description,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey.shade900,
    );
  }
}