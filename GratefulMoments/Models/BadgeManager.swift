//
//  BadgeManager.swift
//  GratefulMoments
//
//  Created by usradmin on 13/5/26.
//

import Foundation
import SwiftData

/// BadgeManager se encarga de almacenar las insignias en SwiftData y de otorgarlas cuando se cumplen sus requisitos.
class BadgeManager {
    
    private let modelContainer: ModelContainer
    
    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }
    
    func loadBadgesIfNeeded() throws {
        let context = modelContainer.mainContext
        
        /// Para determinar si es necesario cargar insignias, utilice un FetchDescriptor para comprobar si existen insignias. FetchDescriptor le permite definir el tipo de datos que se van a obtener, y puede filtrar, ordenar y limitar el número de resultados.
        var fetchDescriptor = FetchDescriptor<Badge>()
        fetchDescriptor.fetchLimit = 1
        
        let existingBadges = try context.fetch(fetchDescriptor)
        
        /// Si no hay insignias almacenadas, cree y guarde una insignia para cada caso de BadgeDetails.
        if existingBadges.isEmpty {
            for details in BadgeDetails.allCases {
                context.insert(Badge(details: details))
            }
        }
    }
    
    /// Método para desbloquear nuevas insignias cuando hay un nuevo momento
    func unlockBadges(newMoment: Moment) throws {
        /// Obtener todas las entradas guardadas
        let context = modelContainer.mainContext
        let moments = try context.fetch(FetchDescriptor<Moment>())
        
        /// Obtener las insignias bloqueadas actualmente usando un predicado para filtrar las insignias que no tienen una marca de tiempo.
        let lockedBadges = try context.fetch(FetchDescriptor<Badge>(predicate: #Predicate{ $0.timestamp == nil }))
        
        /// Configura un bucle para encontrar las insignias que se desbloquean con el nuevo momento.
        var newlyUnlocked: [Badge] = []
        for badge in lockedBadges {
            switch badge.details {
            /// Desbloquea la insignia firstEntry cuando haya al menos un momento
            /// Desbloquea la insignia fiveStars cuando haya cinco o más momentos.
            /// Desbloquea la insignia shutterBug cuando haya tres o más momentos con imágenes.
            /// Desbloquea la insignia expresiva cuando haya cinco o más momentos que tengan una imagen y una nota.
            /// Desbloquea la insignia perfectTen cuando haya 10 o más momentos y todas las demás insignias estén desbloqueadas.
            case .firstEntry where moments.count >= 1,
                    .fiveStars where moments.count >= 5,
                    .shutterbug where moments.count(where: { $0.image != nil }) >= 3,
                    .expressive where moments.count(where: { $0.image != nil && !$0.note.isEmpty }) >= 5,
                    .perfectTen where moments.count >= 10 && lockedBadges.count == 1:
                newlyUnlocked.append(badge)
            default:
                continue
            }
        }
        
        /// Desbloquea cada insignia obtenida configurando sus propiedades de momento y marca de tiempo.
        for badge in newlyUnlocked {
            badge.moment = newMoment
            badge.timestamp = newMoment.timestamp
        }
    }
}
