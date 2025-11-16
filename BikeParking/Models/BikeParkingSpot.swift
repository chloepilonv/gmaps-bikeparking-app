// BikeParkingSpot.swift
// Main model used by the app for one bike parking spot

import Foundation
import CoreLocation

struct BikeParkingSpot: Identifiable {
    let id: String
    
    let placement: String      // e.g. "SIDEWALK", "GARAGE"
    let address: String
    let racks: Int
    let spaces: Int
    
    let latitude: Double
    let longitude: Double
    
    /// Convenience: coordinate for Map APIs
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
