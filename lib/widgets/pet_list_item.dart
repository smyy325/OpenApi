import 'package:flutter/material.dart';
import '../models/pet.dart';

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
        leading: _buildLeadingAvatar(),
        title: Text(pet.name ?? 'İsimsiz Pet'),
        subtitle: Text(
          'ID: ${pet.id} - Durum: ${pet.status ?? 'Belirtilmemiş'}',
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _buildLeadingAvatar() {
    return CircleAvatar(
      backgroundColor: _getStatusColor(pet.status) ?? Colors.grey,
      child: Text(
        pet.name?.substring(0, 1).toUpperCase() ?? '?',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
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
