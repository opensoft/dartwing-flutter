import 'dart:convert';

import '../base_api.dart';
import '../rest_client.dart';
import 'data/user.dart';

class DartWingApi extends BaseNetworkApi {
  DartWingApi(RestClient restClient, String host, String location)
      : super(restClient, host, location);

  Future<User> fetchMyUserInfo() async {
    return await RestClient.get(Uri.parse('$host/api/me'),
            headers: createUmsAuthNetworkHeaders())
        .then((response) {
      if (response.statusCode ~/ 100 != 2) {
        errorHandler(response, 'Cannot fetch my user info');
      }
      return User.fromJson(json.decode(response.body));
    });
  }

  Future<void> deleteMyUserInfo() async {
    return await RestClient.delete(Uri.parse('$host/api/me'),
            headers: createUmsAuthNetworkHeaders())
        .then((response) {
      if (response.statusCode ~/ 100 != 2) {
        errorHandler(response, 'Cannot delete my user info');
      }
    });
  }
}
