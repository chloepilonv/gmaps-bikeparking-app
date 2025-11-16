//
//  BikeParkingViewModel.swift
//  BikeParking
//
//  Holds all bike parking spots + filter state for the map.
//

import Foundation
import Combine

final class BikeParkingViewModel: ObservableObject {

    // All spots loaded from Firebase
    @Published var allSpots: [BikeParkingSpot] = []

    // Selected placement filters (e.g. "SIDEWALK", "GARAGE")
    @Published var activeFilters: Set<String> = []

    // Loading / error states
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    /// All possible placements we want to offer as filter buttons
    let placementOptions: [String] = [
        "SIDEWALK",
        "GARAGE",
        "GARAGE CAGE",
        "ROADWAY",
        "PARKLET",
        "PARCEL"
    ]

    /// Spots that should currently be visible on the map
    var visibleSpots: [BikeParkingSpot] {
        // No filters → show everything
        if activeFilters.isEmpty {
            return allSpots
        }

        let normalized = activeFilters.map { $0.uppercased() }

        return allSpots.filter { spot in
            normalized.contains(spot.placement.uppercased())
        }
    }

    init() {
        loadSpots()
    }

    /// Loads all spots from Firebase Storage via FirebaseService
    func loadSpots() {
        isLoading = true
        errorMessage = nil

        FirebaseService.shared.fetchBikeParkingSpots { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                self.isLoading = false

                switch result {
                case .success(let spots):
                    // TEMP: limit number of markers for performance
                    let maxCount = 2000
                    self.allSpots = Array(spots.prefix(maxCount))

                case .failure(let error):
                    self.errorMessage = error.localizedDescription

                }
            }
        }
    }

    /// Toggles a placement filter on/off
    func toggleFilter(_ placement: String) {
        let key = placement.uppercased()
        if activeFilters.contains(key) {
            activeFilters.remove(key)
        } else {
            activeFilters.insert(key)
        }
    }

    /// Clears all filters (show everything)
    func clearFilters() {
        activeFilters.removeAll()
    }
}
