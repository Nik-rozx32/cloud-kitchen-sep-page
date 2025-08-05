import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';
import 'package:geolocator/geolocator.dart';

class RestrauntRegPage extends StatefulWidget {
  const RestrauntRegPage({super.key});

  @override
  State<RestrauntRegPage> createState() => _RestrauntRegPageState();
}

class _RestrauntRegPageState extends State<RestrauntRegPage> {
  final TextEditingController restaurantNameController =
      TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController coordinatesController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();
  final TextEditingController urlController = TextEditingController();
  final TextEditingController policyController = TextEditingController();


  String? _selectedFoodPreference;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  Uint8List? _webImage;

  TimeOfDay? deliveryTime;
  TimeOfDay? openTime;
  TimeOfDay? closeTime;

  String? coordinatesError;
  double? latitude;
  double? longitude;
  bool _isLoadingLocation = false;
  bool _manualInputEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 18),
            Container(
              height: 50,
              width: 110,
              child: SvgPicture.asset(
                'lib/assets/Icon.svg',
                width: 60,
                height: 90,
                fit: BoxFit.fill,
              ),
            ),

            SizedBox(height: 18),
            Text(
              'Restaurant Registration',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            SizedBox(height: 18),
            Text('Restaurant Name*'),
            SizedBox(height: 8),
            TextField(
              controller: restaurantNameController,
              decoration: InputDecoration(
                hintText: 'Enter restaurant name',
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Text('Food Preference*'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Radio<String>(
                        value: 'veg',
                        groupValue: _selectedFoodPreference,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedFoodPreference = value;
                          });
                        },
                      ),
                      Text('Veg'),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Radio<String>(
                        value: 'non-veg',
                        groupValue: _selectedFoodPreference,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedFoodPreference = value;
                          });
                        },
                      ),
                      Text('Non-Veg'),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Radio<String>(
                        value: 'both',
                        groupValue: _selectedFoodPreference,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedFoodPreference = value;
                          });
                        },
                      ),
                      Text('Both'),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text('Restaurant Number*'),
            SizedBox(height: 8),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'Enter phone number',
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Text('Upload Restaurant photo*'),
            SizedBox(height: 8),
            Row(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: _hasImage() ? 120 : 50,
                        width: _hasImage() ? 180 : 50,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[50],
                        ),
                        child: _hasImage()
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: _buildImage(),
                              )
                            : Icon(
                                Icons.add,
                                size: 20,
                                color: Colors.grey[600],
                              ),
                      ),
                    ),

                    if (_hasImage()) ...[
                      SizedBox(width: 8),
                      GestureDetector(
                        onTap: _deleteImage,
                        child: Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),

            _buildTimeField(
              label: 'Average Time to Deliver Food *',
              time: deliveryTime,
              onTap: () => _selectTime(context, 'delivery'),
            ),
            const SizedBox(height: 16),

            _buildTimeField(
              label: 'Restaurant Open Time *',
              time: openTime,
              onTap: () => _selectTime(context, 'open'),
            ),
            const SizedBox(height: 16),

            _buildTimeField(
              label: 'Restaurant Close Time *',
              time: closeTime,
              onTap: () => _selectTime(context, 'close'),
            ),
            const SizedBox(height: 24),
            Text(
              'Restaurant Location*',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            GestureDetector(
              onTap: _fetchCurrentLocation,
              child: AbsorbPointer(
                child: TextField(
                  controller: coordinatesController,
                  decoration: InputDecoration(
                    hintText: 'Tap to fetch current location',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    suffixIcon: Icon(Icons.fullscreen_exit_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    errorText: coordinatesError,
                  ),
                ),
              ),
            ),

            SizedBox(height: 8),
            Text('Make sure your at restaurant location'),
            SizedBox(height: 10),
            Text(
              'Pin code *',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            TextField(
              keyboardType: TextInputType.phone,
              controller: pinCodeController,
              decoration: InputDecoration(
                hintText: 'Enter pin code',
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Google Map Location URL *',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: urlController,
              decoration: InputDecoration(
                hintText: 'Paste your google map url here',
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text('Copy from google map and paste here'),
            SizedBox(height: 8),
            Text(
              'Restaurant Policy *',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 150.0,
              child: TextField(
                controller: policyController,
                style: TextStyle(fontSize: 14.0),
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: 'Enter Policy',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  contentPadding: EdgeInsets.all(16.0),
                  alignLabelWithHint: true,
                ),
              ),
            ),
            SizedBox(height: 18),
            Container(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF45C3FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Submit For Verification',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _fetchCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
      coordinatesError = null;
      _manualInputEnabled = false;
    });

    try {
      bool serviceEnabled = await _isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          coordinatesError =
              "Location services are disabled. Please enable them.";
          _isLoadingLocation = false;
        });
        return;
      }

      bool hasPermission = await _requestLocationPermission();
      if (!hasPermission) {
        setState(() {
          coordinatesError = "Location permission denied.";
          _isLoadingLocation = false;
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      double currentLat = position.latitude;
      double currentLng = position.longitude;

      setState(() {
        latitude = currentLat;
        longitude = currentLng;
        coordinatesController.text = _formatCoordinatesWithDirections(
          currentLat,
          currentLng,
        );
        _isLoadingLocation = false;
      });
    } catch (e) {
      setState(() {
        coordinatesError = "Error fetching location: ${e.toString()}";
        _isLoadingLocation = false;
      });
    }
  }

  String _formatCoordinatesWithDirections(double lat, double lng) {
    String latDir = lat >= 0 ? 'N' : 'S';
    String lngDir = lng >= 0 ? 'E' : 'W';
    return '${lat.abs().toStringAsFixed(4)}° $latDir ${lng.abs().toStringAsFixed(4)}° $lngDir';
  }

  Future<bool> _isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  Future<bool> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission != LocationPermission.denied &&
        permission != LocationPermission.deniedForever;
  }

  bool _hasImage() {
    return (kIsWeb && _webImage != null) || (!kIsWeb && _selectedImage != null);
  }

  Widget _buildImage() {
    if (kIsWeb) {
      return Image.memory(
        _webImage!,
        width: 120,
        height: double.infinity,
        fit: BoxFit.cover,
      );
    } else {
      return Image.file(
        _selectedImage!,
        width: 120,
        height: double.infinity,
        fit: BoxFit.cover,
      );
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
      _webImage = null;
    });
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _getImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Take a Picture'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _getImage(ImageSource.camera);
                },
              ),
              if (_hasImage())
                ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: Text(
                    'Remove Photo',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    _removeImage();
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _getImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 600,
        imageQuality: 80,
      );

      if (image != null) {
        if (kIsWeb) {
          final bytes = await image.readAsBytes();
          setState(() {
            _webImage = bytes;
            _selectedImage = null;
          });
        } else {
          setState(() {
            _selectedImage = File(image.path);
            _webImage = null;
          });
        }
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error selecting image. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildTimeField({
    required String label,
    required TimeOfDay? time,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatTime(time),
                  style: TextStyle(
                    fontSize: 16,
                    color: time != null ? Colors.black87 : Colors.grey[400],
                  ),
                ),
                Icon(Icons.access_time, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return 'Select time';

    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> _selectTime(BuildContext context, String timeType) async {
  TimeOfDay? initialTime;

  switch (timeType) {
    case 'delivery':
      initialTime = deliveryTime;
      break;
    case 'open':
      initialTime = openTime;
      break;
    case 'close':
      initialTime = closeTime;
      break;
  }

  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: initialTime ?? TimeOfDay.now(),
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: Color(0xFF45C3FF),
            onPrimary: Colors.white,
            onSurface: Colors.black,
          ),
          timePickerTheme: TimePickerThemeData(
            backgroundColor: Colors.white,
            hourMinuteTextColor: Colors.black,
            dialHandColor: Color(0xFF45C3FF),
            dialBackgroundColor: Colors.deepPurple.shade50,
            entryModeIconColor: Color(0xFF45C3FF),
          ),
        ),
        child: child!,
      );
    },
  );

  if (picked != null) {
    setState(() {
      switch (timeType) {
        case 'delivery':
          deliveryTime = picked;
          break;
        case 'open':
          openTime = picked;
          break;
        case 'close':
          closeTime = picked;
          break;
      }
    });
  }
}


  void _deleteImage() {
    setState(() {
      _webImage = null;
    });
  }

  @override
  void dispose() {
    restaurantNameController.dispose();
    phoneController.dispose();
    coordinatesController.dispose();
    super.dispose();
  }
}
