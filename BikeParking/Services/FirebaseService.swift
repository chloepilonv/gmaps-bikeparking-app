// FirebaseService.swift
// Downloads the GeoJSON file from Firebase Storage and converts it to [BikeParkingSpot].

import Foundation
import FirebaseStorage

final class FirebaseService {
    
    static let shared = FirebaseService()
    private init() {}
    
    private let storage = Storage.storage()
    
    /// Fetch spots from Firebase Storage, decode GeoJSON, map to BikeParkingSpot.
    func fetchBikeParkingSpots(
        completion: @escaping (Result<[BikeParkingSpot], Error>) -> Void
    ) {
        // This must match the path of the file in the Firebase Storage bucket.
        // e.g. if it's at the root: gs://your-bucket/Bicycle_Parking_Racks_20251116.geojson
        let filePath = "Bicycle_Parking_Racks_20251116.geojson"
        let ref = storage.reference(withPath: filePath)
        
        let maxSize: Int64 = 10 * 1024 * 1024 // 10 MB
        
        ref.getData(maxSize: maxSize) { data, error in
            
            // 1) Download error (wrong path, permissions, etc.)
            if let error = error {
                print("🔥 Firebase Storage error:", error)
                completion(.failure(error))
                return
            }
            
            // 2) No data at all (should not happen, but we guard anyway)
            guard let data = data else {
                print("⚠️ Firebase Storage returned nil data")
                let err = NSError(
                    domain: "BikeParking",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "No data from Storage"]
                )
                completion(.failure(err))
                return
            }
            
            print("✅ Downloaded GeoJSON, size = \(data.count) bytes")
            
            // 3) Decode GeoJSON
            do {
                let decoder = JSONDecoder()
                let collection = try decoder.decode(GeoJSONFeatureCollection.self, from: data)
                print("✅ Decoded GeoJSON: \(collection.features.count) features")
                
                // 4) Map each feature to BikeParkingSpot
                let spots: [BikeParkingSpot] = collection.features.compactMap { feature in
                    let p = feature.properties
                    
                    var lat: Double?
                    var lon: Double?
                    
                    // Preferred source: geometry.coordinates [lon, lat]
                    if let coords = feature.geometry?.coordinates, coords.count == 2 {
                        lon = coords[0]
                        lat = coords[1]
                    }
                    
                    // Fallback: lat/lon properties as strings
                    if lat == nil, let s = p.lat, let v = Double(s) {
                        lat = v
                    }
                    if lon == nil, let s = p.lon, let v = Double(s) {
                        lon = v
                    }
                    
                    // If we still don't have coordinates, skip this feature
                    guard let finalLat = lat, let finalLon = lon else {
                        return nil
                    }
                    
                    let racks = Int(p.racks ?? "") ?? 0
                    let spaces = Int(p.spaces ?? "") ?? 0
                    let id = p.objectid ?? UUID().uuidString
                    let placement = p.placement ?? "UNKNOWN"
                    let address = p.address ?? "Unknown address"
                    
                    return BikeParkingSpot(
                        id: id,
                        placement: placement,
                        address: address,
                        racks: racks,
                        spaces: spaces,
                        latitude: finalLat,
                        longitude: finalLon
                    )
                }
                
                print("✅ Mapped \(spots.count) bike parking spots")
                completion(.success(spots))
                
            } catch {
                // More detailed decoding diagnostics
                if let decodingError = error as? DecodingError {
                    switch decodingError {
                    case .dataCorrupted(let context):
                        print("❌ GeoJSON decode error: dataCorrupted:", context.debugDescription)
                        print("   codingPath:", context.codingPath.map(\.stringValue))
                    case .keyNotFound(let key, let context):
                        print("❌ GeoJSON decode error: keyNotFound:", key.stringValue,
                              "in", context.codingPath.map(\.stringValue),
                              "-", context.debugDescription)
                    case .typeMismatch(let type, let context):
                        print("❌ GeoJSON decode error: typeMismatch for \(type):",
                              context.debugDescription,
                              "path:", context.codingPath.map(\.stringValue))
                    case .valueNotFound(let value, let context):
                        print("❌ GeoJSON decode error: valueNotFound for \(value):",
                              context.debugDescription,
                              "path:", context.codingPath.map(\.stringValue))
                    @unknown default:
                        print("❌ GeoJSON decode error: unknown case", decodingError)
                    }
                } else {
                    print("❌ Non-decoding error when parsing GeoJSON:", error)
                }
                
                // Optional: peek at the beginning of the file to confirm it is the JSON we expect
                if let preview = String(data: Data(data.prefix(400)), encoding: .utf8) {
                    print("📄 First 400 bytes of downloaded file:\n\(preview)")
                }
                
                completion(.failure(error))
            }
        }
    }
}
