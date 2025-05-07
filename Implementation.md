# Ride-Sharing App Implementation Guide for Flutter Developers

## Overview

This guide explains how to implement the user and driver mobile apps using Flutter for a ride-sharing platform. You'll be connecting to an existing backend - you don't need to set up any servers.

## Complete Ride Flow Diagram

### User Perspective
```
User Request → Finding Driver → Driver Assigned → Driver En Route → Driver Arrived → 
Ride Started → Ride Completed → Payment & Rating
```

### Driver Perspective
```
Driver Online → Receives Request → Accepts/Rejects → En Route to Pickup → 
Arrived at Pickup → Started Ride → Completes Ride → Payment Confirmation
```

## WebSocket Connection Setup

### 1. Installation
First, add the required packages to your `pubspec.yaml`:

```yaml
dependencies:
  socket_io_client: ^2.0.0
  http: ^0.13.5
```

### 2. Initial WebSocket Connection (for both User and Driver)

```dart
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;
  
  void connectSocket(String token, String socketUrl) {
    socket = IO.io(socketUrl, <String, dynamic>{
      'auth': {'token': token},
      'transports': ['websocket'],
      'autoConnect': false,
    });
    
    socket.connect();
    
    socket.onConnect((_) {
      print('Connected to socket server');
    });
    
    socket.onDisconnect((_) {
      print('Disconnected from socket server');
    });
  }
}
```

## User App Implementation

### User Authentication Flow
1. User enters token and logs in
2. Store token locally (SharedPreferences)
3. Connect to WebSocket server with token
4. Switch to user interface

### User WebSocket Events

**Events to Listen For:**
- `ride_status_updated` - When your ride status changes
- `driver_location_update` - Real-time driver location
- `ride_message` - Messages from the driver

```dart
// User socket setup
void setupUserSocket() {
  // Listen for ride status updates
  socket.on('ride_status_updated', (data) {
    print('Ride status: ${data['status']}');
    // Update UI: Show new status
    updateRideStatus(data['status']);
  });
  
  // Listen for driver location
  socket.on('driver_location_update', (data) {
    // Update map: Show driver's current location
    updateDriverLocation(data['coordinates']);
  });
  
  // Listen for messages
  socket.on('ride_message', (data) {
    // Show notification
    showNotification('Driver message: ${data['text']}');
  });
}
```

### User Ride Request Flow

1. **Request a Ride:**
```dart
Future<void> requestRide() async {
  var request = {
    'pickupLocation': 'Central Park',
    'dropoffLocation': 'Times Square',
    'paymentMethod': 'cash'
  };
  
  var response = await http.post(
    Uri.parse('$baseUrl/user/ride/request'),
    headers: {'Authorization': 'Bearer $token'},
    body: json.encode(request)
  );
  
  var data = json.decode(response.body);
  currentRideId = data['data']['rideId'];
}
```

2. **Track Ride Status:**
```dart
Future<void> getRideStatus() async {
  var response = await http.get(
    Uri.parse('$baseUrl/user/ride/$currentRideId'),
    headers: {'Authorization': 'Bearer $token'}
  );
  
  var data = json.decode(response.body);
  updateUI(data['data']);
}
```

## Driver App Implementation

### Driver Authentication Flow
1. Driver enters token and logs in
2. Store token locally
3. Connect to WebSocket server with token
4. Set status to 'available'

### Driver WebSocket Events

**Events to Emit:**
- `update_status` - Set driver availability
- `update_location` - Send current location
- `accept_ride_request` - Accept a ride
- `reject_ride_request` - Reject a ride

**Events to Listen For:**
- `new_ride_request` - New ride available
- `ride_accepted` - Confirmation of ride acceptance
- `ride_status_updated` - Ride status changes

```dart
// Driver socket setup
void setupDriverSocket() {
  // Listen for new ride requests
  socket.on('new_ride_request', (data) {
    print('New ride request: ${data['rideId']}');
    // Add to pending rides list
    addToPendingRides(data);
    
    // Show notification
    showNotification('New ride from ${data['pickupLocation']['address']}');
  });
  
  // Listen for ride acceptance confirmation
  socket.on('ride_accepted', (data) {
    print('Ride accepted successfully');
    // Remove from pending rides
    removePendingRide(data['rideId']);
    
    // Set as current ride
    setCurrentRide(data);
  });
}
```

### Driver Key Actions

