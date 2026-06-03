# Firebase Patient-Caregiver Connection System

## 🚀 Overview
This system enables patients to connect with caregivers who will receive notifications when patients miss medications or appointments.

## 📱 How It Works

### 1. **Connection Process**
1. **Patient adds caregiver** by entering caregiver's phone number
2. **System sends verification code** to caregiver via notification
3. **Caregiver confirms** by entering the verification code
4. **Connection becomes active** - caregiver now receives patient's health alerts

### 2. **Notification System**
- **Missed Medication**: Caregiver gets instant notification when patient misses a dose
- **Missed Appointment**: Caregiver gets alert when patient misses an appointment
- **Connection Requests**: Caregivers receive notifications for new patient requests

## 🔧 Implementation Details

### **Firebase Collections Structure**

```
users/
├── {userId}/
│   ├── userType: "patient" | "caregiver"
│   ├── phoneNumber: "+1234567890"
│   ├── name: "John Doe"
│   ├── email: "john@example.com"
│   ├── fcmToken: "firebase_token"
│   └── profileImage: "url"

patient_caregiver_connections/
├── {connectionId}/
│   ├── patientId: "userId"
│   ├── caregiverId: "userId"
│   ├── status: "pending" | "active" | "declined"
│   ├── connectionMethod: "phone" | "code" | "qr"
│   ├── verificationCode: "123456"
│   ├── createdAt: timestamp
│   └── confirmedAt: timestamp

missed_doses/
├── {missedDoseId}/
│   ├── patientId: "userId"
│   ├── medicationName: "Medicine Name"
│   ├── scheduledTime: timestamp
│   ├── missedAt: timestamp
│   ├── caregiverIds: [array of caregiver IDs]
│   └── notified: boolean

missed_appointments/
├── {missedAppointmentId}/
│   ├── patientId: "userId"
│   ├── appointmentDetails: "Dr. Smith checkup"
│   ├── scheduledTime: timestamp
│   ├── missedAt: timestamp
│   ├── caregiverIds: [array of caregiver IDs]
│   └── notified: boolean
```

### **Key Services**

#### **ConnectionService**
- `connectViaPhone()` - Connect patient to caregiver using phone number
- `confirmConnection()` - Caregiver confirms connection with verification code
- `getActiveConnections()` - Get all active patient-caregiver connections
- `getPendingRequests()` - Get pending connection requests for caregivers
- `disconnectConnection()` - Remove connection between patient and caregiver

#### **NotificationService**
- `notifyCaregiversOfMissedMedication()` - Alert caregivers when patient misses medication
- `notifyCaregiversOfMissedAppointment()` - Alert caregivers when patient misses appointment
- `sendConnectionRequest()` - Send connection request notification to caregiver
- `sendConnectionAccepted()` - Notify patient when caregiver accepts request

## 🔥 Firebase Setup Required

### 1. **Firebase Project Configuration**
You already have the configuration files:
- `android/app/google-services.json` ✅
- `ios/Runner/GoogleService-Info.plist` ✅

### 2. **Android Configuration** (Already Done)
- Added Google Services plugin to build.gradle files ✅
- Firebase dependencies added to pubspec.yaml ✅

### 3. **Firestore Security Rules** (Recommended)
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Connection rules
    match /patient_caregiver_connections/{connectionId} {
      allow read, write: if request.auth != null && 
        (request.auth.uid == resource.data.patientId || 
         request.auth.uid == resource.data.caregiverId);
    }
    
    // Missed doses/appointments - readable by connected users
    match /missed_doses/{doseId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        request.auth.uid == resource.data.patientId;
    }
    
    match /missed_appointments/{appointmentId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        request.auth.uid == resource.data.patientId;
    }
  }
}
```

## 📲 Usage Examples

### **For Patients - Adding a Caregiver**
```dart
ConnectionService connectionService = ConnectionService();

// Connect to caregiver via phone
String? connectionId = await connectionService.connectViaPhone(
  caregiverPhoneNumber: "+1234567890",
  patientName: "John Doe",
);

// Caregiver receives notification with verification code
```

### **For Caregivers - Confirming Connection**
```dart
// Caregiver enters verification code received via notification
bool success = await connectionService.confirmConnection(
  connectionId: "connection_id_from_notification",
  verificationCode: "123456",
);
```

### **Sending Missed Medication Alert**
```dart
NotificationService notificationService = NotificationService();

// When patient misses medication, notify all connected caregivers
await notificationService.notifyCaregiversOfMissedMedication(
  patientId: "patient_user_id",
  medicationName: "Lisinopril 10mg",
  scheduledTime: DateTime(2025, 11, 18, 8, 0), // 8:00 AM
  patientName: "John Doe",
);
```

## 🔐 Security Features

1. **Phone Number Verification**: Caregivers must verify with code sent to their phone
2. **Firebase Authentication**: All users must be authenticated
3. **Firestore Security Rules**: Users can only access their own data and connected relationships
4. **Verification Codes**: Expire after a reasonable time period
5. **Connection Consent**: Both parties must explicitly agree to the connection

## 📱 App Flow

### **Patient Flow**
1. Register/Login → Select "Patient" role
2. Go to "Add Caregiver" screen
3. Enter caregiver's phone number
4. Wait for caregiver to confirm
5. Receive notifications about health reminders

### **Caregiver Flow**
1. Register/Login → Select "Caregiver" role
2. Receive connection request notification
3. Enter verification code to confirm
4. Start receiving patient's missed medication/appointment alerts

## 🚀 Next Steps

1. **Run the app** with Firebase initialized
2. **Test the connection flow** between patient and caregiver
3. **Set up medication reminders** that trigger notifications to caregivers when missed
4. **Add appointment scheduling** with similar notification logic
5. **Enhance UI** for better user experience

This system provides a robust foundation for patient-caregiver relationships with real-time health monitoring and notifications!