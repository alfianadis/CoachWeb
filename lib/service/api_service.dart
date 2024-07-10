import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:coach_web/config/user_provider.dart';
import 'package:coach_web/model/aspek_model.dart';
import 'package:coach_web/model/assessment_model.dart';
import 'package:coach_web/model/auth_response.dart';
import 'package:coach_web/model/kriteria_model.dart';
import 'package:coach_web/model/player_model.dart';
import 'package:coach_web/model/schedule_model.dart';
import 'package:coach_web/model/statistik_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://nasty-tigers-stop.loca.lt/";

//auth

  Future<AuthResponse> login(
      BuildContext context, String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final authResponse = jsonDecode(response.body);
      final accessToken = authResponse['access_token'];
      final userJson = authResponse['user'];

      // Membuat objek User dari JSON
      final user = User.fromJson(userJson);

      // Simpan user di SharedPreferences untuk menjaga state
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', accessToken);
      await prefs.setString('user', jsonEncode(user.toJson()));

      // Update UserProvider
      Provider.of<UserProvider>(context, listen: false).setUser(user);

      return AuthResponse(
        accessToken: accessToken,
        user: user,
      );
    } else if (response.statusCode == 401) {
      final errorResponse = jsonDecode(response.body);
      throw Exception('Failed to login: ${errorResponse['message']}');
    } else {
      throw Exception('Failed to login: ${response.reasonPhrase}');
    }
  }

  Future<void> register(
      String username, String password, String fullName, String role) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
        'fullName': fullName,
        'role': role,
      }),
    );

    if (response.statusCode != 201) {
      final errorResponse = jsonDecode(response.body);
      throw Exception('Failed to register: ${errorResponse['message']}');
    }
  }

  //schedule

  Future<List<ScheduleModel>> fetchSchedules() async {
    final response = await http.get(Uri.parse('$baseUrl/schedule'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => ScheduleModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load schedules');
    }
  }

  Future<ScheduleModel?> addSchedule(ScheduleModel schedule) async {
    final response = await http.post(
      Uri.parse('$baseUrl/schedule'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(schedule.toJson()),
    );

    if (response.statusCode == 201) {
      return ScheduleModel.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  // Player API
  Future<List<PlayerModel>> getPlayers() async {
    final response = await http.get(Uri.parse('$baseUrl/player'));
    if (response.statusCode == 200) {
      return playerModelFromJson(response.body);
    } else {
      throw Exception('Failed to load players');
    }
  }

  Future<List<PlayerModel>> fetchPlayersByPosition(String position) async {
    final response =
        await http.get(Uri.parse('$baseUrl/player/position/$position'));
    if (response.statusCode == 200) {
      return playerModelFromJson(response.body);
    } else {
      throw Exception('Failed to load players');
    }
  }

  Future<bool> addPlayer(String name, String position, int jerseyNumber) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(baseUrl));
      request.fields['name'] = name;
      request.fields['position'] = position;
      request.fields['jersey_number'] = jerseyNumber.toString();

      var streamedResponse =
          await request.send().timeout(const Duration(seconds: 10));
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        return true;
      } else {
        print('Failed to add player: ${response.statusCode}');
        return false;
      }
    } on SocketException {
      print('No Internet connection');
      return false;
    } on HttpException {
      print("Couldn't find the post");
      return false;
    } on FormatException {
      print("Bad response format");
      return false;
    } on TimeoutException {
      print("Request timed out");
      return false;
    } catch (e) {
      print('Error adding player: $e');
      return false;
    }
  }

  Future<void> updatePlayer(PlayerModel player) async {
    final response = await http.put(
      Uri.parse('$baseUrl/player/${player.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(player.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update player');
    }
  }

  Future<void> deletePlayer(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/player/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete player');
    }
  }

  // Aspek API
  Future<List<AspekModel>> getAspeks() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/aspect'));
      if (response.statusCode == 200) {
        Iterable jsonResponse = json.decode(response.body);
        return jsonResponse.map((model) => AspekModel.fromJson(model)).toList();
      } else {
        throw Exception('Failed to load aspeks');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<AspekModel> createAspekModel(AspekModel aspekModel) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/aspect'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(aspekModel.toJson()),
      );
      if (response.statusCode == 201) {
        return AspekModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create aspect');
      }
    } catch (e) {
      throw Exception('Failed to create aspect: $e');
    }
  }

  Future<bool> updateAspek(AspekModel aspek) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/aspect/${aspek.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(aspek.toJson()),
      );

      print('Request Body: ${jsonEncode(aspek.toJson())}');
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return true;
      } else {
        print(
            'Failed to update aspek with status code: ${response.statusCode}');
        throw Exception('Failed to update aspek');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error: $e');
    }
  }

  Future<bool> deleteAspek(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/aspect/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to delete aspek');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Kriteria API
  Future<List<KriteriaModel>> getKriteria() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/criteria'));
      if (response.statusCode == 200) {
        Iterable jsonResponse = json.decode(response.body);
        return jsonResponse
            .map((model) => KriteriaModel.fromJson(model))
            .toList();
      } else {
        throw Exception('Failed to load criteria');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<KriteriaModel>> fetchCriteria() async {
    final response = await http.get(Uri.parse('$baseUrl/criteria'));
    if (response.statusCode == 200) {
      return kriteriaModelFromJson(response.body);
    } else {
      throw Exception('Failed to load criteria');
    }
  }

  List<String> getAssessmentAspectsByPosition(
      List<KriteriaModel> criteria, String position) {
    return criteria
        .where((item) => item.posisi == position)
        .map((item) => item.assessmentAspect)
        .toSet()
        .toList();
  }

  List<KriteriaModel> getCriteriaByAssessmentAspect(
      List<KriteriaModel> criteria, String assessmentAspect) {
    return criteria
        .where((item) => item.assessmentAspect == assessmentAspect)
        .toList();
  }

  Future<bool> addKriteria(KriteriaModel kriteria) async {
    final response = await http.post(
      Uri.parse('$baseUrl/criteria'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(kriteria.toJson()),
    );
    return response.statusCode == 201;
  }

  Future<bool> updateKriteria(KriteriaModel kriteria) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/criteria/${kriteria.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(kriteria.toJson()),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      print('Failed to update kriteria: ${response.reasonPhrase}');
      return false;
    }
  }

  Future<bool> deleteKriteria(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/criteria/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to delete aspek');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Assessment API
  Future<List<AssessmentModel>> fetchPlayers() async {
    final response = await http.get(Uri.parse('$baseUrl/assassment'));
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((item) => AssessmentModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<AssessmentModel>> fetchPlayerData() async {
    final response = await http.get(Uri.parse('$baseUrl/assassment'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => AssessmentModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<http.Response> submitAssessment(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/assassment'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    return response;
  }

  //statistik

  // Future<List<Map<String, dynamic>>> fetchStatistics() async {
  //   final url = Uri.parse('$baseUrl/statistic');
  //   final response = await http.get(url);

  //   if (response.statusCode == 200) {
  //     List jsonResponse = json.decode(response.body);
  //     return List<Map<String, dynamic>>.from(jsonResponse);
  //   } else {
  //     throw Exception('Failed to load statistics');
  //   }
  // }

  Future<List<StatistikModel>> fetchPemain() async {
    final response = await http.get(Uri.parse('$baseUrl/statistic'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => StatistikModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load pemain');
    }
  }

  Future<http.Response> submitStatistik(Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/statistic');
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode(data);

    final response = await http.post(url, headers: headers, body: body);
    return response;
  }
}
