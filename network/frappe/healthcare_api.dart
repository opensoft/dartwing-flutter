import 'dart:convert';

import '../base_api.dart';
import '../rest_client.dart';
import 'data/patient.dart';

class HealthcareApi extends BaseNetworkApi {
  HealthcareApi(super.restClient, super.host, super.site, super.company);

  Future<Patient> createPatient(Patient patient) async {
    return await RestClient.post(
      Uri.parse('$host/api/resource/Patient'),
      headers: createTokenAuthNetworkHeaders(),
      body: jsonEncode(patient.toJson()),
    ).then((response) {
      if (response.statusCode ~/ 100 != 2) {
        errorHandler(response, 'Cannot create patient');
      }
      return Patient.fromJson(json.decode(response.body));
    });
  }

  Future<Patient> updatePatient(Patient patient) async {
    return await RestClient.put(
      Uri.parse('$host/api/resource/Patient/${patient.id}'),
      headers: createTokenAuthNetworkHeaders(),
      body: jsonEncode(patient.toJson()),
    ).then((response) {
      if (response.statusCode ~/ 100 != 2) {
        errorHandler(response, 'Cannot update patient');
      }
      return Patient.fromJson(json.decode(response.body));
    });
  }

  Future<Patient> fetchPatient(String patientId) async {
    return await RestClient.get(
      Uri.parse(
        '$host/api/resource/Patient/$patientId?limit_start=0&limit_page_length=100',
      ),
      headers: createTokenAuthNetworkHeaders(),
    ).then((response) {
      if (response.statusCode ~/ 100 != 2) {
        errorHandler(response, 'Cannot fetch patient by id $patientId');
      }
      return Patient.fromJson(json.decode(response.body));
    });
  }

  Future<Patient> fetchPatientByUserId(String userId) async {
    return await RestClient.get(
      Uri.parse(
        '$host/api/resource/Patient?fields=["name","first_name","last_name","user_id"]&filters=[["Patient","user_id","=","$userId"]]',
      ),
      headers: createTokenAuthNetworkHeaders(),
    ).then((response) {
      if (response.statusCode ~/ 100 != 2) {
        errorHandler(response, 'Cannot fetch patient by user_id $userId');
      }
      return Patient.fromJson(json.decode(response.body));
    });
  }

  Future<List<Patient>> fetchPatients() async {
    return await RestClient.get(
      Uri.parse(
        '$host/api/resource/Patient?limit_start=0&limit_page_length=100&fields=["*"]',
      ),
      headers: createTokenAuthNetworkHeaders(),
    ).then((response) {
      if (response.statusCode ~/ 100 != 2) {
        errorHandler(response, 'Cannot fetch patients list');
      }
      var jsonArray = json.decode(response.body)['data'];
      List<Patient> values = [];
      for (var object in jsonArray) {
        values.add(Patient.fromJson(object));
      }
      return values;
    });
  }
}
