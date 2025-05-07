## WebSocket Connection & Flow Questions

### 1. Ride Request and Driver Notification

Yes, when a user makes a ride request, the details are shown to the user, and nearby drivers are notified via WebSockets. The flow works like this:

1. User makes a ride request through HTTP API call
2. Backend stores the request and returns data (including rideId)
3. Backend then broadcasts this request to nearby drivers via WebSocket
4. Drivers receive this as a `new_ride_request` WebSocket event

### 2. Driver Acceptance Notification

When a driver accepts a ride, the backend sends a WebSocket event to the user's device. You don't need to poll an API - the notification comes automatically through the WebSocket connection.

The user app listens for the `ride_status_updated` event with "accepted" status.

### 3. WebSocket Client & Listening

Yes, you need to create a WebSocket client in your Flutter app. You'll need to use the `socket_io_client` package, not a regular WebSocket library, because the backend is using Socket.IO (not plain WebSockets).

```dart
// Example of setting up the client
import 'package:socket_io_client/socket_io_client.dart' as IO;

void setupSocketConnection() {
  // Initialize socket with your server URL
  socket = IO.io('https://api-freedom.com', <String, dynamic>{
    'auth': {'token': userToken},
    'transports': ['websocket'],
    'autoConnect': true
  });
  
  // Set up event listeners
  socket.on('ride_status_updated', (data) {
    print('Ride status changed: ${data['status']}');
    // Update your UI based on this data
  });
  
  // Connect to server
  socket.connect();
}
```

### 4. Socket URL

The socket URL should be the same domain as your API base URL, but you don't add any endpoints. For example:

- API URL: `https://https://api-freedom.com/api/v2/`
- Socket URL: `https://https://api-freedom.com`

### 5. Socket.IO vs WebSockets (ws:// vs https://)

You're right that traditional WebSockets use the `ws://` or `wss://` protocol. However, Socket.IO (which the backend is using) works over HTTP/HTTPS and can fall back to other transport methods if needed.

The Socket.IO client library handles this automatically - you just provide the HTTPS URL, and it manages the connection.

### 6. Event-Driven Communication

Yes, all Socket.IO communication is event-driven. Everything works through events:

- The server emits events like `ride_status_updated`, `new_ride_request`, etc.
- Your client listens for these events with `socket.on('event_name', callback)`
- Your client can also emit events like `accept_ride_request` with `socket.emit('event_name', data)`

## Quick Implementation Example

Here's a quick example of how to set up the socket connection in your Flutter app:

```dart
// In your service class
IO.Socket? socket;

void connectSocket(String token) {
  // Disconnect existing connection if any
  if (socket != null) {
    socket!.disconnect();
  }
  
  // Connect to the socket server with authentication
  socket = IO.io('https://https://api-freedom.com', {
    'auth': {'token': token},
    'transports': ['websocket'],
    'autoConnect': false,
  });
  
  // Set up connection event handlers
  socket!.onConnect((_) {
    print('Connected to socket');
    // Update UI to show connected state
  });
  
  socket!.onDisconnect((_) {
    print('Disconnected from socket');
    // Update UI to show disconnected state
  });
  
  socket!.onConnectError((error) {
    print('Connection error: $error');
    // Handle connection errors
  });
  
  // Now connect
  socket!.connect();
}
```

Then in your user app, listen for driver acceptance:

```dart
void setupUserEvents() {
  socket!.on('ride_status_updated', (data) {
    if (data['status'] == 'accepted') {
      // Show driver information
      showDriverInfo(data['driver']);
      
      // Update UI to show "Driver is coming" state
      updateRideState(RideState.driverAccepted);
    }
  });
}
```

```dart
// In your service class
void connectSocket(String token) {
  // Setup socket connection
  socket = IO.io('https://api-freedom.com', {
    'auth': {'token': token},
    'transports': ['websocket'],
    'autoConnect': false,
  });
  
  // Set up event listeners
  setupSocketEventListeners();
  
  // Connect
  socket.connect();
}
```

Here are some key points for implementing the WebSocket connection.

1. **Socket URL**: Use `https://api-freedom.com` as the WebSocket server address (same as your API domain)

2. **Authentication**: Include the user/driver token in the connection as shown above

3. **Transport Method**: The code specifies `'transports': ['websocket']` to force WebSocket transport instead of allowing fallbacks

4. **Event Flow for User App**:
   - After login, connect to socket
   - When requesting a ride, store the rideId from the HTTP response
   - Listen for `ride_status_updated` to know when a driver accepts

5. **Event Flow for Driver App**:
   - After login, connect to socket and set status to available
   - Listen for `new_ride_request` events to see nearby ride requests
   - When accepting a ride, emit `accept_ride_request` with the rideId

The Socket.IO client will handle the protocol conversion between HTTPS and WebSocket automatically - you don't need to change the URL to ws:// format.
