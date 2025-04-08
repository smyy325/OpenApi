import 'package:flutter/material.dart';
import '../models/pet.dart';

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
            _buildHeader(context),
            const Divider(),
            _buildBasicInfo(context),
            if (pet.tags != null && pet.tags!.isNotEmpty)
              _buildTagsSection(context),
            if (pet.photoUrls != null && pet.photoUrls!.isNotEmpty)
              _buildPhotosSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Text(
      pet.name ?? 'İsimsiz Pet',
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }

  Widget _buildBasicInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(context, 'ID:', '${pet.id}'),
        _buildInfoRow(
          context,
          'Durum:',
          pet.status ?? 'Belirtilmemiş',
          valueColor: _getStatusColor(pet.status),
        ),
        if (pet.category != null)
          _buildInfoRow(context, 'Kategori:', pet.category!.name ?? ''),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTagsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Etiketler:', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children:
              pet.tags!.map((tag) {
                return Chip(label: Text(tag.name ?? 'İsimsiz Etiket'));
              }).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPhotosSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Fotoğraflar:', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        for (final url in pet.photoUrls!)
          Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(url)),
      ],
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