1. **Set Status to Available:**
```dart
void setDriverAvailable() {
  socket.emit('update_status', {'status': 'available'});
}
```

2. **Update Location:**
```dart
void updateLocation(double lat, double lng) {
  socket.emit('update_location', {
    'latitude': lat,
    'longitude': lng,
    'status': 'available'
  });
}
```

3. **Accept/Reject Ride:**
```dart
void acceptRide(String rideId) {
  socket.emit('accept_ride_request', {
    'rideId': rideId,
    'location': {
      'latitude': currentLat,
      'longitude': currentLng
    }
  });
}

void rejectRide(String rideId) {
  socket.emit('reject_ride_request', {
    'rideId': rideId,
    'reason': 'Driver not available'
  });
}
```

4. **Navigate Through Ride States:**
```dart
// Arrived at pickup
Future<void> arrivedAtPickup() async {
  var response = await http.post(
    Uri.parse('$baseUrl/driver/ride/$currentRideId/arrived'),
    headers: {'Authorization': 'Bearer $token'},
    body: json.encode({
      'latitude': currentLat,
      'longitude': currentLng
    })
  );
}

// Start ride
Future<void> startRide() async {
  var response = await http.post(
    Uri.parse('$baseUrl/driver/ride/$currentRideId/start'),
    headers: {'Authorization': 'Bearer $token'},
    body: json.encode({
      'latitude': currentLat,
      'longitude': currentLng
    })
  );
}

// Complete ride
Future<void> completeRide() async {
  var response = await http.post(
    Uri.parse('$baseUrl/driver/ride/$currentRideId/complete'),
    headers: {'Authorization': 'Bearer $token'},
    body: json.encode({
      'latitude': currentLat,
      'longitude': currentLng
    })
  );
}
```

## Complete Ride Flow Scenarios

### Scenario 1: Successful Ride
```dart
// USER FLOW
1. User requests ride → Status: "pending"
   - API: POST /user/ride/request
   - Get rideId from response

2. Driver accepts → Status: "accepted"
   - Socket event: ride_status_updated
   - UI: Show driver details, estimated arrival

3. Driver en route → Real-time tracking
   - Socket event: driver_location_update
   - UI: Update map with driver location

4. Driver arrives → Status: "arrived" 
   - Socket event: ride_status_updated
   - UI: Notify user "Driver has arrived"

5. Ride starts → Status: "in_progress"
   - Socket event: ride_status_updated
   - UI: Show trip progress

6. Ride completes → Status: "completed"
   - Socket event: ride_status_updated
   - UI: Show fare, payment screen

7. User makes payment
   - API: POST /user/ride/:rideId/payment

8. User rates driver
   - API: POST /user/ride/:rideId/rate

// DRIVER FLOW
1. Driver receives request
   - Socket event: new_ride_request
   - UI: Show ride details, accept/reject buttons

2. Driver accepts ride
   - Socket emit: accept_ride_request
   - Socket response: ride_accepted
   - Update ride status locally

3. Driver navigates to pickup
   - Emit location updates via socket
   - UI: Show route to pickup

4. Driver arrives at pickup
   - API: POST /driver/ride/:rideId/arrived
   - UI: Update to "Start Ride" button

5. Driver starts ride
   - API: POST /driver/ride/:rideId/start
   - UI: Show route to destination

6. Driver completes ride
   - API: POST /driver/ride/:rideId/complete
   - UI: Show earnings, rating screen

7. Driver confirms cash payment (if cash)
   - API: POST /driver/ride/:rideId/confirm-payment

8. Driver rates user
   - API: POST /driver/ride/:rideId/rate
```

### Scenario 2: User Cancels Ride
```dart
// USER CANCELS (before driver accepts)
1. User requests ride → Status: "pending"
2. User cancels
   - API: POST /user/ride/:rideId/cancel
   - Status: "cancelled"
   - Backend notifies drivers to remove request

// USER CANCELS (after driver accepts)
1. Driver assigned → Status: "accepted"
2. User cancels
   - API: POST /user/ride/:rideId/cancel
   - Status: "cancelled"
   - Driver gets notification
   - May incur cancellation fee
```

### Scenario 3: Driver Cancels/Rejects
```dart
// DRIVER REJECTS INITIAL REQUEST
1. New request arrives: socket event new_ride_request
2. Driver rejects
   - Socket emit: reject_ride_request
   - Remove from pending rides
   - Backend offers to next driver

// DRIVER CANCELS ACCEPTED RIDE
1. Driver accepts ride
2. Driver cancels
   - API: POST /driver/ride/:rideId/cancel
   - User notified
   - Backend finds new driver
```

