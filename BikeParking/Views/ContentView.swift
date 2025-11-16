//
//  ContentView.swift
//  BikeParking
//
//  Main SwiftUI view: Google Map + filter chips + status banner.
//

import SwiftUI

struct ContentView: View {

    @StateObject private var viewModel = BikeParkingViewModel()

    // 3 columns for the filter grid (2 rows x 3 chips)
    private let filterColumns: [GridItem] = Array(
        repeating: GridItem(.flexible(), spacing: 8),
        count: 3
    )

    var body: some View {
        ZStack(alignment: .top) {

            // Map shows the *filtered* spots
            GoogleMapView(spots: viewModel.visibleSpots)
                .ignoresSafeArea()

            VStack(spacing: 8) {

                // MARK: - Filter panel
                VStack(spacing: 6) {

                    // Small title
                    Text("Filter by placement")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)

                    // Grid of chips, always fully visible
                    LazyVGrid(columns: filterColumns, spacing: 8) {
                        ForEach(viewModel.placementOptions, id: \.self) { placement in
                            let isOn = viewModel.activeFilters.contains(placement.uppercased())

                            Button {
                                viewModel.toggleFilter(placement)
                            } label: {
                                Text(prettyName(for: placement))
                                    .font(.caption2)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.8)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 6)
                                    .frame(maxWidth: .infinity)
                                    .background(isOn ? Color.blue : Color.white.opacity(0.95))
                                    .foregroundColor(isOn ? .white : .blue)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.blue.opacity(0.5), lineWidth: 1)
                                    )
                            }
                        }
                    }

                    // Optional “All” button to clear filters
                    if !viewModel.activeFilters.isEmpty {
                        Button {
                            viewModel.clearFilters()
                        } label: {
                            Text("Show all placements")
                                .font(.caption2)
                                .foregroundColor(.blue)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
                .padding(.bottom, 6)
                .background(.ultraThinMaterial)
                .cornerRadius(18)
                .padding(.horizontal)
                .padding(.top, 16) // keep clear of notch / Dynamic Island

                // MARK: - Status / error banner
                if let error = viewModel.errorMessage {
                    Text("Error: \(error)")
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.red.opacity(0.85))
                        .cornerRadius(10)
                        .padding(.horizontal)
                } else if viewModel.isLoading {
                    Text("Loading bike parking data…")
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }

                Spacer()
            }
        }
    }

    /// Human-readable label for a placement value
    private func prettyName(for placement: String) -> String {
        switch placement.uppercased() {
        case "SIDEWALK":     return "Sidewalk"
        case "GARAGE":       return "Garage"
        case "GARAGE CAGE":  return "Garage Cage"
        case "ROADWAY":      return "Roadway"
        case "PARKLET":      return "Parklet"
        case "PARCEL":       return "Parcel"
        default:             return placement.capitalized
        }
    }
}

#Preview {
    ContentView()
}
