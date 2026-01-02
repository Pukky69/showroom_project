import 'package:flutter/material.dart';
import 'package:showroom_mobil/models/car.dart';
import 'package:showroom_mobil/services/api_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:showroom_mobil/constants/colors.dart';

class CarFormScreen extends StatefulWidget {
  final Car? car;

  const CarFormScreen({super.key, this.car});

  @override
  State<CarFormScreen> createState() => _CarFormScreenState();
}

class _CarFormScreenState extends State<CarFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _merkController = TextEditingController();
  final _modelController = TextEditingController();
  final _tahunController = TextEditingController();
  final _hargaController = TextEditingController();
  final _warnaController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _imageUrlController = TextEditingController();

  final List<String> _warnaOptions = [
    'Merah',
    'Biru',
    'Hitam',
    'Putih',
    'Abu',
    'Hijau',
    'Silver',
    'Kuning',
    'Orange',
    'Emas'
  ];

  @override
  void initState() {
    super.initState();

    if (widget.car != null) {
      _merkController.text = widget.car!.merk;
      _modelController.text = widget.car!.model;
      _tahunController.text = widget.car!.tahun.toString();
      _hargaController.text = widget.car!.harga.toString();
      _warnaController.text = widget.car!.warna;
      _deskripsiController.text = widget.car!.deskripsi;
      _imageUrlController.text = widget.car!.imageUrl ?? '';
    }
  }

  @override
  void dispose() {
    _merkController.dispose();
    _modelController.dispose();
    _tahunController.dispose();
    _hargaController.dispose();
    _warnaController.dispose();
    _deskripsiController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveCar() async {
    if (_formKey.currentState!.validate()) {
      EasyLoading.show(status: 'Saving...');

      final car = Car(
        id: widget.car?.id,
        merk: _merkController.text.trim(),
        model: _modelController.text.trim(),
        tahun: int.parse(_tahunController.text.trim()),
        harga: double.parse(_hargaController.text.trim()),
        warna: _warnaController.text.trim(),
        deskripsi: _deskripsiController.text.trim(),
        imageUrl: _imageUrlController.text.trim().isEmpty
            ? null
            : _imageUrlController.text.trim(),
      );

      bool success;

      if (widget.car?.id != null) {
        success = await ApiService.updateCar(car);
      } else {
        success = await ApiService.addCar(car);
      }

      if (success) {
        EasyLoading.showSuccess('Car saved successfully!');
        Navigator.pop(context);
      } else {
        EasyLoading.showError('Failed to save car');
      }
    }
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int? maxLines,
    bool isRequired = true,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  color: AppColors.grey700,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  letterSpacing: 0.5,
                ),
              ),
              if (!isRequired)
                Text(
                  ' (Optional)',
                  style: TextStyle(
                    color: AppColors.grey500,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppColors.primaryBlue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.grey300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primaryBlue, width: 2),
              ),
              filled: true,
              fillColor: AppColors.grey50,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
            style: TextStyle(color: AppColors.grey900),
            validator: validator,
          ),
        ],
      ),
    );
  }

  Widget _buildColorDropdown() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Color',
            style: TextStyle(
              color: AppColors.grey700,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey300),
              borderRadius: BorderRadius.circular(12),
              color: AppColors.grey50,
            ),
            child: DropdownButtonFormField<String>(
              value:
                  _warnaController.text.isEmpty ? null : _warnaController.text,
              decoration: InputDecoration(
                prefixIcon:
                    Icon(Icons.color_lens, color: AppColors.primaryBlue),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              items: _warnaOptions.map((warna) {
                return DropdownMenuItem(
                  value: warna,
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: _getColorFromString(warna),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.grey400),
                        ),
                      ),
                      Text(warna),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _warnaController.text = value!;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select color';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorFromString(String warna) {
    switch (warna.toLowerCase()) {
      case 'merah':
        return Colors.red;
      case 'biru':
        return Colors.blue;
      case 'hitam':
        return Colors.black;
      case 'putih':
        return Colors.white;
      case 'abu':
        return Colors.grey;
      case 'hijau':
        return Colors.green;
      case 'silver':
        return Colors.grey[350]!;
      case 'kuning':
        return Colors.yellow;
      case 'orange':
        return Colors.orange;
      case 'emas':
        return AppColors.accentGold;
      default:
        return Colors.grey;
    }
  }

  Widget _buildImagePreview() {
    if (_imageUrlController.text.isEmpty) {
      return Container(
        height: 150,
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: AppColors.grey200,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.grey300),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image,
              size: 50,
              color: AppColors.grey400,
            ),
            const SizedBox(height: 10),
            Text(
              'No image selected',
              style: TextStyle(
                color: AppColors.grey500,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Add an image URL to display preview',
              style: TextStyle(
                color: AppColors.grey400,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      height: 150,
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(_imageUrlController.text),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          widget.car == null ? 'Add New Car' : 'Edit Car',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primaryBlue,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                margin: const EdgeInsets.only(bottom: 30),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryBlue, AppColors.darkBlue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryBlue.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      widget.car == null ? Icons.add_circle : Icons.edit,
                      size: 40,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.car == null
                                ? 'Add New Vehicle'
                                : 'Edit Vehicle',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.car == null
                                ? 'Fill in the details below'
                                : 'Update the vehicle information',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Image Preview
              _buildImagePreview(),

              // Image URL Field
              _buildFormField(
                label: 'Image URL',
                controller: _imageUrlController,
                icon: Icons.link,
                isRequired: false,
                validator: (value) {
                  // Optional validation for URL format
                  if (value != null && value.isNotEmpty) {
                    if (!value.startsWith('http')) {
                      return 'Please enter a valid URL (start with http/https)';
                    }
                  }
                  return null;
                },
              ),

              // Form Fields
              _buildFormField(
                label: 'Brand',
                controller: _merkController,
                icon: Icons.branding_watermark,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter car brand';
                  }
                  return null;
                },
              ),

              _buildFormField(
                label: 'Model',
                controller: _modelController,
                icon: Icons.model_training,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter car model';
                  }
                  return null;
                },
              ),

              _buildFormField(
                label: 'Year',
                controller: _tahunController,
                icon: Icons.calendar_today,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter production year';
                  }
                  final year = int.tryParse(value);
                  if (year == null ||
                      year < 1900 ||
                      year > DateTime.now().year + 1) {
                    return 'Please enter valid year (1900-${DateTime.now().year + 1})';
                  }
                  return null;
                },
              ),

              _buildFormField(
                label: 'Price (Rp)',
                controller: _hargaController,
                icon: Icons.attach_money,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter price';
                  }
                  final price = double.tryParse(value);
                  if (price == null || price <= 0) {
                    return 'Please enter valid price (> 0)';
                  }
                  return null;
                },
              ),

              _buildColorDropdown(),

              _buildFormField(
                label: 'Description',
                controller: _deskripsiController,
                icon: Icons.description,
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  if (value.length < 10) {
                    return 'Description must be at least 10 characters';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 30),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _saveCar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    shadowColor: AppColors.primaryBlue.withOpacity(0.3),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        widget.car == null ? Icons.add_circle : Icons.save,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        widget.car == null ? 'ADD CAR' : 'UPDATE CAR',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Cancel Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.grey400),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'CANCEL',
                    style: TextStyle(
                      color: AppColors.grey700,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
