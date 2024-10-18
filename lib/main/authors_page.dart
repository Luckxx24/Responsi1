import 'package:flutter/material.dart';
import '../models/author_model.dart';
import '../services/api_services.dart';

class AuthorsPage extends StatefulWidget {
  @override
  _AuthorsPageState createState() => _AuthorsPageState();
}

class _AuthorsPageState extends State<AuthorsPage> {
  final ApiService _apiService = ApiService();
  List<Author> _authors = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAuthors();
  }

  Future<void> _loadAuthors() async {
    try {
      final authors = await _apiService.getAuthors();
      setState(() {
        _authors = authors;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
      setState(() => _isLoading = false);
    }
  }

  Future<void> _showAuthorDialog([Author? author]) async {
    final _formKey = GlobalKey<FormState>();
    final _authorNameController = TextEditingController(text: author?.authorName);
    final _nationalityController = TextEditingController(text: author?.nationality);
    final _birthYearController = TextEditingController(text: author?.birthYear?.toString() ?? '');

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.green[800],
        title: Text(
          author == null ? 'Add Author' : 'Edit Author',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Times New Roman',
          ),
        ),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _authorNameController,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Times New Roman',
                  ),
                  decoration: InputDecoration(
                    labelText: 'Author Name',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter author name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _nationalityController,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Times New Roman',
                  ),
                  decoration: InputDecoration(
                    labelText: 'Nationality',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter nationality';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _birthYearController,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Times New Roman',
                  ),
                  decoration: InputDecoration(
                    labelText: 'Birth Year',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter birth year';
                    }
                    if (int.tryParse(value!) == null) {
                      return 'Please enter a valid year';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Times New Roman',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final newAuthor = Author(
                  id: author?.id,
                  authorName: _authorNameController.text,
                  nationality: _nationalityController.text,
                  birthYear: int.parse(_birthYearController.text),
                );

                try {
                  if (author == null) {
                    await _apiService.createAuthor(newAuthor);
                  } else {
                    await _apiService.updateAuthor(newAuthor);
                  }
                  Navigator.pop(context);
                  _loadAuthors();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toString())),
                  );
                }
              }
            },
            child: Text(
              author == null ? 'Add' : 'Update',
              style: TextStyle(fontFamily: 'Times New Roman'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAuthor(Author author) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.green[800],
        title: Text(
          'Delete Author',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Times New Roman',
          ),
        ),
        content: Text(
          'Are you sure you want to delete ${author.authorName}?',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Times New Roman',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Times New Roman',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Delete',
              style: TextStyle(fontFamily: 'Times New Roman'),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _apiService.deleteAuthor(author.id!);
        _loadAuthors();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[900],
      appBar: AppBar(
        title: Text(
          'Authors',
          style: TextStyle(fontFamily: 'Times New Roman'),
        ),
        backgroundColor: Colors.green[800],
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _authors.length,
        itemBuilder: (context, index) {
          final author = _authors[index];
          return Card(
            color: Colors.green[800],
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(
                author.authorName,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Times New Roman',
                ),
              ),
              subtitle: Text(
                '${author.nationality} (${author.birthYear})',
                style: TextStyle(
                  color: Colors.white70,
                  fontFamily: 'Times New Roman',
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.white),
                    onPressed: () => _showAuthorDialog(author),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.white),
                    onPressed: () => _deleteAuthor(author),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
        onPressed: () => _showAuthorDialog(),
      ),
    );
  }
}
