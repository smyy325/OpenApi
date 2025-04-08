import 'package:flutter/material.dart';
import '../api/api_client.dart';
import '../models/pet.dart';

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
        // Yeni bir pet objesi oluştur
        final newPet = {
          'name': _nameController.text,
          'status': _status,
          'photoUrls': <String>[], // API boş array istiyor
        };

        // POST isteği ile pet'i ekle
        await widget.apiClient.request(
          path: '/pet',
          method: 'POST',
          data: newPet,
        );

        // Başarılı sonuç
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Pet başarıyla eklendi!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true); // Başarı işareti ile geri dön
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Pet eklenirken bir hata oluştu: $e';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yeni Pet Ekle')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
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
              ),
              const SizedBox(height: 16),

              // Durum seçici
              DropdownButtonFormField<String>(
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
              ),

              const SizedBox(height: 24),

              if (_errorMessage != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red.shade900),
                  ),
                ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child:
                      _isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Pet Ekle'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
