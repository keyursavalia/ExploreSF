import SwiftUI
import MapKit

struct WaterFountainInfoSheet: View {
    let place: WaterFountainPlace

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerSection
                infoRows
                directionsButton
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("WATER FOUNTAIN")
                .eyebrowStyle()
            Text(place.name)
                .font(.system(size: 22, weight: .medium, design: .serif))
                .foregroundStyle(Color.appInk)
                .lineLimit(3)
            if !place.address.isEmpty {
                Label(place.address, systemImage: "mappin.and.ellipse")
                    .font(.system(size: 13))
                    .foregroundStyle(Color.appInk3)
            }
        }
    }

    private var infoRows: some View {
        VStack(alignment: .leading, spacing: 1) {
            if let park = place.park {
                infoRow(label: "Park", value: park, icon: "tree")
            }
            infoRow(
                label: "Access",
                value: place.isPublicAccess ? "Publicly Accessible" : "Limited Access",
                icon: "figure.walk"
            )
            if let hours = formattedHours {
                infoRow(label: "Hours", value: hours, icon: "clock")
            }
            infoRow(label: "Days Open", value: place.accessDays, icon: "calendar")
            infoRow(
                label: "Bottle Filler",
                value: place.hasBottleFiller ? "Available" : "No",
                icon: "waterbottle"
            )
            infoRow(
                label: "Dog Fountain",
                value: place.hasDogFountain ? "Available" : "No",
                icon: "pawprint"
            )
            if let notes = place.notes, !notes.isEmpty {
                infoRow(label: "Notes", value: notes, icon: "info.circle")
            }
        }
        .background(Color.appCard)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.appCardEdge, lineWidth: 1))
    }

    private var formattedHours: String? {
        guard let open = place.hoursOpen, let close = place.hoursClose else { return nil }
        if open == "00:00:00" && close == "24:00:00" { return "Open 24 Hours" }
        return "\(formatTime(open)) – \(formatTime(close))"
    }

    private func formatTime(_ timeStr: String) -> String {
        let parts = timeStr.components(separatedBy: ":")
        guard parts.count >= 2, let hour = Int(parts[0]), let minute = Int(parts[1]) else {
            return timeStr
        }
        let period = hour < 12 ? "AM" : "PM"
        let displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour)
        return minute == 0
            ? "\(displayHour) \(period)"
            : "\(displayHour):\(String(format: "%02d", minute)) \(period)"
    }

    private func infoRow(label: String, value: String, icon: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 13))
                .foregroundStyle(Color.appInk3)
                .frame(width: 20)
            Text(label)
                .font(.system(size: 13))
                .foregroundStyle(Color.appInk3)
            Spacer()
            Text(value)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Color.appInk)
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: 200, alignment: .trailing)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    private var directionsButton: some View {
        Button {
            let item = MKMapItem(placemark: MKPlacemark(coordinate: place.coordinate))
            item.name = place.name
            item.openInMaps(launchOptions: [
                MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking
            ])
        } label: {
            Label("Get Directions", systemImage: "arrow.triangle.turn.up.right.circle.fill")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(Color.appPaper)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(UtilityToggleButtonsView.fountainColor)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}
