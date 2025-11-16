// GeoJSONModels.swift
// Structures that match the GeoJSON file stored in Firebase Storage.

import Foundation

/// Top-level GeoJSON object
struct GeoJSONFeatureCollection: Decodable {
    let type: String
    let features: [GeoJSONFeature]
}

/// Single feature in the GeoJSON
struct GeoJSONFeature: Decodable {
    let type: String
    
    // geometry can be null in some datasets, so we keep it optional
    let geometry: GeoJSONGeometry?
    
    let properties: GeoJSONProperties
}

/// Geometry: we only care about Point coordinates
struct GeoJSONGeometry: Decodable {
    let type: String
    let coordinates: [Double]   // [longitude, latitude]
}

/// Only the properties we actually use. All other keys are ignored automatically.
struct GeoJSONProperties: Decodable {
    let objectid: String?
    let address: String?
    let location: String?
    let street: String?
    let placement: String?
    let racks: String?
    let spaces: String?
    let lat: String?
    let lon: String?
}
