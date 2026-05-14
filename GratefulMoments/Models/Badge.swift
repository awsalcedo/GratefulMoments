//
//  Badge.swift
//  GratefulMoments
//
//  Created by usradmin on 13/5/26.
//

import Foundation
import SwiftData

/// Usa `timestamp` para determinar si una insignia está desbloqueada.
/// Un `Moment` puede eliminarse, pero la marca de tiempo permanece.
/// Una vez otorgadas, las insignias no se vuelven a bloquear.
@Model
class Badge {
    var details: BadgeDetails
    /// Propiedad para crear una relación entre la insignia y el momento que la obtuvo
    var moment: Moment?
    /// Propiedad para registrar cuándo se desbloquea la insignia.
    /// La marca de tiempo actúa como un indicador una vez que se ha obtenido la insignia.
    /// Porqué se necesita una marca de tiempo, ya que Moment también tiene una. A diferencia de Moments, que se pueden eliminar, las insignias obtenidas no deben eliminarse incluso si Moment desaparece.
    var timestamp: Date?
    
    /// No se incluye  el momento en el inicializador, porque las insignias se crean al iniciar la aplicación y solo se asignan a un momento posteriormente.
    init(details: BadgeDetails) {
        self.details = details
        self.moment = nil
        self.timestamp = nil
    }
}

/// En una extensión, declare una insignia de muestra para usar en las vistas previas.
extension Badge {
    static var sample: Badge {
        let badge = Badge(details: .firstEntry)
        badge.timestamp = .now
        return badge
    }
}
