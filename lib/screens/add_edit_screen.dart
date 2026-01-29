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
  late TextEditingController _imageUrlController;
  String _selectedCategory = '';

  bool get isEdit => widget.fish != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.fish?.name ?? '');
    _priceController = TextEditingController(text: widget.fish?.price.toInt().toString() ?? '');
    _descriptionController = TextEditingController(text: widget.fish?.description ?? '');
    _imageUrlController = TextEditingController(text: widget.fish?.imageUrl ?? '');
    _selectedCategory = widget.fish?.category ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate() && _selectedCategory.isNotEmpty) {
      final provider = Provider.of<FishProvider>(context, listen: false);

      final name = _nameController.text;
      final price = double.tryParse(_priceController.text) ?? 0;
      final description = _descriptionController.text;
      final imageUrl = _imageUrlController.text;

      if (isEdit) {
        final updatedFish = widget.fish!.copyWith(
          name: name,
          price: price,
          description: description,
          category: _selectedCategory,
          imageUrl: imageUrl,
        );
        provider.updateFish(updatedFish);
      } else {
        final newFish = Fish(
          id: '', // Generated in provider
          name: name,
          price: price,
          location: 'Bogor, Jawa Barat', // Default for user
          imageUrl: imageUrl,
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
                    // Photo URL Input and Preview
                    const Text(
                      'Foto Ikan (URL)',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: _imageUrlController,
                      decoration: _inputDecoration(context, 'Masukkan URL Gambar (https://...)').copyWith(
                        prefixIcon: const Icon(Icons.link),
                      ),
                      validator: (value) => value!.isEmpty ? 'URL Gambar harus diisi' : null,
                      onChanged: (value) => setState(() {}),
                    ),

                    const SizedBox(height: 16),

                    // Image Preview
                    if (_imageUrlController.text.isNotEmpty)
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF192F33).withOpacity(0.3) : Colors.grey[100],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppTheme.primary,
                            width: 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            _imageUrlController.text,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.broken_image, color: Colors.red, size: 40),
                                const SizedBox(height: 8),
                                Text(
                                  'Gambar tidak dapat dimuat',
                                  style: TextStyle(
                                    color: isDark ? const Color(0xFF92C0C9) : Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    else
                      Container(
                        width: double.infinity,
                        height: 120,
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF192F33).withOpacity(0.3) : Colors.grey[100],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.3),
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image,
                              color: isDark ? const Color(0xFF92C0C9).withOpacity(0.5) : Colors.grey[400],
                              size: 40,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Preview gambar akan muncul di sini',
                              style: TextStyle(
                                color: isDark ? const Color(0xFF92C0C9).withOpacity(0.5) : Colors.grey[400],
                                fontSize: 12,
                              ),
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
        borderSide: BorderSide(color: AppTheme.primary.withValues(alpha: 0.5), width: 2),
      ),
    );
  }
}
