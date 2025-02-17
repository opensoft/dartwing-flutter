import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

import '../core/custom_exceptions.dart';
import 'rest_client.dart';

class BaseNetworkApi {
  RestClient restClient;
  String host = "";
  String location = "";

  String policyName = "";
  String policyKey = "";

  BaseNetworkApi(this.restClient, this.host, this.location,
      {this.policyKey = '', this.policyName = ''});

  void init(String newHost, String newLocation,
      {String newPolicyName = '', String newPolicyKey = ''}) {
    host = newHost;
    location = newLocation;
    policyName = newPolicyName;
    policyKey = newPolicyKey;
    policyName = newPolicyName;
  }

  void deInit() {
    host = "";
    location = "";
  }

  Map<String, String> createUmsAuthNetworkHeaders() {
    return {
      "Accept": "*/*",
      "X-Client-Name": restClient.clientName,
      "Authorization": "Bearer ${restClient.token}",
      'Content-Type': 'application/json'
    };
  }

  Map<String, String> createHelpDeskAuthNetworkHeaders() {
    return {
      "Authorization": "Bearer ${restClient.token}",
      'accept': 'text/plain',
      "Content-Type": "application/json-patch+json"
    };
  }

  String createSharedAccessToken(uri, policyName, policyKey) {
    String encoded = Uri.encodeComponent(uri);
    int now = DateTime.now().millisecondsSinceEpoch;
    int week = 60 * 60 * 24 * 7;
    int ttl = now ~/ 1000.0 + week;
    List<int> stringToSign = utf8.encode("$encoded\n$ttl");
    Hmac hMac = Hmac(sha256, utf8.encode(policyKey));
    var hash = base64Encode(hMac.convert(stringToSign).bytes);
    return 'SharedAccessSignature sr=$encoded&sig=${Uri.encodeComponent(hash)}&se=$ttl&skn=$policyName';
  }

  Map<String, String> createSASAuthNetworkHeaders() {
    String hostname = host.replaceAll('https://', '');
    return {
      "Authorization": createSharedAccessToken(hostname, policyName, policyKey),
      "Host": hostname,
    };
  }

  Map<String, String> createIncRouterAuthNetworkHeaders() {
    return {
      "X-InkRouter-Client": restClient.clientName,
      "X-InkRouter-ApiKey": restClient.token,
      'Content-Type': 'application/json'
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
      case 500:
      default:
        throw FetchDataException(message);
    }
  }

  String makeAuthErrorMessage() {
    return "${restClient.email} don't have the access to $host $location\nPlease ask IT to add the access rights";
  }
}
