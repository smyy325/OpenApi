import 'package:flutter/material.dart';
import '../api/api_client.dart';
import '../models/pet.dart';

/// Ana ekran, Pet Store API'den pet verilerini gösterir.
class HomeScreen extends StatefulWidget {
  final APIClient apiClient;

  const HomeScreen({Key? key, required this.apiClient}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Pet> _petFuture;
  final int _petId = 1; // Varsayılan olarak id=1 olan peti gösteriyoruz

  @override
  void initState() {
    super.initState();
    _loadPet();
  }

  void _loadPet() {
    _petFuture = _fetchPet(_petId);
  }

  Future<Pet> _fetchPet(int id) async {
    final petData = await widget.apiClient.getPetById(id);
    return Pet.fromJson(petData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OpenAPI Pet Store Demo')),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _loadPet();
          });
        },
        child: FutureBuilder<Pet>(
          future: _petFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Hata oluştu: ${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _loadPet();
                        });
                      },
                      child: const Text('Tekrar Dene'),
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData) {
              return const Center(child: Text('Veri bulunamadı'));
            }

            final pet = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: PetDetailsCard(pet: pet),
            );
          },
        ),
      ),
    );
  }
}

/// Pet detaylarını gösteren kart widget'ı.
class PetDetailsCard extends StatelessWidget {
  final Pet pet;

  const PetDetailsCard({Key? key, required this.pet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pet adı
            Text(
              pet.name ?? 'İsimsiz Pet',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const Divider(),

            // Pet ID
            _buildInfoRow(context, 'ID:', '${pet.id}'),

            // Pet durumu
            _buildInfoRow(
              context,
              'Durum:',
              pet.status ?? 'Belirtilmemiş',
              valueColor: _getStatusColor(pet.status),
            ),

            // Kategori bilgisi
            if (pet.category != null)
              _buildInfoRow(context, 'Kategori:', pet.category!.name ?? ''),

            const SizedBox(height: 16),

            // Etiketler
            if (pet.tags != null && pet.tags!.isNotEmpty) ...[
              Text(
                'Etiketler:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children:
                    pet.tags!.map((tag) {
                      return Chip(label: Text(tag.name ?? 'İsimsiz Etiket'));
                    }).toList(),
              ),
            ],

            const SizedBox(height: 16),

            // Fotoğraf URL'leri
            if (pet.photoUrls != null && pet.photoUrls!.isNotEmpty) ...[
              Text(
                'Fotoğraflar:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              for (final url in pet.photoUrls!)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(url),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: Theme.of(context).textTheme.titleMedium),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16, color: valueColor),
            ),
          ),
        ],
      ),
    );
  }

  Color? _getStatusColor(String? status) {
    if (status == null) return null;

    switch (status.toLowerCase()) {
      case 'available':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'sold':
        return Colors.red;
      default:
        return null;
    }
  }
}
