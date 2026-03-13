# smartclass

## Project Description
**smartclass** is a Smart Class Check-in and Learning Reflection app built with Flutter.
Students use the app to:
- Check in before class
- Record their mood and expected learning topic
- Scan QR codes for attendance or class flow
- Submit after-class reflections and feedback

The app also captures location and timestamp data and stores records locally.

## Features
- Home screen with quick navigation
- Before-class Check-in form
- After-class Finish form
- Mood scale (1-5) with slider
- GPS location capture (latitude/longitude)
- QR code scanning on Check-in and Finish screens
- Local data storage using SharedPreferences
- Web deployment support via Firebase Hosting

## Screens
- **Home Screen**
	- Navigate to Check-in or Finish Class
- **Check-in Screen (Before Class)**
	- Previous topic input
	- Expected topic input
	- Mood slider
	- QR scan button
	- Submit check-in with GPS + timestamp
- **Finish Class Screen (After Class)**
	- Learned today input
	- Feedback input
	- QR scan button
	- Submit reflection with location + timestamp

## Technologies Used
- **Flutter** (UI and app framework)
- **GPS** (`geolocator`)
- **QR Scanner** (`mobile_scanner`)
- **Local Storage** (`shared_preferences`)
- **Firebase Hosting** (web deployment)

## Setup Instructions
### 1. Clone the repository
```bash
git clone <https://github.com/Nuttidaa/smartclassApp.git>
cd smartclass
```

### 2. Install dependencies
```bash
flutter pub get
```

### 3. Platform setup notes
- **Android**: Camera and location permissions are required.
- **iOS**: Camera and location usage descriptions are required in `Info.plist`.
- **Windows users**: Enable Developer Mode to avoid symlink/plugin build issues.

## How To Run The App
### Run on mobile/emulator
```bash
flutter run
```

### Run on Chrome (web)
```bash
flutter run -d chrome
```

### Build for web
```bash
flutter build web --release
```

## Deploy Web Build To Firebase Hosting
```bash
firebase login
firebase init hosting
flutter build web --release
firebase deploy --only hosting
```

When configuring Hosting, use:
- Public directory: `build/web`
- Single-page app rewrite: `Yes`
- Overwrite `index.html`: `No`
