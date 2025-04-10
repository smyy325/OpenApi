import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for PetApi
void main() {
  final instance = Openapi().getPetApi();

  group(PetApi, () {
    // Add a new pet to the store.
    //
    // Add a new pet to the store.
    //
    //Future<Pet> addPet(Pet pet) async
    test('test addPet', () async {
      // TODO
    });

    // Deletes a pet.
    //
    // Delete a pet.
    //
    //Future deletePet(int petId, { String apiKey }) async
    test('test deletePet', () async {
      // TODO
    });

    // Finds Pets by status.
    //
    // Multiple status values can be provided with comma separated strings.
    //
    //Future<BuiltList<Pet>> findPetsByStatus({ String status }) async
    test('test findPetsByStatus', () async {
      // TODO
    });

    // Finds Pets by tags.
    //
    // Multiple tags can be provided with comma separated strings. Use tag1, tag2, tag3 for testing.
    //
    //Future<BuiltList<Pet>> findPetsByTags({ BuiltList<String> tags }) async
    test('test findPetsByTags', () async {
      // TODO
    });

    // Find pet by ID.
    //
    // Returns a single pet.
    //
    //Future<Pet> getPetById(int petId) async
    test('test getPetById', () async {
      // TODO
    });

    // Update an existing pet.
    //
    // Update an existing pet by Id.
    //
    //Future<Pet> updatePet(Pet pet) async
    test('test updatePet', () async {
      // TODO
    });

    // Updates a pet in the store with form data.
    //
    // Updates a pet resource based on the form data.
    //
    //Future<Pet> updatePetWithForm(int petId, { String name, String status }) async
    test('test updatePetWithForm', () async {
      // TODO
    });

    // Uploads an image.
    //
    // Upload image of the pet.
    //
    //Future<ApiResponse> uploadFile(int petId, { String additionalMetadata, MultipartFile body }) async
    test('test uploadFile', () async {
      // TODO
    });

  });
}
