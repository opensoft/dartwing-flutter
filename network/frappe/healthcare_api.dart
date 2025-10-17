import 'dart:convert';

import '../base_api.dart';
import '../rest_client.dart';
import 'data/dish.dart';
import 'data/doctor.dart';
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
      return Patient.fromJson(json.decode(response.body)['data']);
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
        '$host/api/resource/Patient?fields=["*"]&filters=[["Patient","user_id","=","$userId"]]',
      ),
      headers: createTokenAuthNetworkHeaders(),
    ).then((response) {
      if (response.statusCode ~/ 100 != 2) {
        errorHandler(response, 'Cannot fetch patient by user_id $userId');
      }
      List jsonArray = json.decode(response.body)['data'];
      if (jsonArray.isEmpty) {
        errorHandler(response, 'Patient with user_id $userId does not exist');
      }
      return Patient.fromJson(jsonArray.first);
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

  Future<Doctor> createDoctor(Doctor doctor) async {
    return await RestClient.post(
      Uri.parse('$host/api/resource/Healthcare Practitioner'),
      headers: createTokenAuthNetworkHeaders(),
      body: jsonEncode(doctor.toJson()),
    ).then((response) {
      if (response.statusCode ~/ 100 != 2) {
        errorHandler(response, 'Cannot create doctor');
      }
      return Doctor.fromJson(json.decode(response.body)['data']);
    });
  }

  Future<Doctor> updateDoctor(Doctor doctor) async {
    return await RestClient.put(
      Uri.parse('$host/api/resource/Healthcare Practitioner/${doctor.id}'),
      headers: createTokenAuthNetworkHeaders(),
      body: jsonEncode(doctor.toJson()),
    ).then((response) {
      if (response.statusCode ~/ 100 != 2) {
        errorHandler(response, 'Cannot update doctor');
      }
      return Doctor.fromJson(json.decode(response.body));
    });
  }

  Future<Doctor> fetchDoctor(String doctorId) async {
    return await RestClient.get(
      Uri.parse(
        '$host/api/resource/Healthcare Practitioner/$doctorId?limit_start=0&limit_page_length=100',
      ),
      headers: createTokenAuthNetworkHeaders(),
    ).then((response) {
      if (response.statusCode ~/ 100 != 2) {
        errorHandler(response, 'Cannot fetch doctor by id $doctorId');
      }
      return Doctor.fromJson(json.decode(response.body));
    });
  }

  Future<List<Doctor>> fetchDoctors() async {
    return await RestClient.get(
      Uri.parse(
        '$host/api/resource/Healthcare Practitioner?limit_start=0&limit_page_length=100&fields=["*"]',
      ),
      headers: createTokenAuthNetworkHeaders(),
    ).then((response) {
      if (response.statusCode ~/ 100 != 2) {
        errorHandler(response, 'Cannot fetch doctors list');
      }
      var jsonArray = json.decode(response.body)['data'];
      List<Doctor> values = [];
      for (var object in jsonArray) {
        values.add(Doctor.fromJson(object));
      }
      return values;
    });
  }

  Future<Dish> createDish(Dish dish) async {
    return await RestClient.post(
      Uri.parse('$host/api/resource/Dish'),
      headers: createTokenAuthNetworkHeaders(),
      body: jsonEncode(dish.toJson()),
    ).then((response) {
      if (response.statusCode ~/ 100 != 2) {
        errorHandler(response, 'Cannot create dish');
      }
      return Dish.fromJson(json.decode(response.body)['data']);
    });
  }

  Future<Dish> updateDish(Dish dish) async {
    return await RestClient.put(
      Uri.parse('$host/api/resource/Dish/${dish.name}'),
      headers: createTokenAuthNetworkHeaders(),
      body: jsonEncode(dish.toJson()),
    ).then((response) {
      if (response.statusCode ~/ 100 != 2) {
        errorHandler(response, 'Cannot update dish');
      }
      return Dish.fromJson(json.decode(response.body));
    });
  }

  Future<List<Dish>> fetchDishes() async {
    return await RestClient.get(
      Uri.parse(
        '$host/api/resource/Dish?limit_start=0&limit_page_length=100&fields=["*"]',
      ),
      headers: createTokenAuthNetworkHeaders(),
    ).then((response) {
      if (response.statusCode ~/ 100 != 2) {
        errorHandler(response, 'Cannot fetch dishes list');
      }
      var jsonArray = json.decode(response.body)['data'];
      List<Dish> values = [];
      for (var object in jsonArray) {
        values.add(Dish.fromJson(object));
      }
      return values;
    });
  }
}
