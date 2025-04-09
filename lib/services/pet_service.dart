import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:built_collection/built_collection.dart';
import '../api/api_client.dart';
import '../models/pet.dart' as app_model;
import 'package:petstore_api/openapi.dart' as petstore_api;
import 'package:petstore_api/src/model/pet.dart';
import 'package:petstore_api/src/model/tag.dart';
import 'package:petstore_api/src/model/category.dart';

/// Pet verilerini yönetmek için servis sınıfı.
/// Bu sınıf, PetStore API'si ile iletişim kurar ve pet verilerini yönetir.
class PetService extends ChangeNotifier {
  final APIClient _apiClient;
  late final petstore_api.PetApi _petApi;

  /// PetService sınıfının yapıcı metodu.
  /// APIClient örneğini alır.
  PetService(this._apiClient) {
    // Serializers nesnesi oluştur
    final serializers = petstore_api.serializers;

    // PetApi örneğini oluştur
    _petApi = petstore_api.PetApi(_apiClient.dio, serializers);
  }

  /// Belirtilen ID'ye sahip bir pet'i getirir.
  Future<app_model.Pet> getPetById(int id) async {
    try {
      // OpenAPI ile oluşturulan PetApi kullanarak pet bilgisini al
      final response = await _petApi.getPetById(petId: id);

      // OpenAPI modeli uygulama modeline dönüştür
      return _convertToPet(response.data!);
    } catch (e) {
      debugPrint('Error getting pet by ID: $e');
      rethrow;
    }
  }

  /// Belirli bir durumdaki pet'leri getirir (örn. 'available').
  Future<List<app_model.Pet>> getPetsByStatus(String status) async {
    try {
      // OpenAPI ile oluşturulan PetApi kullanarak pet bilgilerini al
      final response = await _petApi.findPetsByStatus(status: status);

      // OpenAPI modellerini uygulama modellerine dönüştür
      if (response.data != null) {
        final List<app_model.Pet> pets = [];
        for (final pet in response.data!) {
          pets.add(_convertToPet(pet));
        }
        return pets;
      } else {
        return [];
      }
    } catch (e) {
      debugPrint('Error getting pets by status: $e');
      rethrow;
    }
  }

  /// Yeni bir pet ekler.
  Future<app_model.Pet> addPet(app_model.Pet appPet) async {
    try {
      // Uygulama modelini OpenAPI modeline dönüştür
      final apiPet = _convertToApiPet(appPet);

      // OpenAPI ile oluşturulan PetApi kullanarak pet ekle
      final response = await _petApi.addPet(pet: apiPet);

      // OpenAPI modelini uygulama modeline dönüştür
      return _convertToPet(response.data!);
    } catch (e) {
      debugPrint('Error adding pet: $e');
      rethrow;
    }
  }

  /// Pet bilgilerini günceller
  Future<app_model.Pet> updatePet(app_model.Pet appPet) async {
    try {
      // Uygulama modelini OpenAPI modeline dönüştür
      final apiPet = _convertToApiPet(appPet);

      // OpenAPI ile oluşturulan PetApi kullanarak pet güncelle
      final response = await _petApi.updatePet(pet: apiPet);

      // OpenAPI modelini uygulama modeline dönüştür
      return _convertToPet(response.data!);
    } catch (e) {
      debugPrint('Error updating pet: $e');
      rethrow;
    }
  }

  /// Pet siler
  Future<void> deletePet(int id) async {
    try {
      await _petApi.deletePet(petId: id);
    } catch (e) {
      debugPrint('Error deleting pet: $e');
      rethrow;
    }
  }

  /// OpenAPI modeli olan Pet'i uygulama modeli olan Pet'e dönüştürür.
  app_model.Pet _convertToPet(petstore_api.Pet apiPet) {
    // API modelindeki Tag listesini dönüştür
    final List<app_model.Tag> tags = [];
    if (apiPet.tags != null) {
      for (var tag in apiPet.tags!) {
        if (tag.id != null && tag.name != null) {
          tags.add(app_model.Tag(
            id: tag.id,
            name: tag.name,
          ));
        }
      }
    }

    // API modelindeki Category bilgisini dönüştür
    app_model.Category? category;
    if (apiPet.category != null &&
        apiPet.category!.id != null &&
        apiPet.category!.name != null) {
      category = app_model.Category(
        id: apiPet.category!.id,
        name: apiPet.category!.name,
      );
    }

    // Durum değerini string'e dönüştür
    String? status;
    if (apiPet.status != null) {
      status = apiPet.status.toString().split('.').last;
    }

    // Uygulama modelini oluştur ve döndür
    return app_model.Pet(
      id: apiPet.id,
      name: apiPet.name ?? 'İsimsiz',
      status: status,
      photoUrls: apiPet.photoUrls.toList(),
      tags: tags,
      category: category,
    );
  }

  /// Uygulama modeli olan Pet'i OpenAPI modeli olan Pet'e dönüştürür.
  petstore_api.Pet _convertToApiPet(app_model.Pet pet) {
    // Durum değerini enum'a dönüştür
    petstore_api.PetStatusEnum? status;
    if (pet.status != null) {
      if (pet.status!.toLowerCase() == 'available') {
        status = petstore_api.PetStatusEnum.available;
      } else if (pet.status!.toLowerCase() == 'pending') {
        status = petstore_api.PetStatusEnum.pending;
      } else if (pet.status!.toLowerCase() == 'sold') {
        status = petstore_api.PetStatusEnum.sold;
      }
    }

    // Temel özellikleri ayarla
    final Map<String, dynamic> petJson = {
      'name': pet.name ?? 'İsimsiz',
      'photoUrls': pet.photoUrls ?? <String>[],
    };

    // Diğer özellikleri ekle
    if (pet.id != null) {
      petJson['id'] = pet.id;
    }

    if (status != null) {
      petJson['status'] = status.toString().split('.').last;
    }

    // Etiketleri ekle
    if (pet.tags != null && pet.tags!.isNotEmpty) {
      petJson['tags'] = pet.tags!
          .map((tag) => {
                'id': tag.id,
                'name': tag.name,
              })
          .toList();
    }

    // Kategori ekle
    if (pet.category != null) {
      petJson['category'] = {
        'id': pet.category!.id,
        'name': pet.category!.name,
      };
    }

    // JSON'dan pet nesnesi oluştur
    final jsonString = json.encode(petJson);
    final deserializedJson = json.decode(jsonString);

    return petstore_api.serializers.deserializeWith(
      petstore_api.Pet.serializer,
      deserializedJson,
    )!;
  }
}
