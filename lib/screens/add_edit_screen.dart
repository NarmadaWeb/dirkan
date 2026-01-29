import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dirkan/models/fish_model.dart';
import 'package:dirkan/providers/fish_provider.dart';
import 'package:dirkan/theme/app_theme.dart';

class AddEditScreen extends StatefulWidget {
  final Fish? fish;

  const AddEditScreen({super.key, this.fish});

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  String _selectedCategory = '';
  // Temporary hardcoded image for new items since we can't do real upload in this env easily
  String _imageUrl = 'https://lh3.googleusercontent.com/aida-public/AB6AXuCYRQ5DP9I_XaSVAIqaVQrLnpEWsexRYTnMn8FDC9u2THuZDf8M948MmhDWklOsv-Ezk9S8ZdmW6NJGZER_6g44KhMfHeBMPnSJ7NHQ2Ee0K5qOSSipuBc6PIQMgyZPR_mWX5cCPi-AlIXz1Ggm6Qjk7FxpXfdWhrU-UPCKK-Km3MRMZiTLWTbKBTQplbYqO1NnrsYzQZjS8EcOS2C45EugLmn1Je8RQ90O7gR9hiXVC7gr3CVlIcMaB-YgJNoCWjyZ3BFAIonkjoA';

  bool get isEdit => widget.fish != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.fish?.name ?? '');
    _priceController = TextEditingController(text: widget.fish?.price.toInt().toString() ?? '');
    _descriptionController = TextEditingController(text: widget.fish?.description ?? '');
    _selectedCategory = widget.fish?.category ?? '';
    if (widget.fish != null) {
      _imageUrl = widget.fish!.imageUrl;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate() && _selectedCategory.isNotEmpty) {
      final provider = Provider.of<FishProvider>(context, listen: false);

      final name = _nameController.text;
      final price = double.tryParse(_priceController.text) ?? 0;
      final description = _descriptionController.text;

      if (isEdit) {
        final updatedFish = widget.fish!.copyWith(
          name: name,
          price: price,
          description: description,
          category: _selectedCategory,
          imageUrl: _imageUrl,
        );
        provider.updateFish(updatedFish);
      } else {
        final newFish = Fish(
          id: '', // Generated in provider
          name: name,
          price: price,
          location: 'Bogor, Jawa Barat', // Default for user
          imageUrl: _imageUrl,
          description: description,
          category: _selectedCategory,
          isMine: true,
          sellerName: 'Budi Setiawan', // Current User
        );
        provider.addFish(newFish);
      }

      Navigator.pop(context);
    } else if (_selectedCategory.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih Kategori')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isEdit ? 'Edit Ikan' : 'Tambah Ikan',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Photo Upload
                    const Text(
                      'Foto Ikan',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF192F33).withOpacity(0.3) : Colors.grey[100],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppTheme.primary,
                          style: BorderStyle.solid,
                          width: 1, // Simulated dashed border by solid for now or custom painter
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppTheme.primary.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isEdit ? Icons.photo_library : Icons.add_a_photo,
                              color: AppTheme.primary,
                              size: 40,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            isEdit ? '3 Foto Diunggah' : 'Unggah Foto',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            isEdit
                                ? 'Ganti atau tambah foto terbaik ikan hiasmu (Maks. 5)'
                                : 'Tambahkan hingga 5 foto terbaik ikan hiasmu agar cepat laku',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isDark ? const Color(0xFF92C0C9) : Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              // Simulate selecting photo
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primary,
                              foregroundColor: const Color(0xFF101F22),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(isEdit ? 'Kelola Foto' : 'Pilih Foto'),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Name
                    _buildLabel('Nama Ikan'),
                    TextFormField(
                      controller: _nameController,
                      decoration: _inputDecoration(context, 'Contoh: Betta Halfmoon Fancy'),
                      validator: (value) => value!.isEmpty ? 'Nama harus diisi' : null,
                    ),

                    const SizedBox(height: 16),

                    // Category
                    _buildLabel('Kategori'),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF192F33) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF325E67),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedCategory.isEmpty ? null : _selectedCategory,
                          hint: Text(
                            'Pilih Kategori',
                            style: TextStyle(
                              color: isDark ? const Color(0xFF92C0C9).withOpacity(0.5) : Colors.grey[400],
                            ),
                          ),
                          isExpanded: true,
                          dropdownColor: isDark ? const Color(0xFF192F33) : Colors.white,
                          items: ['Betta', 'Goldfish', 'Koi', 'Discus', 'Arwana', 'Lainnya']
                              .map((cat) => DropdownMenuItem(
                                    value: cat,
                                    child: Text(cat),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value!;
                            });
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Price
                    _buildLabel('Harga (Rp)'),
                    TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration(context, '0').copyWith(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Text(
                            'Rp',
                            style: TextStyle(
                              color: const Color(0xFF92C0C9),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      validator: (value) => value!.isEmpty ? 'Harga harus diisi' : null,
                    ),

                    const SizedBox(height: 16),

                    // Description
                    _buildLabel('Deskripsi'),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 4,
                      decoration: _inputDecoration(context, 'Jelaskan kondisi, ukuran, dan kesehatan ikan hiasmu...'),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Submit Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border(
                top: BorderSide(
                  color: const Color(0xFF325E67).withOpacity(0.3),
                ),
              ),
            ),
            child: ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: const Color(0xFF101F22),
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                shadowColor: AppTheme.primary.withOpacity(0.3),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle),
                  const SizedBox(width: 8),
                  Text(
                    isEdit ? 'Simpan Perubahan' : 'Simpan Postingan',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(BuildContext context, String hint) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: isDark ? const Color(0xFF92C0C9).withOpacity(0.5) : Colors.grey[400],
      ),
      filled: true,
      fillColor: isDark ? const Color(0xFF192F33) : Colors.white,
      contentPadding: const EdgeInsets.all(16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF325E67)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF325E67)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppTheme.primary.withOpacity(0.5), width: 2),
      ),
    );
  }
}
