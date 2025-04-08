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

  const HomeScreen({Key? key, required this.apiClient, this.petId = 1})
    : super(key: key);

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
      appBar: AppBar(title: const Text('Pet Detayları')),
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

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: PetDetailsCard(pet: snapshot.data!),
            );
          },
        ),
      ),
    );
  }
}