### Scenario 4: No Driver Found
```dart
// USER SIDE HANDLING
1. User requests ride → Status: "pending"
2. Timeout occurs (no drivers accept)
   - Socket event: ride_status_updated
   - Status: "no_driver_found" or "cancelled"
   - UI: Show "No drivers available"
   - Suggest: Try again later or different pickup location

// DRIVER SIDE 
1. Request expires if not accepted
2. Automatically removed from available rides
```

## WebSocket Event Handling for All Scenarios

### User App Events
```dart
void setupRideFlowEvents() {
  // Ride status changes
  socket.on('ride_status_updated', (data) {
    switch(data['status']) {
      case 'accepted':
        showDriverInfo(data['driver']);
        break;
      case 'arrived':
        showNotification('Your driver has arrived');
        break;
      case 'in_progress':
        startTripTracking();
        break;
      case 'completed':
        showPaymentScreen(data['fare']);
        break;
      case 'cancelled':
        showCancellationMessage();
        resetToHome();
        break;
      case 'no_driver_found':
        showNoDriverFoundDialog();
        resetToHome();
        break;
    }
  });
  
  // Driver location updates
  socket.on('driver_location_update', (data) {
    updateDriverMarkerOnMap(data['coordinates']);
    updateETA(data['eta']);
  });
}
```

### Driver App Events  
```dart
void setupDriverFlowEvents() {
  // New ride requests
  socket.on('new_ride_request', (data) {
    if (isAvailable) {
      addToPendingList(data);
      playNotificationSound();
      
      // Auto-reject after timeout
      startAutoRejectTimer(data['rideId']);
    }
  });
  
  // Ride cancellation by user
  socket.on('ride_cancelled_by_user', (data) {
    if (data['rideId'] == currentRideId) {
      showCancellationDialog();
      resetToAvailable();
    }
  });
}
```

## Error Scenarios & Handling

### Connection Loss
```dart
// Reconnection handling
socket.onDisconnect((_) {
  // Try to reconnect
  attemptReconnection();
  
  // Update UI - show offline status
  showOfflineIndicator();
});

socket.onReconnect((_) {
  // Sync state with server
  refreshRideStatus();
  
  // Update UI - hide offline indicator
  hideOfflineIndicator();
});
```

### API Failures
```dart
// Handle ride request failure
Future<void> requestRideWithRetry() async {
  try {
    // Try API call
    await requestRide();
  } catch (e) {
    if (isNetworkError(e)) {
      // Retry logic
      await retryAfterDelay();
    } else {
      // Show error to user
      showErrorDialog('Unable to request ride');
    }
  }
}
```

## Important Tips

### For Both Apps:
1. **Always store tokens securely** using Flutter Secure Storage
2. **Handle socket reconnection** when the app comes back to foreground
3. **Show proper error messages** for failed API calls
4. **Update UI based on WebSocket events** for real-time experience
5. **Implement timeouts** for all API calls
6. **Cache critical data** locally for offline scenarios

### For User App:
1. Show ride status clearly (pending, accepted, driver arrived, in progress, completed)
2. Display driver location on map when available
3. Handle payment confirmation
4. Implement cancellation with confirmation dialog
5. Show estimated wait times
6. Handle no-driver-found scenario gracefully

### For Driver App:
1. Maintain a list of pending ride requests
2. Show clear accept/reject buttons for each request
3. Always keep the current ride ID in memory
4. Update location frequently while online
5. Implement automatic request timeout/rejection
6. Handle user cancellations gracefully

## Sample State Management Structure

```dart
class RideState {
  String? currentRideId;
  String? currentStatus;
  List<Map> pendingRides = [];
  
  void updateFromSocket(dynamic data) {
    // Update state based on socket events
  }
}
```

## Error Handling

```dart
try {
  // API call
} catch (e) {
  if (e is SocketException) {
    showSnackBar('Network error. Please check your connection.');
  } else {
    showSnackBar('Something went wrong. Please try again.');
  }
}
```

Remember: The backend handles all the complex logic. Your job is to:
1. Connect to WebSocket
2. Listen for events
3. Update UI accordingly
4. Send user actions to the backend