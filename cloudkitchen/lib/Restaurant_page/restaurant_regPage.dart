import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';
import 'package:geolocator/geolocator.dart';
import 'package:cloudkitchen/Restaurant_page/services/imgPicker_service.dart';
import 'package:cloudkitchen/Restaurant_page/services/location_service.dart';
import 'package:cloudkitchen/Restaurant_page/services/timePicker_service.dart';
import 'widgets/foodPref_widget.dart';
import 'widgets/imgPicker_widget.dart';
import 'widgets/formField_widget.dart';
import 'widgets/textfield_widget.dart';
import 'widgets/timePicker_widget.dart';




class RestrauntRegPage extends StatefulWidget {
  const RestrauntRegPage({super.key});

  @override
  State<RestrauntRegPage> createState() => _RestrauntRegPageState();
}

class _RestrauntRegPageState extends State<RestrauntRegPage> {
  // Controllers
  final TextEditingController restaurantNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController coordinatesController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();
  final TextEditingController urlController = TextEditingController();
  final TextEditingController policyController = TextEditingController();

  // Form state variables
  String? _selectedFoodPreference;
  File? _selectedImage;
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
            _buildHeader(),
            _buildRestaurantNameField(),
            _buildFoodPreferenceField(),
            _buildPhoneNumberField(),
            _buildImagePickerField(),
            _buildDeliveryTimeField(),
            _buildOpenTimeField(),
            _buildCloseTimeField(),
            _buildLocationField(),
            _buildPinCodeField(),
            _buildUrlField(),
            _buildPolicyField(),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
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
      ],
    );
  }

  Widget _buildRestaurantNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormFieldLabel(text: 'Restaurant Name', isRequired: true),
        SizedBox(height: 8),
        CustomTextField(
          controller: restaurantNameController,
          hintText: 'Enter restaurant name',
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildFoodPreferenceField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormFieldLabel(text: 'Food Preference', isRequired: true),
        const SizedBox(height: 8),
        FoodPreferenceSelector(
          selectedValue: _selectedFoodPreference,
          onChanged: (String? value) {
            setState(() {
              _selectedFoodPreference = value;
            });
          },
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPhoneNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormFieldLabel(text: 'Restaurant Number', isRequired: true),
        SizedBox(height: 8),
        CustomTextField(
          controller: phoneController,
          hintText: 'Enter phone number',
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildImagePickerField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormFieldLabel(text: 'Upload Restaurant photo', isRequired: true),
        SizedBox(height: 8),
        ImagePickerWidget(
          selectedImage: _selectedImage,
          webImage: _webImage,
          onPickImage: _pickImage,
          onDeleteImage: _deleteImage,
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDeliveryTimeField() {
    return TimePickerField(
      label: 'Average Time to Deliver Food *',
      time: deliveryTime,
      onTap: () => _selectTime('delivery'),
    );
  }

  Widget _buildOpenTimeField() {
    return Column(
      children: [
        const SizedBox(height: 16),
        TimePickerField(
          label: 'Restaurant Open Time *',
          time: openTime,
          onTap: () => _selectTime('open'),
        ),
      ],
    );
  }

  Widget _buildCloseTimeField() {
    return Column(
      children: [
        const SizedBox(height: 16),
        TimePickerField(
          label: 'Restaurant Close Time *',
          time: closeTime,
          onTap: () => _selectTime('close'),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildLocationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormFieldLabel(text: 'Fetch your latitude and longitude', isRequired: true),
        SizedBox(height: 8),
        GestureDetector(
          onTap: _fetchCurrentLocation,
          child: AbsorbPointer(
            child: CustomTextField(
              controller: coordinatesController,
              hintText: 'Tap to fetch current location',
              suffixIcon: Icon(Icons.fullscreen_exit_rounded),
              errorText: coordinatesError,
              readOnly: true,
            ),
          ),
        ),
        SizedBox(height: 8),
        Text('Make sure your at restaurant location'),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildPinCodeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormFieldLabel(text: 'Pin code', isRequired: true),
        SizedBox(height: 8),
        CustomTextField(
          controller: pinCodeController,
          hintText: 'Enter pin code',
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildUrlField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormFieldLabel(text: 'Google Map Location URL', isRequired: true),
        SizedBox(height: 10),
        CustomTextField(
          controller: urlController,
          hintText: 'Paste your google map url here',
        ),
        SizedBox(height: 8),
        Text('Copy from google map and paste here'),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _buildPolicyField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormFieldLabel(text: 'Restaurant Policy', isRequired: true),
        SizedBox(height: 8),
        CustomTextField(
          controller: policyController,
          hintText: 'Enter Policy',
          maxLines: null,
          expands: true,
          height: 150.0,
        ),
        SizedBox(height: 18),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Container(
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
    );
  }

  // Location related methods
  Future<void> _fetchCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
      coordinatesError = null;
      _manualInputEnabled = false;
    });

    try {
      bool serviceEnabled = await LocationService.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          coordinatesError = "Location services are disabled. Please enable them.";
          _isLoadingLocation = false;
        });
        return;
      }

      bool hasPermission = await LocationService.requestLocationPermission();
      if (!hasPermission) {
        setState(() {
          coordinatesError = "Location permission denied.";
          _isLoadingLocation = false;
        });
        return;
      }

      Position position = await LocationService.getCurrentPosition();
      double currentLat = position.latitude;
      double currentLng = position.longitude;

      setState(() {
        latitude = currentLat;
        longitude = currentLng;
        coordinatesController.text = LocationService.formatCoordinatesWithDirections(
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

  // Image picker methods
  Future<void> _pickImage() async {
    ImagePickerService.showImagePickerBottomSheet(
      context: context,
      onImageSourceSelected: _getImage,
      onRemoveImage: _removeImage,
      hasExistingImage: (kIsWeb && _webImage != null) || (!kIsWeb && _selectedImage != null),
    );
  }

  Future<void> _getImage(ImageSource source) async {
    try {
      final result = await ImagePickerService.pickImage(source);
      if (result != null) {
        setState(() {
          _webImage = result['webImage'];
          _selectedImage = result['selectedImage'];
        });
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

  void _removeImage() {
    setState(() {
      _selectedImage = null;
      _webImage = null;
    });
  }

  void _deleteImage() {
    setState(() {
      _webImage = null;
      _selectedImage = null;
    });
  }

  // Time picker methods
  Future<void> _selectTime(String timeType) async {
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

    final TimeOfDay? picked = await TimePickerService.selectTime(
      context: context,
      initialTime: initialTime,
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

  @override
  void dispose() {
    restaurantNameController.dispose();
    phoneController.dispose();
    coordinatesController.dispose();
    pinCodeController.dispose();
    urlController.dispose();
    policyController.dispose();
    super.dispose();
  }
}