import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:http_parser/http_parser.dart';

import 'paper_trail.dart';

class RestClient {
  static final http.Client _client = RetryClient(http.Client(), retries: 2);
  String token = "";
  String clientName = "";
  String email = "";

  void init(String newClientName, String newToken, String newEmail) {
    clientName = newClientName;
    token = newToken;
    email = newEmail;
  }

  static Future<http.Response> get(
    Uri url, {
    Map<String, String>? headers,
    bool silentMode = false,
  }) async {
    if (!silentMode) {
      PaperTrailClient.sendInfoMessageToPaperTrail("GET ${url.toString()}");
    }
    final stopwatch = Stopwatch();
    stopwatch.start();
    return _client
        .get(url, headers: headers)
        .then((response) {
          if (!silentMode) {
            PaperTrailClient.sendInfoMessageToPaperTrail(
              "Finished: GET ${response.statusCode} ${response.reasonPhrase} ${url.toString()} (${stopwatch.elapsedMilliseconds}ms)",
            );
          }
          stopwatch.stop();
          return response;
        })
        .catchError((e) {
          PaperTrailClient.sendWarningMessageToPaperTrail(
            "Error occurred: GET ${e.toString()} ${url.toString()} (${stopwatch.elapsedMilliseconds}ms)",
          );
          stopwatch.stop();
          throw e;
        });
  }

  static Future<http.Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    bool silentMode = false,
  }) {
    if (!silentMode) {
      PaperTrailClient.sendInfoMessageToPaperTrail(
        "POST ${url.toString()} body: $body",
      );
    }
    final stopwatch = Stopwatch();
    stopwatch.start();
    return _client
        .post(url, headers: headers, body: body)
        .then((response) {
          if (!silentMode) {
            PaperTrailClient.sendInfoMessageToPaperTrail(
              "Finished: POST ${response.statusCode} ${response.reasonPhrase} ${url.toString()} (${stopwatch.elapsedMilliseconds}ms)",
            );
          }
          stopwatch.stop();
          return response;
        })
        .catchError((e) {
          PaperTrailClient.sendWarningMessageToPaperTrail(
            "Error occurred: POST ${e.toString()} ${url.toString()} (${stopwatch.elapsedMilliseconds}ms)",
          );
          stopwatch.stop();
          throw e;
        });
  }

  static Future<http.Response> put(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    bool silentMode = false,
  }) {
    if (!silentMode) {
      PaperTrailClient.sendInfoMessageToPaperTrail(
        "PUT ${url.toString()} body: $body",
      );
    }
    final stopwatch = Stopwatch();
    stopwatch.start();
    return _client
        .put(url, headers: headers, body: body)
        .then((response) {
          if (!silentMode) {
            PaperTrailClient.sendInfoMessageToPaperTrail(
              "Finished: PUT ${response.statusCode} ${response.reasonPhrase} ${url.toString()} (${stopwatch.elapsedMilliseconds}ms)",
            );
          }
          stopwatch.stop();
          return response;
        })
        .catchError((e) {
          PaperTrailClient.sendWarningMessageToPaperTrail(
            "Error occurred: PUT ${e.toString()} ${url.toString()} (${stopwatch.elapsedMilliseconds}ms)",
          );
          stopwatch.stop();
          throw e;
        });
  }

  static Future<http.Response> multipartFileRequest(
    Uri url,
    Map<String, String> fields,
    Map<String, List<int>> files,
    String filename, {
    Map<String, String>? headers,
    MediaType? fileContentType,
    bool silentMode = false,
  }) {
    if (!silentMode) {
      PaperTrailClient.sendInfoMessageToPaperTrail(
        "Multipart POST ${url.toString()}",
      );
    }
    final stopwatch = Stopwatch();
    stopwatch.start();

    var request = http.MultipartRequest('POST', url);
    request.fields.addAll(fields);
    if (headers != null) {
      request.headers.addAll(headers);
    }
    files.forEach((String key, List<int> value) {
      request.files.add(
        http.MultipartFile.fromBytes(
          key,
          value,
          filename: filename,
          contentType: fileContentType,
        ),
      );
    });
    return _client
        .send(request)
        .then((response) {
          if (!silentMode) {
            PaperTrailClient.sendInfoMessageToPaperTrail(
              "Finished: POST ${response.statusCode} ${response.reasonPhrase} ${url.toString()} (${stopwatch.elapsedMilliseconds}ms)",
            );
          }
          stopwatch.stop();
          return http.Response.fromStream(response);
        })
        .catchError((e) {
          PaperTrailClient.sendWarningMessageToPaperTrail(
            "Error occurred: POST ${e.toString()} ${url.toString()} (${stopwatch.elapsedMilliseconds}ms)",
          );
          stopwatch.stop();
          throw e;
        });
  }

  static Future<http.Response> patch(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    bool silentMode = false,
  }) {
    if (!silentMode) {
      PaperTrailClient.sendInfoMessageToPaperTrail(
        "PATCH ${url.toString()} body: $body",
      );
    }
    final stopwatch = Stopwatch();
    stopwatch.start();
    return _client
        .patch(url, headers: headers, body: body)
        .then((response) {
          if (!silentMode) {
            PaperTrailClient.sendInfoMessageToPaperTrail(
              "Finished: PATCH ${response.statusCode} ${response.reasonPhrase} ${url.toString()} (${stopwatch.elapsedMilliseconds}ms)",
            );
          }
          stopwatch.stop();
          return response;
        })
        .catchError((e) {
          PaperTrailClient.sendWarningMessageToPaperTrail(
            "Error occurred: PATCH ${e.toString()} ${url.toString()} (${stopwatch.elapsedMilliseconds}ms)",
          );
          stopwatch.stop();
          throw e;
        });
  }

  static Future<http.Response> delete(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    bool silentMode = false,
  }) {
    if (!silentMode) {
      PaperTrailClient.sendInfoMessageToPaperTrail(
        "DELETE ${url.toString()} body: $body",
      );
    }
    final stopwatch = Stopwatch();
    stopwatch.start();
    return _client
        .delete(url, headers: headers, body: body)
        .then((response) {
          if (!silentMode) {
            PaperTrailClient.sendInfoMessageToPaperTrail(
              "Finished: DELETE ${response.statusCode} ${response.reasonPhrase} ${url.toString()} (${stopwatch.elapsedMilliseconds}ms)",
            );
          }
          stopwatch.stop();
          return response;
        })
        .catchError((e) {
          PaperTrailClient.sendWarningMessageToPaperTrail(
            "Error occurred: DELETE ${e.toString()} ${url.toString()} (${stopwatch.elapsedMilliseconds}ms)",
          );
          stopwatch.stop();
          throw e;
        });
  }
}
