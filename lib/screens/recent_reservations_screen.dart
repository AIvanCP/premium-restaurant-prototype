import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../utils/theme.dart';
import '../utils/app_provider.dart';
import '../widgets/navbar_widget.dart';

class RecentReservationsScreen extends StatefulWidget {
  const RecentReservationsScreen({Key? key}) : super(key: key);

  @override
  State<RecentReservationsScreen> createState() => _RecentReservationsScreenState();
}

class _RecentReservationsScreenState extends State<RecentReservationsScreen> {
  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final reservations = appProvider.recentReservations;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    
    print('Building RecentReservationsScreen');
    print('Loading state: ${appProvider.isLoading}');
    print('Reservations count: ${reservations.length}');
    
    // Check for loading state
    if (appProvider.isLoading) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppTheme.primaryColor,
          title: Text(
            'MY RESERVATIONS',
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
        body: const Center(
          child: CircularProgressIndicator(color: AppTheme.accentColor),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        title: Text(
          'MY RESERVATIONS',
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
      ),      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.all(screenWidth < 300 ? 12 : (screenWidth < 400 ? 16 : 24)),
            constraints: BoxConstraints(maxWidth: isMobile ? double.infinity : 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [                Text(
                  'YOUR RECENT RESERVATIONS',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: AppTheme.accentColor,
                        letterSpacing: 2,
                        fontSize: screenWidth < 300 ? 18 : (screenWidth < 400 ? 22 : null),
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Center(
                  child: Container(
                    width: 60,
                    height: 3,
                    color: AppTheme.accentColor,
                    margin: EdgeInsets.symmetric(
                      horizontal: screenWidth < 400 ? 50 : 150
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                
                if (reservations.isEmpty)
                  _buildEmptyState(context)
                else
                  _buildReservationsList(context, reservations, isMobile),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.calendar_today,
            color: AppTheme.accentColor,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'No Reservations Yet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppTheme.textPrimaryColor,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'You haven\'t made any reservations. Make your first reservation now!',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/reservation');
            },
            icon: const Icon(Icons.add),
            label: const Text('MAKE A RESERVATION'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentColor,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReservationsList(
      BuildContext context, List<Map<String, dynamic>> reservations, bool isMobile) {
    return Column(
      children: [
        for (var i = 0; i < reservations.length; i++) ...[
          _buildReservationCard(context, reservations[i], isMobile),
          if (i < reservations.length - 1) const SizedBox(height: 16),
        ],
      ],
    );
  }

  // Show confirmation dialog before cancelling
  void _showCancelConfirmation(BuildContext context, String reservationId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.cardColor,
          title: const Text('Cancel Reservation?',
            style: TextStyle(color: AppTheme.accentColor),
          ),
          content: const Text(
            'Are you sure you want to cancel this reservation? This action cannot be undone.',
            style: TextStyle(color: AppTheme.textPrimaryColor),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('NO, KEEP IT', 
                style: TextStyle(color: AppTheme.accentColor),
              ),
            ),
            ElevatedButton(              onPressed: () async {
                Navigator.of(context).pop(); // Close dialog
                
                // Store context-dependent objects before the async call
                final scaffoldMessengerState = ScaffoldMessenger.of(context);
                final navigatorState = Navigator.of(context);
                
                // Show loading indicator
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext dialogContext) {
                    return const AlertDialog(
                      backgroundColor: AppTheme.cardColor,
                      content: Row(
                        children: [
                          CircularProgressIndicator(color: AppTheme.accentColor),
                          SizedBox(width: 20),
                          Text('Cancelling reservation...',
                            style: TextStyle(color: AppTheme.textPrimaryColor),
                          ),
                        ],
                      ),
                    );
                  },
                );
                
                try {
                  // Call the cancel method
                  final appProvider = Provider.of<AppProvider>(context, listen: false);
                  final result = await appProvider.cancelReservation(reservationId);
                  
                  // Close loading dialog using stored navigator reference
                  navigatorState.pop();
                  
                  // Show success or error message using stored scaffoldMessenger reference
                  scaffoldMessengerState.showSnackBar(
                    SnackBar(
                      content: Text(
                        result ? 'Reservation successfully cancelled' : 'Failed to cancel reservation',
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: result ? Colors.green.shade800 : Colors.red.shade800,
                    ),
                  );
                } catch (e) {
                  // In case of any error, close dialog and show error message
                  navigatorState.pop();
                  scaffoldMessengerState.showSnackBar(
                    SnackBar(
                      content: const Text(
                        'An error occurred while processing the request',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.red.shade800,
                    ),
                  );
                  print('Error during reservation cancellation: $e');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade900,
              ),
              child: const Text('YES, CANCEL',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildReservationCard(
      BuildContext context, Map<String, dynamic> reservation, bool isMobile) {
    final date = reservation['date'] as DateTime;
    final formattedDate = DateFormat('EEEE, MMMM d, yyyy').format(date);
    final formattedTime = DateFormat('h:mm a').format(date);
    final statusColor = _getStatusColor(reservation['status']);
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: isMobile
          ? _buildMobileReservationCard(
              context, reservation, formattedDate, formattedTime, statusColor)
          : _buildDesktopReservationCard(
              context, reservation, formattedDate, formattedTime, statusColor),
    );
  }
  Widget _buildMobileReservationCard(
    BuildContext context,
    Map<String, dynamic> reservation,
    String formattedDate,
    String formattedTime,
    Color statusColor,
  ) {
    // Get screen dimensions for responsive sizing
    final screenWidth = MediaQuery.of(context).size.width;
    final isVerySmallScreen = screenWidth < 360;
    final isMicroScreen = screenWidth < 300;
    
    // Adjust text sizes and spacing based on screen width
    final titleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
      color: AppTheme.accentColor,
      fontWeight: FontWeight.bold,
      fontSize: isMicroScreen ? 14 : (isVerySmallScreen ? 16 : null),
    );
    
    final statusStyle = TextStyle(
      color: statusColor,
      fontWeight: FontWeight.bold,
      fontSize: isMicroScreen ? 11 : (isVerySmallScreen ? 12 : null),
    );
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Use Column instead of Row for small screens to prevent overflow
        isVerySmallScreen 
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isMicroScreen ? 'Reservation #${reservation['reservationId'].toString().substring(0, 6)}' : 'Reservation #${reservation['reservationId']}',
                style: titleStyle,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              SizedBox(height: isMicroScreen ? 6 : 8),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isMicroScreen ? 8 : 12, 
                  vertical: isMicroScreen ? 2 : 4
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  reservation['status'],
                  style: statusStyle,
                ),
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  screenWidth < 400 ? 'Reservation #${reservation['reservationId'].toString().substring(0, 8)}' : 'Reservation #${reservation['reservationId']}',
                  style: titleStyle,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth < 400 ? 8 : 12, 
                  vertical: screenWidth < 400 ? 3 : 4
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  reservation['status'],
                  style: statusStyle,
                ),
              ),
            ],
          ),
        SizedBox(height: isMicroScreen ? 12 : 16),
        _buildInfoRow(context, 'Location', reservation['location']),
        _buildInfoRow(context, 'Date', formattedDate),
        _buildInfoRow(context, 'Time', formattedTime),
        _buildInfoRow(context, 'Party Size', '${reservation['partySize']} ${reservation['partySize'] == 1 ? 'person' : 'people'}'),
        _buildInfoRow(context, 'Name', reservation['name']),
        _buildInfoRow(context, 'Email', reservation['email']),
        _buildInfoRow(context, 'Phone', reservation['phone']),
        SizedBox(height: isMicroScreen ? 12 : 16),
        // Responsive button layout
        isVerySmallScreen
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  final appProvider = Provider.of<AppProvider>(context, listen: false);
                  final reservationId = reservation['reservationId'] as String;
                  final reservationData = appProvider.getReservationById(reservationId);
                  
                  if (reservationData != null) {
                    Navigator.of(context).pushNamed(
                      '/reservation',
                      arguments: {
                        'isEditing': true,
                        'reservationData': reservationData,
                      },
                    );
                  }
                },
                icon: Icon(Icons.edit, size: isMicroScreen ? 16 : 24),
                label: Text(
                  'MODIFY',
                  style: TextStyle(fontSize: isMicroScreen ? 12 : null),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade800,
                  padding: EdgeInsets.symmetric(
                    vertical: isMicroScreen ? 8 : 12,
                  ),
                  visualDensity: isMicroScreen ? VisualDensity.compact : null,
                ),
              ),
              SizedBox(height: isMicroScreen ? 6 : 8),
              ElevatedButton.icon(
                onPressed: () {
                  _showCancelConfirmation(context, reservation['reservationId'] as String);
                },
                icon: Icon(Icons.cancel, size: isMicroScreen ? 16 : 24),
                label: Text(
                  'CANCEL',
                  style: TextStyle(fontSize: isMicroScreen ? 12 : null),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade900,
                  padding: EdgeInsets.symmetric(
                    vertical: isMicroScreen ? 8 : 12,
                  ),
                  visualDensity: isMicroScreen ? VisualDensity.compact : null,
                ),
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  final appProvider = Provider.of<AppProvider>(context, listen: false);
                  final reservationId = reservation['reservationId'] as String;
                  final reservationData = appProvider.getReservationById(reservationId);
                  
                  if (reservationData != null) {
                    Navigator.of(context).pushNamed(
                      '/reservation',
                      arguments: {
                        'isEditing': true,
                        'reservationData': reservationData,
                      },
                    );
                  }
                },
                icon: Icon(Icons.edit, size: screenWidth < 400 ? 18 : 24),
                label: Text(
                  screenWidth < 400 ? 'EDIT' : 'MODIFY',
                  style: TextStyle(fontSize: screenWidth < 400 ? 13 : null),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade800,
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth < 400 ? 10 : 16,
                    vertical: screenWidth < 400 ? 8 : 12,
                  ),
                  visualDensity: screenWidth < 400 ? VisualDensity.compact : null,
                ),
              ),
              SizedBox(width: screenWidth < 400 ? 6 : 8),
              ElevatedButton.icon(
                onPressed: () {
                  _showCancelConfirmation(context, reservation['reservationId'] as String);
                },
                icon: Icon(Icons.cancel, size: screenWidth < 400 ? 18 : 24),
                label: Text(
                  'CANCEL',
                  style: TextStyle(fontSize: screenWidth < 400 ? 13 : null),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade900,
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth < 400 ? 10 : 16,
                    vertical: screenWidth < 400 ? 8 : 12,
                  ),
                  visualDensity: screenWidth < 400 ? VisualDensity.compact : null,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildDesktopReservationCard(
    BuildContext context,
    Map<String, dynamic> reservation,
    String formattedDate,
    String formattedTime,
    Color statusColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Reservation #${reservation['reservationId']}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.accentColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                reservation['status'],
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(context, 'Location', reservation['location']),
                  _buildInfoRow(context, 'Date', formattedDate),
                  _buildInfoRow(context, 'Time', formattedTime),
                  _buildInfoRow(
                      context, 'Party Size', '${reservation['partySize']} people'),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(context, 'Name', reservation['name']),
                  _buildInfoRow(context, 'Email', reservation['email']),
                  _buildInfoRow(context, 'Phone', reservation['phone']),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                final appProvider = Provider.of<AppProvider>(context, listen: false);
                final reservationId = reservation['reservationId'] as String;
                final reservationData = appProvider.getReservationById(reservationId);
                
                if (reservationData != null) {
                  Navigator.of(context).pushNamed(
                    '/reservation',
                    arguments: {
                      'isEditing': true,
                      'reservationData': reservationData,
                    },
                  );
                }
              },
              icon: const Icon(Icons.edit),
              label: const Text('MODIFY'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade800,
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: () {
                _showCancelConfirmation(context, reservation['reservationId'] as String);
              },
              icon: const Icon(Icons.cancel),
              label: const Text('CANCEL'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade900,
              ),
            ),
          ],
        ),
      ],
    );
  }  Widget _buildInfoRow(BuildContext context, String label, String value) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isVerySmallScreen = screenWidth < 360;
    final isMicroScreen = screenWidth < 300;
    
    // On very small screens, stack label and value vertically with smaller text
    if (isVerySmallScreen) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: isMicroScreen ? 2 : 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$label:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade400,
                    fontSize: isMicroScreen ? 12 : null,
                  ),
            ),
            SizedBox(height: isMicroScreen ? 1 : 2),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textPrimaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: isMicroScreen ? 12 : null,
                  ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ],
        ),
      );
    }
    
    // Standard layout for larger screens with responsive width
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth < 400 ? 3 : 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: screenWidth < 400 ? 70 : (screenWidth < 500 ? 80 : 100),
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade400,
                    fontSize: screenWidth < 400 ? 13 : null,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textPrimaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: screenWidth < 400 ? 13 : null,
                  ),
              overflow: TextOverflow.ellipsis,
              maxLines: screenWidth < 350 ? 3 : 2,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}
