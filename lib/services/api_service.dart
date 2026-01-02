import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:showroom_mobil/models/car.dart';

class ApiService {
  // URL MockAPI Anda sudah benar
  static const String baseUrl = "https://6954f2a51cd5294d2c7df5ae.mockapi.io";
  static const String carsEndpoint = "$baseUrl/cars";
  static const String usersEndpoint = "$baseUrl/users";

  // Headers
  static Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  // Login - Perbaikan untuk handling response dari MockAPI
  static Future<Map<String, dynamic>?> login(
      String username, String password) async {
    try {
      print('Attempting login for: $username');
      final response = await http.get(
        Uri.parse(usersEndpoint),
        headers: headers,
      );

      print('Login response status: ${response.statusCode}');
      print('Login response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> users = json.decode(response.body);
        print('Found ${users.length} users in MockAPI');

        // Debug: Print semua users
        for (var user in users) {
          print('User in MockAPI: ${user['username']} - ${user['password']}');
        }

        // Cari user yang cocok
        for (var user in users) {
          if (user['username'] == username && user['password'] == password) {
            print('Login successful for: $username');
            return {
              'id': user['id'].toString(),
              'username': user['username'],
              'isAdmin': user['isAdmin'] ?? false,
            };
          }
        }
        print('User not found or password incorrect');
        return null;
      } else {
        print('Login failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  // Get all cars
  static Future<List<Car>> getCars() async {
    try {
      final response = await http.get(
        Uri.parse(carsEndpoint),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => Car.fromJson(item)).toList();
      } else {
        print('Get cars failed with status: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Get cars error: $e');
      return [];
    }
  }

  // Get car by id
  static Future<Car?> getCarById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$carsEndpoint/$id'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return Car.fromJson(json.decode(response.body));
      } else {
        print('Get car by id failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Get car error: $e');
      return null;
    }
  }

  // Add new car
  static Future<bool> addCar(Car car) async {
    try {
      final response = await http.post(
        Uri.parse(carsEndpoint),
        headers: headers,
        body: json.encode(car.toJson()),
      );

      print('Add car response: ${response.statusCode}');
      print('Add car body: ${response.body}');

      return response.statusCode == 201;
    } catch (e) {
      print('Add car error: $e');
      return false;
    }
  }

  // Update car
  static Future<bool> updateCar(Car car) async {
    try {
      final response = await http.put(
        Uri.parse('$carsEndpoint/${car.id}'),
        headers: headers,
        body: json.encode(car.toJson()),
      );

      print('Update car response: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      print('Update car error: $e');
      return false;
    }
  }

  // Delete car
  static Future<bool> deleteCar(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$carsEndpoint/$id'),
        headers: headers,
      );

      print('Delete car response: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      print('Delete car error: $e');
      return false;
    }
  }
}
