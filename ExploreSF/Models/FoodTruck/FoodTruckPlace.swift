import Foundation
import CoreLocation

struct FoodTruckPlace: Identifiable, Hashable {
    let id: String
    let name: String
    let foodItems: String
    let facilityType: FacilityType
    let locationDescription: String
    let permitNumber: String
    let latitude: Double
    let longitude: Double

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    enum FacilityType: String, Hashable {
        case truck    = "Truck"
        case pushCart = "Push Cart"
        case other

        var displayName: String {
            switch self {
            case .truck:    return "Food Truck"
            case .pushCart: return "Push Cart"
            case .other:    return "Mobile Vendor"
            }
        }

        var systemIcon: String {
            switch self {
            case .truck:    return "truck.box"
            case .pushCart: return "cart"
            case .other:    return "fork.knife"
            }
        }

        init(raw: String?) {
            switch raw {
            case "Truck":     self = .truck
            case "Push Cart": self = .pushCart
            default:          self = .other
            }
        }
    }
}
