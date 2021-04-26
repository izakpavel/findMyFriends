//
//  UserAnnotation.swift
//  FindMyFriends
//
//  Created by Pavel Zak on 26.04.2021.
//

import Foundation
import Mapbox

class UserAnnotation: NSObject, MGLAnnotation {
    var coordinate: CLLocationCoordinate2D {
        let latitude: CLLocationDegrees = CLLocationDegrees(user.location?.coordinates?.latitude ?? "") ?? 0
        let longitude: CLLocationDegrees = CLLocationDegrees(user.location?.coordinates?.longitude ?? "") ?? 0
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    let user: User
    
    init(user: User) {
        self.user = user
    }
}
