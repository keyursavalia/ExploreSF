import SwiftUI
import SwiftData
import CoreLocation

struct ItinerarySetupSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(ItineraryManager.self) private var manager
    @Query(sort: \SavedPlace.savedAt, order: .reverse) private var allSaved: [SavedPlace]

    @State private var selectedIDs: Set<String> = []
    @State private var useStopsLimit = false
    @State private var stopsLimit    = 10
    @State private var useDays       = false
    @State private var totalDays     = 2
    @State private var locationHelper = LocationHelper()

    private var selectedPlaces: [SavedPlace] {
        allSaved.filter { selectedIDs.contains($0.id) }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    intro
                    placeList
                    optionsSection
                    generateButton
                        .padding(.bottom, 40)
                }
            }
            .background(Color.appPaper)
            .navigationTitle("Plan Your Day")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(Color.appInk3)
                }
            }
        }
        .onAppear {
            if selectedIDs.isEmpty {
                selectedIDs = Set(allSaved.map(\.id))
                stopsLimit  = max(1, min(10, allSaved.count))
            }
        }
    }

    // MARK: - Intro

    private var intro: some View {
        Text("Select the places you'd like to visit and we'll build the most efficient route for you, starting from your current location.")
            .font(.appBody)
            .foregroundStyle(Color.appInk3)
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 24)
    }

    // MARK: - Place list

    private var placeList: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Saved Places")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color.appInk3)
                    .textCase(.uppercase)
                    .tracking(0.5)
                Spacer()
                Button(selectedIDs.count == allSaved.count ? "Deselect All" : "Select All") {
                    withAnimation(.easeInOut(duration: 0.15)) {
                        if selectedIDs.count == allSaved.count {
                            selectedIDs.removeAll()
                        } else {
                            selectedIDs = Set(allSaved.map(\.id))
                        }
                    }
                }
                .font(.system(size: 13))
                .foregroundStyle(Color.appInk3)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 10)

            if allSaved.isEmpty {
                Text("No saved places yet. Bookmark places from the map to add them here.")
                    .font(.appBody)
                    .foregroundStyle(Color.appInk4)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
            } else {
                ForEach(allSaved, id: \.id) { place in
                    placeRow(place)
                    Divider()
                        .background(Color.appHairline)
                        .padding(.horizontal, 20)
                }
            }
        }
        .padding(.bottom, 28)
    }

    private func placeRow(_ place: SavedPlace) -> some View {
        let isSelected = selectedIDs.contains(place.id)
        let category   = place.category ?? .film
        return Button {
            withAnimation(.easeInOut(duration: 0.15)) {
                if isSelected { selectedIDs.remove(place.id) }
                else          { selectedIDs.insert(place.id) }
            }
        } label: {
            HStack(spacing: 14) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 22))
                    .foregroundStyle(isSelected ? category.color : Color.appInk4)
                    .animation(.easeInOut(duration: 0.15), value: isSelected)

                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(category.color.opacity(0.12))
                        .frame(width: 36, height: 36)
                    Image(systemName: category.systemIcon)
                        .font(.system(size: 14))
                        .foregroundStyle(category.color)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(place.displayName)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(Color.appInk)
                        .lineLimit(1)
                    if !place.locationName.isEmpty {
                        Text(place.locationName)
                            .font(.appCaption)
                            .foregroundStyle(Color.appInk4)
                            .lineLimit(1)
                    }
                }
                Spacer(minLength: 0)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    // MARK: - Options

    private var optionsSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Options")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(Color.appInk3)
                .textCase(.uppercase)
                .tracking(0.5)
                .padding(.horizontal, 20)
                .padding(.bottom, 10)

            VStack(spacing: 0) {
                stopsLimitRow
                if useStopsLimit {
                    Divider().background(Color.appHairline).padding(.horizontal, 20)
                    stopStepperRow
                }
                Divider().background(Color.appHairline).padding(.horizontal, 20)
                multiDayRow
                if useDays {
                    Divider().background(Color.appHairline).padding(.horizontal, 20)
                    dayStepperRow
                }
            }
            .background(Color.appCard)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.appCardEdge, lineWidth: 1))
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 32)
    }

    private var stopsLimitRow: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Limit stops")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Color.appInk)
                Text("Cap the total number of stops")
                    .font(.appCaption)
                    .foregroundStyle(Color.appInk4)
            }
            Spacer()
            Toggle("", isOn: $useStopsLimit)
                .labelsHidden()
                .tint(Color.appInk)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
    }

    private var stopStepperRow: some View {
        HStack {
            Text("Total stops")
                .font(.system(size: 15))
                .foregroundStyle(Color.appInk3)
            Spacer()
            Stepper("\(stopsLimit)", value: $stopsLimit, in: 1...max(1, selectedPlaces.count))
                .fixedSize()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }

    private var multiDayRow: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Multi-day plan")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Color.appInk)
                Text("Spread stops across multiple days")
                    .font(.appCaption)
                    .foregroundStyle(Color.appInk4)
            }
            Spacer()
            Toggle("", isOn: $useDays)
                .labelsHidden()
                .tint(Color.appInk)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
    }

    private var dayStepperRow: some View {
        HStack {
            Text("Number of days")
                .font(.system(size: 15))
                .foregroundStyle(Color.appInk3)
            Spacer()
            Stepper(totalDays == 1 ? "1 day" : "\(totalDays) days", value: $totalDays, in: 2...7)
                .fixedSize()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }

    // MARK: - Generate button

    private var generateButton: some View {
        let canGenerate = !selectedPlaces.isEmpty
        return Button(action: generate) {
            HStack(spacing: 8) {
                Image(systemName: "map.fill")
                Text(canGenerate
                     ? "Generate Itinerary · \(selectedPlaces.count) \(selectedPlaces.count == 1 ? "stop" : "stops")"
                     : "Select at least one place")
                    .font(.system(size: 15, weight: .semibold))
            }
            .foregroundStyle(Color.appPaper)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(canGenerate ? Color.appInk : Color.appInk4)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain)
        .disabled(!canGenerate)
        .padding(.horizontal, 20)
        .animation(.easeInOut(duration: 0.15), value: canGenerate)
    }

    // MARK: - Generate action

    private func generate() {
        let start = locationHelper.location ?? CLLocation(latitude: 37.7749, longitude: -122.4194)
        let limit = useStopsLimit ? stopsLimit : nil
        let days  = useDays ? totalDays : 1
        manager.generatePlan(from: selectedPlaces, stopsLimit: limit, days: days, startLocation: start)
        dismiss()
    }
}

// MARK: - Location Helper

private final class LocationHelper: NSObject, CLLocationManagerDelegate {
    private let clm = CLLocationManager()
    var location: CLLocation? = nil

    override init() {
        super.init()
        clm.delegate = self
        clm.desiredAccuracy = kCLLocationAccuracyHundredMeters
        clm.requestWhenInUseAuthorization()
        clm.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            clm.startUpdatingLocation()
        default:
            break
        }
    }
}
