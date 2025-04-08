import 'package:flutter/material.dart';
import '../api/api_client.dart';
import '../models/pet.dart';
import 'home_screen.dart';
import 'add_pet_screen.dart';

class PetListScreen extends StatefulWidget {
  final APIClient apiClient;

  const PetListScreen({Key? key, required this.apiClient}) : super(key: key);

  @override
  State<PetListScreen> createState() => _PetListScreenState();
}

class _PetListScreenState extends State<PetListScreen> {
  late Future<List<Pet>> _petsFuture;
  String _status = 'available';

  @override
  void initState() {
    super.initState();
    _loadPets();
  }

  void _loadPets() {
    _petsFuture = _fetchPets(_status);
  }

  Future<List<Pet>> _fetchPets(String status) async {
    try {
      final response = await widget.apiClient.request(
        path: '/pet/findByStatus',
        queryParameters: {'status': status},
      );

      final List<dynamic> petsData = response.data;
      return petsData.map((petData) => Pet.fromJson(petData)).toList();
    } catch (e) {
      print('Pet Listesi Çekme Hatası: $e');
      rethrow;
    }
  }

  Future<void> _navigateToAddPet() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPetScreen(apiClient: widget.apiClient),
      ),
    );

    // Eğer pet eklendiyse listeyi yenile
    if (result == true) {
      setState(() {
        _loadPets();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Listesi'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _status = value;
                _loadPets();
              });
            },
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: 'available',
                    child: Text('Mevcut Olanlar'),
                  ),
                  const PopupMenuItem(
                    value: 'pending',
                    child: Text('Bekleyenler'),
                  ),
                  const PopupMenuItem(value: 'sold', child: Text('Satılanlar')),
                ],
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _loadPets();
          });
        },
        child: FutureBuilder<List<Pet>>(
          future: _petsFuture,
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
                          _loadPets();
                        });
                      },
                      child: const Text('Tekrar Dene'),
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Hiç pet bulunamadı'));
            }

            final pets = snapshot.data!;
            return ListView.builder(
              itemCount: pets.length,
              itemBuilder: (context, index) {
                final pet = pets[index];
                return PetListItem(
                  pet: pet,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => HomeScreen(
                              apiClient: widget.apiClient,
                              petId: pet.id ?? 1,
                            ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddPet,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class PetListItem extends StatelessWidget {
  final Pet pet;
  final VoidCallback onTap;

  const PetListItem({Key? key, required this.pet, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(pet.status) ?? Colors.grey,
          child: Text(
            pet.name?.substring(0, 1).toUpperCase() ?? '?',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(pet.name ?? 'İsimsiz Pet'),
        subtitle: Text(
          'ID: ${pet.id} - Durum: ${pet.status ?? 'Belirtilmemiş'}',
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
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
