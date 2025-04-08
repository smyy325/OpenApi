import '../api/api_client.dart';
import '../models/pet.dart';

/// Pet Store API ile iletişim kurmak için hizmet sınıfı
class PetService {
  final APIClient _apiClient;

  PetService(this._apiClient);

  /// Belirtilen kimliğe sahip pet detaylarını getir
  Future<Pet> getPetById(int id) async {
    final petData = await _apiClient.getPetById(id);
    return Pet.fromJson(petData);
  }

  /// Belirtilen duruma göre pet listesini getir
  Future<List<Pet>> getPetsByStatus(String status) async {
    final response = await _apiClient.request(
      path: '/pet/findByStatus',
      queryParameters: {'status': status},
    );

    final List<dynamic> petsData = response.data;
    return petsData.map((petData) => Pet.fromJson(petData)).toList();
  }

  /// Yeni bir pet ekle
  Future<void> addPet(String name, String status) async {
    final newPet = {'name': name, 'status': status, 'photoUrls': <String>[]};

    await _apiClient.request(path: '/pet', method: 'POST', data: newPet);
  }
}
