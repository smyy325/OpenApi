import '../api/api_client.dart';
import 'package:openapi/api.dart';

/// Pet Store API ile iletişim kurmak için hizmet sınıfı
class PetService {
  final PetApi _petApi;

  PetService(APIClient client) : _petApi = client.petApi;

  /// Belirtilen kimliğe sahip pet detaylarını getir
  Future<Pet?> getPetById(int id) async {
    return await _petApi.getPetById(id);
  }

  /// Belirtilen duruma göre pet listesini getir
  Future<List<Pet>?> getPetsByStatus(String status) async {
    return await _petApi.findPetsByStatus(status: status);
  }

  /// Yeni bir pet ekle
  Future<Pet?> addPet(String name, String status) async {
    final pet = Pet(
      name: name,
      status: PetStatusEnum.fromJson(status),
      photoUrls: [],
    );
    return await _petApi.addPet(pet);
  }

  /// Pet bilgilerini güncelle
  Future<Pet?> updatePet(Pet pet) async {
    return await _petApi.updatePet(pet);
  }

  /// Pet'i sil
  Future<void> deletePet(int id) async {
    await _petApi.deletePet(id);
  }
}
