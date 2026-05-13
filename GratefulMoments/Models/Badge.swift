//
//  Badge.swift
//  GratefulMoments
//
//  Created by usradmin on 13/5/26.
//

import Foundation
import SwiftData

@Model
class Badge {
    var details: BadgeDetails
    
    init(details: BadgeDetails) {
        self.details = details
    }
}

/// En una extensión, declare una insignia de muestra para usar en las vistas previas.
extension Badge {
    static var sample: Badge {
        let badge = Badge(details: .firstEntry)
        return badge
    }
}
