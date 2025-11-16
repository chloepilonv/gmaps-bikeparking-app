//
//  GoogleMapView.swift
//  BikeParking
//
//  Displays all bike parking spots on a Google Map.
//  Includes custom icons based on placement type.
//

import SwiftUI
import GoogleMaps
import UIKit

// MARK: - UIImage resizing helper
extension UIImage {
    /// Scales an image to a new CGSize (used for pin icons)
    func scaled(to newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

// MARK: - Google Map View Wrapper
struct GoogleMapView: UIViewRepresentable {

    let spots: [BikeParkingSpot]   // The list of parking locations

    // Create the GMSMapView (called once)
    func makeUIView(context: Context) -> GMSMapView {

        // Center map on San Francisco
        let camera = GMSCameraPosition.camera(
            withLatitude: 37.7749,
            longitude: -122.4194,
            zoom: 13
        )

        let mapView = GMSMapView(frame: .zero, camera: camera)
        mapView.delegate = context.coordinator

        // Enable UI features
        mapView.settings.compassButton = true
        mapView.settings.zoomGestures = true
        mapView.settings.scrollGestures = true

        return mapView
    }

    // Called every time `spots` changes
    func updateUIView(_ mapView: GMSMapView, context: Context) {

        mapView.clear()  // Remove all old markers

        for spot in spots {
            let marker = GMSMarker()

            marker.position = spot.coordinate
            marker.title = spot.address
            marker.snippet = "Racks: \(spot.racks) | Spaces: \(spot.spaces)\nPlacement: \(spot.placement)"

            // Assign custom icon (scaled down)
            marker.icon = icon(for: spot.placement)

            marker.map = mapView
        }
    }

    // Coordinator for map delegate callbacks
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, GMSMapViewDelegate {
        var parent: GoogleMapView

        init(_ parent: GoogleMapView) {
            self.parent = parent
        }
    }
}

// MARK: - Icon selection based on placement type
private func icon(for placement: String) -> UIImage? {

    let name: String

    // Choose an asset name based on placement value
    switch placement.uppercased() {
    case "SIDEWALK":
        name = "icon_sidewalk"

    case "GARAGE":
        name = "icon_garage"

    case "GARAGE CAGE":
        name = "icon_cage"

    case "ROADWAY":
        name = "icon_roadway"

    case "PARKLET":
        name = "icon_parklet"

    case "PARCEL":
        name = "icon_parcel"

    default:
        name = "icon_default"
    }

    // Load image from Assets
    guard let image = UIImage(named: name) else {
        print("⚠️ Warning: icon not found for asset name: \(name)")
        return nil
    }

    // Scale to a normal map marker size
    let size = CGSize(width: 32, height: 32)

    return image.scaled(to: size)
}
