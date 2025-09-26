import 'dart:convert';

import '../base_api.dart';
import '../rest_client.dart';
import 'data/user.dart';

class UsersApi extends BaseNetworkApi {
  UsersApi(super.restClient, super.host, super.site, super.company);

  Future<User> createUser(User user) async {
    return await RestClient.post(
      Uri.parse('$host/api/resource/User'),
      headers: createTokenAuthNetworkHeaders(),
      body: jsonEncode(user.toJson()),
    ).then((response) {
      if (response.statusCode ~/ 100 != 2) {
        errorHandler(response, 'Cannot create user');
      }
      return User.fromJson(json.decode(response.body));
    });
  }

  Future<User> updateUser(User user) async {
    return await RestClient.put(
      Uri.parse('$host/api/resource/User/${user.email}'),
      headers: createTokenAuthNetworkHeaders(),
      body: jsonEncode(user.toJson()),
    ).then((response) {
      if (response.statusCode ~/ 100 != 2) {
        errorHandler(response, 'Cannot update user');
      }
      return User.fromJson(json.decode(response.body));
    });
  }

  Future<User> fetchUser(String userEmail) async {
    return await RestClient.get(
      Uri.parse(
        '$host/api/resource/User/$userEmail?limit_start=0&limit_page_length=100',
      ),
      headers: createTokenAuthNetworkHeaders(),
    ).then((response) {
      if (response.statusCode ~/ 100 != 2) {
        errorHandler(response, 'Cannot fetch user');
      }
      return User.fromJson(json.decode(response.body));
    });
  }

  Future<List<User>> fetchUsers() async {
    return await RestClient.get(
      Uri.parse(
        '$host/api/resource/User?limit_start=0&limit_page_length=100&fields=["*"]',
      ),
      headers: createTokenAuthNetworkHeaders(),
    ).then((response) {
      if (response.statusCode ~/ 100 != 2) {
        errorHandler(response, 'Cannot fetch users list');
      }
      var jsonArray = json.decode(response.body)['data'];
      List<User> values = [];
      for (var object in jsonArray) {
        values.add(User.fromJson(object));
      }
      return values;
    });
  }
}
