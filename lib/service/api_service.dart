import 'dart:async';
import 'dart:convert';
import 'package:coach_web/config/user_provider.dart';
import 'package:coach_web/model/aspek_model.dart';
import 'package:coach_web/model/assessment_model.dart';
import 'package:coach_web/model/auth_response.dart';
import 'package:coach_web/model/emotional_model.dart';
import 'package:coach_web/model/kriteria_model.dart';
import 'package:coach_web/model/player_model.dart';
import 'package:coach_web/model/schedule_model.dart';
import 'package:coach_web/model/statistik_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://futsal-management-production.up.railway.app/";

  Future<AuthResponse> login(
      BuildContext context, String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}auth/login'), // Periksa di sini
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password,
        }),
      );

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
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  Future<void> register(
      String username, String password, String fullName, String role) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}auth/register'), // Periksa di sini
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
    } catch (e) {
      throw Exception('Failed to register: $e');
    }
  }

  Future<List<ScheduleModel>> fetchSchedules() async {
    try {
      final response =
          await http.get(Uri.parse('${baseUrl}schedule')); // Periksa di sini

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse
            .map((json) => ScheduleModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load schedules');
      }
    } catch (e) {
      throw Exception('Failed to load schedules: $e');
    }
  }

  Future<ScheduleModel?> addSchedule(ScheduleModel schedule) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}schedule'), // Periksa di sini
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(schedule.toJson()),
      );

      if (response.statusCode == 201) {
        return ScheduleModel.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to add schedule: $e');
    }
  }

  Future<List<PlayerModel>> getPlayers() async {
    try {
      final response =
          await http.get(Uri.parse('${baseUrl}player')); // Periksa di sini
      if (response.statusCode == 200) {
        return playerModelFromJson(response.body);
      } else {
        throw Exception('Failed to load players');
      }
    } catch (e) {
      throw Exception('Failed to load players: $e');
    }
  }

  Future<List<PlayerModel>> fetchPlayersByPosition(String position) async {
    try {
      final response = await http.get(
          Uri.parse('${baseUrl}player/position/$position')); // Periksa di sini
      if (response.statusCode == 200) {
        return playerModelFromJson(response.body);
      } else {
        throw Exception('Failed to load players');
      }
    } catch (e) {
      throw Exception('Failed to load players: $e');
    }
  }

  Future<bool> addPlayer(
      String name, String position, String jerseyNumber) async {
    try {
      final url = Uri.parse('${baseUrl}player'); // Periksa di sini

      var request = http.MultipartRequest('POST', url)
        ..fields['name'] = name
        ..fields['position'] = position
        ..fields['jersey_number'] = jerseyNumber;

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      if (response.statusCode == 201) {
        return true;
      } else {
        print('Failed to add player: ${response.statusCode}');
        print('Response body: $responseBody');
        return false;
      }
    } catch (e) {
      throw Exception('Failed to add player: $e');
    }
  }

  Future<bool> updatePlayer(PlayerModel player) async {
    final response = await http.patch(
      Uri.parse('${baseUrl}player/${player.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(player.toJson()),
    );

    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
    print('Request Body: ${jsonEncode(player.toJson())}');

    return response.statusCode == 200;
  }

  Future<void> deletePlayer(String id) async {
    try {
      final response = await http
          .delete(Uri.parse('${baseUrl}player/$id')); // Periksa di sini
      if (response.statusCode != 200) {
        throw Exception('Failed to delete player');
      }
    } catch (e) {
      throw Exception('Failed to delete player: $e');
    }
  }

  Future<List<AspekModel>> getAspeks() async {
    try {
      final response =
          await http.get(Uri.parse('${baseUrl}aspect')); // Periksa di sini
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
        Uri.parse('${baseUrl}aspect'), // Periksa di sini
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
        Uri.parse('${baseUrl}aspect/${aspek.id}'), // Periksa di sini
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(aspek.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print(
            'Failed to update aspek with status code: ${response.statusCode}');
        throw Exception('Failed to update aspek');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<bool> deleteAspek(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('${baseUrl}aspect/$id'), // Periksa di sini
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

  Future<List<KriteriaModel>> getKriteria() async {
    try {
      final response =
          await http.get(Uri.parse('${baseUrl}criteria')); // Periksa di sini
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
    try {
      final response =
          await http.get(Uri.parse('${baseUrl}criteria')); // Periksa di sini
      if (response.statusCode == 200) {
        return kriteriaModelFromJson(response.body);
      } else {
        throw Exception('Failed to load criteria');
      }
    } catch (e) {
      throw Exception('Failed to load criteria: $e');
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
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}criteria'), // Periksa di sini
        headers: {"Content-Type": "application/json"},
        body: json.encode(kriteria.toJson()),
      );
      return response.statusCode == 201;
    } catch (e) {
      throw Exception('Failed to add kriteria: $e');
    }
  }

  Future<bool> updateKriteria(KriteriaModel kriteria) async {
    try {
      final response = await http.patch(
        Uri.parse('${baseUrl}criteria/${kriteria.id}'), // Periksa di sini
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
    } catch (e) {
      throw Exception('Failed to update kriteria: $e');
    }
  }

  Future<bool> deleteKriteria(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('${baseUrl}criteria/$id'), // Periksa di sini
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to delete kriteria');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<AssessmentModel>> fetchPlayers() async {
    try {
      final response =
          await http.get(Uri.parse('${baseUrl}assassment')); // Periksa di sini
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        return data.map((item) => AssessmentModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  Future<List<AssessmentModel>> fetchPlayerData() async {
    try {
      final response =
          await http.get(Uri.parse('${baseUrl}assassment')); // Periksa di sini
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => AssessmentModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  Future<http.Response> submitAssessment(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}assassment'), // Periksa di sini
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to submit assessment: $e');
    }
  }

  Future<List<StatistikModel>> fetchPemain() async {
    try {
      final response =
          await http.get(Uri.parse('${baseUrl}statistic')); // Periksa di sini

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => StatistikModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load pemain');
      }
    } catch (e) {
      throw Exception('Failed to load pemain: $e');
    }
  }

  Future<http.Response> submitStatistik(Map<String, dynamic> data) async {
    try {
      final url = Uri.parse('${baseUrl}statistic'); // Periksa di sini
      final headers = {"Content-Type": "application/json"};
      final body = jsonEncode(data);

      final response = await http.post(url, headers: headers, body: body);
      return response;
    } catch (e) {
      throw Exception('Failed to submit statistik: $e');
    }
  }

  Future<List<EmosionalModel>> fetchEmosiPemain() async {
    try {
      final response =
          await http.get(Uri.parse('${baseUrl}emotional')); // Periksa di sini

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => EmosionalModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load pemain');
      }
    } catch (e) {
      throw Exception('Failed to load pemain: $e');
    }
  }

  Future<EmosionalModel?> addEmosionalPlayer(EmosionalModel emosional) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}emotional'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(emosional.toJson()),
      );

      if (response.statusCode == 201) {
        return EmosionalModel.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to add schedule: $e');
    }
  }

  Future<bool> addEmosional(EmosionalModel emosional) async {
    final response = await http.post(
      Uri.parse('${baseUrl}emotional'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(emosional.toJson()),
    );

    return response.statusCode == 201;
  }
}
