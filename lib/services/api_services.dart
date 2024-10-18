import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/author_model.dart';

class ApiService {
  static const String baseUrl = 'http://responsi.webwizards.my.id/api/';
  static const String loginUrl = 'http://responsi.webwizards.my.id/api/login';

  String? token;

  Future<bool> register(String name, String email, String password) async {
    try {
      if (password.length < 3) {
        throw Exception('Password must be at least 3 characters long');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/registrasi'),
        body: {
          'name': name,
          'email': email,
          'password': password,
        },
      );

      final data = json.decode(response.body);
      if (data['code'] == 201 && data['status'] == true) {
        return true;
      } else {
        throw Exception(data['data'] ?? 'Registration failed');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        token = data['token'];
        return true;
      }
      return false;
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  Future<List<Author>> getAuthors() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/buku/penulis'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['code'] == 200 && data['status'] == true) {
          List<dynamic> authorsData = data['data'];
          return authorsData.map((json) => Author.fromJson(json)).toList();
        }
      }
      throw Exception('Failed to load authors');
    } catch (e) {
      throw Exception('Failed to load authors: $e');
    }
  }

  Future<Author> createAuthor(Author author) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/buku/penulis'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(author.toJson()),
      );

      final data = json.decode(response.body);
      if (data['code'] == 200 && data['status'] == true) {
        return Author.fromJson(data['data']);
      }
      throw Exception('Failed to create author');
    } catch (e) {
      throw Exception('Failed to create author: $e');
    }
  }

  Future<Author> updateAuthor(Author author) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/buku/penulis/${author.id}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(author.toJson()),
      );

      final data = json.decode(response.body);
      if (data['code'] == 200 && data['status'] == true) {
        return Author.fromJson(data['data']);
      }
      throw Exception('Failed to update author');
    } catch (e) {
      throw Exception('Failed to update author: $e');
    }
  }

  Future<bool> deleteAuthor(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/buku/penulis/$id'),
        headers: {'Authorization': 'Bearer $token'},
      );

      final data = json.decode(response.body);
      return data['code'] == 200 && data['status'] == true;
    } catch (e) {
      throw Exception('Failed to delete author: $e');
    }
  }
}