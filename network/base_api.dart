import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/custom_exceptions.dart';
import 'rest_client.dart';

class BaseNetworkApi {
  RestClient restClient;
  String host = "";
  String site = "";
  String company = "";

  BaseNetworkApi(this.restClient, this.host, this.site, this.company);

  void init(
    String newHost,
    String newLocation, {
    String newPolicyName = '',
    String newPolicyKey = '',
  }) {
    host = newHost;
    site = newLocation;
  }

  void deInit() {
    host = "";
    site = "";
  }

  Map<String, String> createBearerAuthNetworkHeaders() {
    return {
      "Accept": "*/*",
      "Authorization": "Bearer ${restClient.token}",
      'Content-Type': 'application/json',
    };
  }

  Map<String, String> createTokenAuthNetworkHeaders() {
    return {
      "Accept": "*/*",
      "Authorization": "token ${restClient.token}",
      'Content-Type': 'application/json',
    };
  }

  Exception errorHandler(http.Response response, [String message = '']) {
    if (message.isNotEmpty) {
      message += ': ';
    }
    message += '${response.statusCode} ${response.reasonPhrase}';
    if (response.body.isNotEmpty) {
      try {
        var bodyJson = json.decode(response.body);
        if (bodyJson['message'] != null) {
          message += ': ${bodyJson['message']}';
          if (bodyJson['errors'] != null) {
            for (var error in bodyJson['errors']) {
              message += ", ${error['code']}";
            }
          }
        } else if (bodyJson['errorMessage'] != null) {
          message += ': ${bodyJson['errorMessage']}';
        } else if (bodyJson['error'] != null) {
          message += ': ${bodyJson['error']['message']}';
        } else if (bodyJson['detail'] != null) {
          message += ': ${bodyJson['detail']}';
        } else if (bodyJson['exception'] != null) {
          message += ': ${bodyJson['exception']}';
        }
      } catch (e) {
        if (!response.body.contains("html")) {
          message += ': ${response.body}';
        }
      }
    }
    switch (response.statusCode) {
      case 400:
        throw BadRequestException(message);
      case 401:
      case 403:
        throw UnauthorisedException(message);
      case 409:
        throw ConflictException(message);
      case 413:
        throw PayloadTooLargeException(message);
      case 500:
      default:
        throw FetchDataException(message);
    }
  }

  String makeAuthErrorMessage() {
    return "${restClient.email} don't have the access to $host $site\nPlease ask IT to add the access rights";
  }
}
