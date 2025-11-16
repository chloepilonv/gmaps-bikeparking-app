# BikeParking – San Francisco Bicycle Parking Map

“BikeParking” is an iOS application (MVP) built with Swift, SwiftUI, Google Maps SDK, and Firebase Storage.
Its purpose is simple: display every bicycle parking location in San Francisco, with icons based on
the parking type and an information window for details like racks, spaces, and address.

Demo : 

<div align="center">
  
https://github.com/user-attachments/assets/19c113fb-a38e-41a4-8e80-6f08e2413632

</div>






(Note : My TestFlight account being linked to my company, I unfortunately cannot share an .ipa here)

This project demonstrates how to:

- Load GeoJSON files stored in Firebase Storage  
- Decode them into Swift models  
- Plot markers on Google Maps iOS SDK  
- Customize marker icons depending on the placement type (Sidewalk, road, garage, etc.) - Ability fo filter the different type of placements
- Display information using Google Maps’ default info windows  
- Integrate Google Maps and Firebase, using Swift Package Manager on Xcode

---

## Project Structure

BikeParking/  
│  
├── BikeParkingApp.swift  
├── AppDelegate.swift  
│  
├── Models/  
│   ├── BikeParkingSpot.swift  
│   ├── GeoJSONModels.swift  
│  
├── Services/  
│   └── FirebaseService.swift  
│  
├── ViewModels/  
│   └── BikeParkingViewModel.swift  
│  
├── Views/  
│   └── GoogleMapView.swift  
│  
├── Resources/  
│   └── GoogleService-Info.plist  
│  
└── Assets.xcassets/  
    ├── icon_sidewalk  
    ├── icon_garage  
    ├── icon_roadway  
    ├── icon_parklet  
    ├── icon_parcel  
    └── icon_default  

---

## Requirements

- Xcode 15+  
- iOS 15+  
- Swift 5.9+  
- Google Maps API key  
- Firebase project with Storage enabled  
- GeoJSON uploaded to Firebase: `Bicycle_Parking_Racks_20251116.geojson`

---

## Setup Instructions

### 1. Clone the repository

```
git clone https://github.com/yourusername/BikeParking.git
cd BikeParking
```

### 2. Open the project

```
open BikeParking.xcodeproj
```

### 3. Add Firebase configuration

Download **GoogleService-Info.plist** from your Firebase project, where you uploaded GeoJson datas from : https://data.sfgov.org/Transportation/Map-of-Bicycle-Parking/4w2j-vv4u.

### 4. Add your Google Maps API key

In `AppDelegate.swift`:

```
GMSServices.provideAPIKey("YOUR_API_KEY")
```

### 5. Add dependencies via SPM

Xcode → File → Add Packages…

Google Maps iOS SDK:  
https://github.com/googlemaps/google-maps-ios-sdk

Firebase iOS SDK:  
https://github.com/firebase/firebase-ios-sdk

Add ONLY:  
- FirebaseCore  
- FirebaseStorage  

### 6. Run the app and find a parking place !

Connect your device or choose a simulator on Xcode. Press:  
```
⌘R
```

---

## Data Source

San Francisco Open Data  
https://data.sfgov.org/Transportation/Map-of-Bicycle-Parking/4w2j-vv4u

---

## Future Improvements
 - Capacity for users to add new parking spots
 - Capacity for users to report incidents (such as bicycle theft) at locations, in order to rate safety levels and generate a heat map
 - Complete the unit tests - Of course, add other cities.

---

## License

MIT License.

---

## Credits

Built by yours truly.  
Data: SF Open Data Portal (Thank you, that is awesome!)
