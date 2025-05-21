import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../utils/theme.dart';
import '../utils/app_provider.dart';

class ReservationScreen extends StatefulWidget {
  final String? preselectedLocation;

  const ReservationScreen({Key? key, this.preselectedLocation}) : super(key: key);

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  
  String? _selectedLocation;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 19, minute: 0);
  int _partySize = 2;
  
  bool _isSubmitting = false;
  bool _isSuccess = false;
  String? _errorMessage;
  
  // For editing existing reservations
  bool _isEditing = false;
  String? _reservationId;
  
  final List<int> _partySizeOptions = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  
  @override
  void initState() {
    super.initState();
    
    // If a location was preselected (from locations screen)
    if (widget.preselectedLocation != null) {
      _selectedLocation = widget.preselectedLocation;
    }
    
    // Check if we're editing an existing reservation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is Map<String, dynamic>) {
        if (args['isEditing'] == true && args['reservationData'] != null) {
          final reservationData = args['reservationData'] as Map<String, dynamic>;
          _loadReservationData(reservationData);
        }
      }
    });
  }
  
  void _loadReservationData(Map<String, dynamic> data) {
    final date = data['date'] as DateTime;
    
    setState(() {
      _isEditing = true;
      _reservationId = data['reservationId'] as String;
      _nameController.text = data['name'] as String;
      _emailController.text = data['email'] as String;
      _phoneController.text = data['phone'] as String;
      _selectedLocation = data['location'] as String;
      _selectedDate = DateTime(date.year, date.month, date.day);
      _selectedTime = TimeOfDay(hour: date.hour, minute: date.minute);
      _partySize = data['partySize'] as int;
    });
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }  
  // Format date and time for reservation confirmation
  String _formatReservationDateTime() {
    final date = DateFormat('EEEE, MMMM d, yyyy').format(_selectedDate);
    final time = _selectedTime.format(context);
    return '$date at $time';
  }
  
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
        _errorMessage = null;
      });
      
      try {
        final appProvider = Provider.of<AppProvider>(context, listen: false);
        
        // Convert DateTime and TimeOfDay to a single DateTime
        final reservationDateTime = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          _selectedTime.hour,
          _selectedTime.minute,
        );
        
        final success = _isEditing
            ? await appProvider.updateReservation(
                reservationId: _reservationId!,
                name: _nameController.text,
                email: _emailController.text,
                phone: _phoneController.text,
                location: _selectedLocation!,
                date: reservationDateTime,
                partySize: _partySize,
              )
            : await appProvider.requestReservation(
                name: _nameController.text,
                email: _emailController.text,
                phone: _phoneController.text,
                location: _selectedLocation!,
                date: reservationDateTime,
                partySize: _partySize,
              );
        
        setState(() {
          _isSubmitting = false;
          _isSuccess = success;
          if (!success && appProvider.errorMessage != null) {
            _errorMessage = appProvider.errorMessage;
          }
        });
        
        if (success) {
          // Clear form after successful submission
          if (mounted) {
            _formKey.currentState?.reset();
            _nameController.clear();
            _emailController.clear();
            _phoneController.clear();
          }
        }
      } catch (e) {
        setState(() {
          _isSubmitting = false;
          _errorMessage = 'An unexpected error occurred: $e';
        });
      }
    }
  }
  
  Future<void> _selectDate(BuildContext context) async {
    // Only allow reservations from tomorrow up to 3 months in advance
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final threeMonthsLater = DateTime.now().add(const Duration(days: 90));
    
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: tomorrow,
      lastDate: threeMonthsLater,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppTheme.accentColor,
              onPrimary: Colors.black,
              surface: AppTheme.cardColor,
              onSurface: AppTheme.textPrimaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
  
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppTheme.accentColor,
              onPrimary: Colors.black,
              surface: AppTheme.cardColor,
              onSurface: AppTheme.textPrimaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final locations = appProvider.getLocations();
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        title: Text(
          _isEditing ? 'EDIT RESERVATION' : 'MAKE A RESERVATION',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.accentColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.accentColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            constraints: BoxConstraints(maxWidth: isMobile ? double.infinity : 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Success message
                if (_isSuccess)
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: Colors.green.shade900,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.check_circle_outline,
                          color: Colors.white,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Reservation Request Submitted!',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                          textAlign: TextAlign.center,
                        ),                        const SizedBox(height: 8),
                        Text(
                          'We will confirm your reservation shortly.',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.white,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Location: $_selectedLocation\nDate: ${DateFormat('EEEE, MMMM d, yyyy').format(_selectedDate)}\nTime: ${_selectedTime.format(context)}\nParty Size: $_partySize ${_partySize == 1 ? 'person' : 'people'}',                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.white,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _isSuccess = false;
                                  });
                                },
                                child: const Text('MAKE ANOTHER RESERVATION'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed('/recent-reservations');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.accentColor,
                                  foregroundColor: Colors.black,
                                ),
                                child: const Text('VIEW MY RESERVATIONS'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                
                // Error message
                if (_errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: Colors.red.shade900,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.white,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _errorMessage!,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.white,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _errorMessage = null;
                            });
                          },
                          child: const Text('TRY AGAIN'),
                        ),
                      ],
                    ),
                  ),
                
                // Reservation form
                if (!_isSuccess)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [                      Text(
                        _isEditing ? 'EDIT YOUR RESERVATION' : 'RESERVE YOUR TABLE',
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              color: AppTheme.accentColor,
                              letterSpacing: 2,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: 60,
                        height: 3,
                        color: AppTheme.accentColor,
                        margin: const EdgeInsets.symmetric(horizontal: 150),
                      ),
                      const SizedBox(height: 32),
                      
                      Text(
                        'Please fill out the form below to request a reservation. We recommend booking at least 24 hours in advance.',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      
                      // The form
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Contact information
                            Text(
                              'CONTACT INFORMATION',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppTheme.accentColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            
                            // Name field
                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Full Name',
                                hintText: 'Enter your full name',
                                prefixIcon: Icon(Icons.person),
                                filled: true,
                                fillColor: AppTheme.cardColor,
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            
                            // Email field
                            TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                hintText: 'Enter your email address',
                                prefixIcon: Icon(Icons.email),
                                filled: true,
                                fillColor: AppTheme.cardColor,
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            
                            // Phone field
                            TextFormField(
                              controller: _phoneController,
                              decoration: const InputDecoration(
                                labelText: 'Phone Number',
                                hintText: 'Enter your phone number',
                                prefixIcon: Icon(Icons.phone),
                                filled: true,
                                fillColor: AppTheme.cardColor,
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your phone number';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 32),
                            
                            // Reservation details
                            Text(
                              'RESERVATION DETAILS',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppTheme.accentColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            
                            // Location dropdown
                            DropdownButtonFormField<String>(
                              value: _selectedLocation,
                              decoration: const InputDecoration(
                                labelText: 'Location',
                                prefixIcon: Icon(Icons.location_on),
                                filled: true,
                                fillColor: AppTheme.cardColor,
                                border: OutlineInputBorder(),
                              ),
                              items: locations
                                  .map((location) => DropdownMenuItem(
                                        value: location.name,
                                        child: Text(location.name),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedLocation = value;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a location';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            
                            // Date and time
                            Row(
                              children: [
                                // Date picker
                                Expanded(
                                  child: InkWell(
                                    onTap: () => _selectDate(context),
                                    child: InputDecorator(
                                      decoration: const InputDecoration(
                                        labelText: 'Date',
                                        prefixIcon: Icon(Icons.calendar_today),
                                        filled: true,
                                        fillColor: AppTheme.cardColor,
                                        border: OutlineInputBorder(),
                                      ),
                                      child: Text(
                                        DateFormat('EEE, MMM d, yyyy').format(_selectedDate),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                
                                // Time picker
                                Expanded(
                                  child: InkWell(
                                    onTap: () => _selectTime(context),
                                    child: InputDecorator(
                                      decoration: const InputDecoration(
                                        labelText: 'Time',
                                        prefixIcon: Icon(Icons.access_time),
                                        filled: true,
                                        fillColor: AppTheme.cardColor,
                                        border: OutlineInputBorder(),
                                      ),
                                      child: Text(
                                        _selectedTime.format(context),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            
                            // Party size
                            DropdownButtonFormField<int>(
                              value: _partySize,
                              decoration: const InputDecoration(
                                labelText: 'Party Size',
                                prefixIcon: Icon(Icons.group),
                                filled: true,
                                fillColor: AppTheme.cardColor,
                                border: OutlineInputBorder(),
                              ),
                              items: _partySizeOptions
                                  .map((size) => DropdownMenuItem(
                                        value: size,
                                        child: Text('$size ${size == 1 ? 'person' : 'people'}'),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _partySize = value;
                                  });
                                }
                              },
                            ),
                            const SizedBox(height: 32),
                            
                            // Special requests (optional)
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Special Requests (Optional)',
                                hintText: 'Any dietary restrictions or special occasions?',
                                filled: true,
                                fillColor: AppTheme.cardColor,
                                border: OutlineInputBorder(),
                              ),
                              maxLines: 3,
                            ),
                            const SizedBox(height: 32),
                            
                            // Submit button
                            SizedBox(
                              height: 56,
                              child: ElevatedButton(
                                onPressed: _isSubmitting ? null : _submitForm,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.accentColor,
                                  foregroundColor: Colors.black,
                                ),
                                child: _isSubmitting
                                    ? const CircularProgressIndicator(
                                        color: Colors.black,
                                      )
                                    : Text(
                                        _isEditing ? 'UPDATE RESERVATION' : 'REQUEST RESERVATION',
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
