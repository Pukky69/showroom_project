import 'package:flutter/material.dart';
import 'package:showroom_mobil/services/auth_service.dart';
import 'package:showroom_mobil/services/api_service.dart';
import 'package:showroom_mobil/models/car.dart';
import 'package:showroom_mobil/screens/car_form_screen.dart';
import 'package:showroom_mobil/screens/login_screen.dart';
import 'package:showroom_mobil/screens/car_detail_screen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:showroom_mobil/constants/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Car> _cars = [];
  bool _isLoading = true;
  bool _isAdmin = false;
  String _username = '';
  int _selectedCategory = 0;
  final List<String> _categories = ['All', 'Sedan', 'SUV', 'Sport', 'Luxury'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final userData = await AuthService.getUserData();
    if (userData != null) {
      _isAdmin = userData['isAdmin'] ?? false;
      _username = userData['username'] ?? '';
    }

    await _fetchCars();
    setState(() => _isLoading = false);
  }

  Future<void> _fetchCars() async {
    final cars = await ApiService.getCars();
    setState(() => _cars = cars);
  }

  List<Car> get _filteredCars {
    var filtered = _cars;

    // Filter by category (using merk/model as category proxy)
    if (_selectedCategory > 0) {
      final category = _categories[_selectedCategory].toLowerCase();
      filtered = filtered.where((car) {
        final merkModel = '${car.merk} ${car.model}'.toLowerCase();
        // This is simplified - in real app you'd have a category field
        return merkModel.contains(category) ||
            car.deskripsi.toLowerCase().contains(category);
      }).toList();
    }

    return filtered;
  }

  Future<void> _logout() async {
    await AuthService.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  Widget _buildCarCard(Car car, int index) {
    return Container(
      margin: EdgeInsets.fromLTRB(
          16, 8, 16, index == _filteredCars.length - 1 ? 80 : 8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CarDetailScreen(car: car),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              // Car Image/Header
              Container(
                height: 140,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryBlue.withOpacity(0.8),
                      AppColors.darkBlue
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: 20,
                      top: 20,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.accentGold,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${car.tahun}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.directions_car,
                            size: 60,
                            color: Colors.white.withOpacity(0.9),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            car.merk.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Car Details
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                car.model,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.navyBlue,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    margin: const EdgeInsets.only(right: 6),
                                    decoration: BoxDecoration(
                                      color: _getColorFromString(car.warna),
                                      shape: BoxShape.circle,
                                      border:
                                          Border.all(color: AppColors.grey300),
                                    ),
                                  ),
                                  Text(
                                    car.warna,
                                    style: TextStyle(
                                      color: AppColors.grey600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'STARTING FROM',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.grey500,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Rp ${_formatPrice(car.harga)}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Description Preview
                    Text(
                      car.deskripsi.length > 100
                          ? '${car.deskripsi.substring(0, 100)}...'
                          : car.deskripsi,
                      style: TextStyle(
                        color: AppColors.grey600,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.grey100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.remove_red_eye,
                                size: 16,
                                color: AppColors.primaryBlue,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'View Details',
                                style: TextStyle(
                                  color: AppColors.primaryBlue,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_isAdmin)
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CarFormScreen(car: car),
                                    ),
                                  ).then((_) => _fetchCars());
                                },
                                icon: Icon(Icons.edit,
                                    color: AppColors.primaryBlue),
                              ),
                              IconButton(
                                onPressed: () => _deleteCar(car.id!),
                                icon: Icon(Icons.delete,
                                    color: AppColors.accentRed),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getColorFromString(String warna) {
    final colorMap = {
      'merah': Colors.red,
      'biru': Colors.blue,
      'hitam': Colors.black,
      'putih': Colors.white,
      'abu': Colors.grey,
      'hijau': Colors.green,
      'silver': Colors.grey[350]!,
      'kuning': Colors.yellow,
      'orange': Colors.orange,
      'emas': AppColors.accentGold,
    };
    return colorMap[warna.toLowerCase()] ?? Colors.grey;
  }

  String _formatPrice(double price) {
    if (price >= 1000000000) {
      return '${(price / 1000000000).toStringAsFixed(1)}B';
    } else if (price >= 1000000) {
      return '${(price / 1000000).toStringAsFixed(1)}M';
    }
    return price.toStringAsFixed(0);
  }

  Future<void> _deleteCar(String id) async {
    final confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Car', style: TextStyle(color: AppColors.navyBlue)),
        content: const Text('Are you sure you want to delete this car?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('CANCEL', style: TextStyle(color: AppColors.grey600)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentRed,
            ),
            child: const Text('DELETE'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      EasyLoading.show(status: 'Deleting...');
      final success = await ApiService.deleteCar(id);

      if (success) {
        EasyLoading.showSuccess('Car deleted!');
        await _fetchCars();
      } else {
        EasyLoading.showError('Failed to delete');
      }
    }
  }

  Widget _buildCategoryChip(int index) {
    return Padding(
      padding: EdgeInsets.only(
          left: index == 0 ? 16 : 8,
          right: index == _categories.length - 1 ? 16 : 0),
      child: ChoiceChip(
        label: Text(_categories[index]),
        selected: _selectedCategory == index,
        selectedColor: AppColors.primaryBlue,
        labelStyle: TextStyle(
          color: _selectedCategory == index ? Colors.white : AppColors.grey700,
          fontWeight: FontWeight.w500,
        ),
        backgroundColor: AppColors.grey100,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = selected ? index : 0;
          });
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            // App Bar - SIMPLIFIED VERSION
            SliverAppBar(
              expandedHeight: 140, // Dikurangi
              floating: true,
              pinned: true,
              backgroundColor: Colors.white,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Welcome,',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    _username,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              CircleAvatar(
                                backgroundColor: Colors.white.withOpacity(0.2),
                                child: IconButton(
                                  onPressed: _logout,
                                  icon: const Icon(Icons.logout,
                                      color: Colors.white, size: 20),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Premium Car Collection',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Category Chips
            SliverToBoxAdapter(
              child: Container(
                height: 60,
                color: Colors.white,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  itemBuilder: (context, index) => _buildCategoryChip(index),
                ),
              ),
            ),

            // Header
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Available Cars',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navyBlue,
                      ),
                    ),
                    Text(
                      '${_filteredCars.length} cars',
                      style: TextStyle(
                        color: AppColors.grey600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: _isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: AppColors.primaryBlue),
                    const SizedBox(height: 20),
                    Text(
                      'Loading showroom...',
                      style: TextStyle(color: AppColors.grey600),
                    ),
                  ],
                ),
              )
            : _filteredCars.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.directions_car_outlined,
                          size: 80,
                          color: AppColors.grey300,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'No cars found',
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.grey600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Try different category',
                          style: TextStyle(color: AppColors.grey500),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _fetchCars,
                    backgroundColor: AppColors.backgroundLight,
                    color: AppColors.primaryBlue,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: _filteredCars.length,
                      itemBuilder: (context, index) {
                        return _buildCarCard(_filteredCars[index], index);
                      },
                    ),
                  ),
      ),
      floatingActionButton: _isAdmin
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CarFormScreen(),
                  ),
                ).then((_) => _fetchCars());
              },
              backgroundColor: AppColors.accentGold,
              foregroundColor: Colors.black,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.add, size: 28),
            )
          : null,
    );
  }
}
