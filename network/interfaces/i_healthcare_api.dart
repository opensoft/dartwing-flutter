import '../frappe/data/dish.dart';
import '../frappe/data/doctor.dart';
import '../frappe/data/patient.dart';

abstract class IHealthcareApi {
  Future<Patient> createPatient(Patient patient);
  Future<Patient> updatePatient(Patient patient);
  Future<Patient> fetchPatient(String patientId);
  Future<Patient> fetchPatientByUserId(String userId);
  Future<List<Patient>> fetchPatients();
  Future<Doctor> createDoctor(Doctor doctor);
  Future<Doctor> updateDoctor(Doctor doctor);
  Future<Doctor> fetchDoctor(String doctorId);
  Future<List<Doctor>> fetchDoctors();
  Future<Dish> createDish(Dish dish);
  Future<Dish> updateDish(Dish dish);
  Future<List<Dish>> fetchDishes();
}
