import 'package:flutter/material.dart';
import '../api/api_client.dart';
import '../models/pet.dart';
import '../widgets/loading_indicator.dart';

class AddPetScreen extends StatefulWidget {
  final APIClient apiClient;

  const AddPetScreen({Key? key, required this.apiClient}) : super(key: key);

  @override
  State<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _status = 'available';

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        await _addPet();
        _handleSuccess();
      } catch (e) {
        _handleError(e.toString());
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _addPet() async {
    final newPet = {
      'name': _nameController.text,
      'status': _status,
      'photoUrls': <String>[],
    };

    await widget.apiClient.request(path: '/pet', method: 'POST', data: newPet);
  }

  void _handleSuccess() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pet başarıyla eklendi!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
    }
  }

  void _handleError(String error) {
    setState(() {
      _errorMessage = 'Pet eklenirken bir hata oluştu: $error';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yeni Pet Ekle')),
      body: _isLoading ? const LoadingIndicator() : _buildForm(),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNameField(),
            const SizedBox(height: 16),
            _buildStatusDropdown(),
            const SizedBox(height: 24),
            if (_errorMessage != null) _buildErrorMessage(),
            const SizedBox(height: 16),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Pet Adı',
        hintText: 'Örn: Fluffy',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Lütfen bir isim girin';
        }
        return null;
      },
    );
  }

  Widget _buildStatusDropdown() {
    return DropdownButtonFormField<String>(
      value: _status,
      decoration: const InputDecoration(
        labelText: 'Durum',
        border: OutlineInputBorder(),
      ),
      items: const [
        DropdownMenuItem(value: 'available', child: Text('Mevcut')),
        DropdownMenuItem(value: 'pending', child: Text('Beklemede')),
        DropdownMenuItem(value: 'sold', child: Text('Satıldı')),
      ],
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _status = value;
          });
        }
      },
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.red.shade100,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(_errorMessage!, style: TextStyle(color: Colors.red.shade900)),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text('Pet Ekle'),
      ),
    );
  }
}
