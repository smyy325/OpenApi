import 'package:flutter/material.dart';
import '../api/api_client.dart';
import '../models/pet.dart';
import '../services/pet_service.dart';
import 'home_screen.dart';
import 'add_pet_screen.dart';
import '../widgets/pet_list_item.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/error_display.dart';
import '../widgets/empty_state.dart';

class PetListScreen extends StatefulWidget {
  final APIClient apiClient;

  const PetListScreen({Key? key, required this.apiClient}) : super(key: key);

  @override
  State<PetListScreen> createState() => _PetListScreenState();
}

class _PetListScreenState extends State<PetListScreen> {
  late Future<List<Pet>> _petsFuture;
  late final PetService _petService;
  String _status = 'available';

  @override
  void initState() {
    super.initState();
    _petService = PetService(widget.apiClient);
    _loadPets();
  }

  void _loadPets() {
    _petsFuture = _petService.getPetsByStatus(_status);
  }

  Future<void> _navigateToAddPet() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPetScreen(apiClient: widget.apiClient),
      ),
    );

    if (result == true) {
      setState(() {
        _loadPets();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddPet,
        child: const Icon(Icons.add),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Pet Listesi'),
      actions: [
        PopupMenuButton<String>(
          onSelected: (value) {
            setState(() {
              _status = value;
              _loadPets();
            });
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: 'available',
              child: Text('Mevcut Olanlar'),
            ),
            PopupMenuItem(value: 'pending', child: Text('Bekleyenler')),
            PopupMenuItem(value: 'sold', child: Text('Satılanlar')),
          ],
          icon: const Icon(Icons.filter_list),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _loadPets();
        });
      },
      child: FutureBuilder<List<Pet>>(
        future: _petsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingIndicator();
          } else if (snapshot.hasError) {
            return ErrorDisplay(
              error: snapshot.error,
              onRetry: () => setState(() => _loadPets()),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const EmptyState(
              message: 'Hiç pet bulunamadı',
              icon: Icons.pets,
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final pet = snapshot.data![index];
              return PetListItem(
                pet: pet,
                onTap: () => _navigateToPetDetails(pet),
              );
            },
          );
        },
      ),
    );
  }

  void _navigateToPetDetails(Pet pet) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            HomeScreen(apiClient: widget.apiClient, petId: pet.id ?? 1),
      ),
    );
  }
}
