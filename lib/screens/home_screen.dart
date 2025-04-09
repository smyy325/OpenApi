import 'package:flutter/material.dart';
import '../api/api_client.dart';
import '../models/pet.dart';
import '../widgets/pet_details_card.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/error_display.dart';
import '../widgets/empty_state.dart';
import '../services/pet_service.dart';

/// Ana ekran, Pet Store API'den pet verilerini gösterir.
class HomeScreen extends StatefulWidget {
  final APIClient apiClient;
  final int petId;

  const HomeScreen({
    Key? key,
    required this.apiClient,
    required this.petId,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Pet> _petFuture;
  late final PetService _petService;

  @override
  void initState() {
    super.initState();
    _petService = PetService(widget.apiClient);
    _loadPet();
  }

  void _loadPet() {
    _petFuture = _petService.getPetById(widget.petId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Detayları'),
      ),
      body: FutureBuilder<Pet>(
        future: _petFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingIndicator();
          } else if (snapshot.hasError) {
            return ErrorDisplay(
              error: snapshot.error,
              onRetry: () => setState(() => _loadPet()),
            );
          } else if (!snapshot.hasData) {
            return const EmptyState(
              message: 'Pet bilgisi bulunamadı',
              icon: Icons.pets,
            );
          }

          final pet = snapshot.data!;
          return _buildPetDetails(pet);
        },
      ),
    );
  }

  Widget _buildPetDetails(Pet pet) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (pet.photoUrls != null && pet.photoUrls!.isNotEmpty) ...[
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: pet.photoUrls!.length,
                itemBuilder: (context, index) {
                  final photoUrl = pet.photoUrls![index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _buildPhotoCard(photoUrl),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
          Text(
            pet.name ?? 'İsimsiz Pet',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          _buildInfoItem('ID', '${pet.id}'),
          if (pet.category != null)
            _buildInfoItem('Kategori', pet.category!.name ?? 'Bilinmiyor'),
          _buildInfoItem('Durum', _getStatusText(pet.status)),
          if (pet.tags != null && pet.tags!.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'Etiketler',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: pet.tags!.map((tag) => _buildTagChip(tag)).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPhotoCard(String photoUrl) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: 200,
        child: photoUrl.startsWith('http')
            ? Image.network(
                photoUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.image_not_supported,
                  size: 100,
                ),
              )
            : Center(child: Text(photoUrl)),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildTagChip(Tag tag) {
    return Chip(
      label: Text(tag.name ?? 'Bilinmiyor'),
      backgroundColor: Colors.blue.shade100,
    );
  }

  String _getStatusText(String? status) {
    switch (status) {
      case 'available':
        return 'Mevcut';
      case 'pending':
        return 'Beklemede';
      case 'sold':
        return 'Satıldı';
      default:
        return status ?? 'Bilinmiyor';
    }
  }
}
