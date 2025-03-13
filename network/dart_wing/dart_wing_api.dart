import 'dart:convert';

import '../base_api.dart';
import '../rest_client.dart';
import 'data/user.dart';

class DartWingApi extends BaseNetworkApi {
  DartWingApi(RestClient restClient, String host, String location)
      : super(restClient, host, location);

  Future<User> fetchUser() async {
    return await RestClient.get(Uri.parse('$host/api/user'),
            headers: createUmsAuthNetworkHeaders())
        .then((response) {
      if (response.statusCode ~/ 100 != 2) {
        errorHandler(response, 'Cannot fetch user');
      }
      return User.fromJson(json.decode(response.body));
    });
  }

  Future<void> updateUserInfo() async {
    return await RestClient.post(Uri.parse('$host/api/user'),
            headers: createUmsAuthNetworkHeaders())
        .then((response) {
      if (response.statusCode ~/ 100 != 2) {
        errorHandler(response, 'Cannot update user');
      }
    });
  }
}
