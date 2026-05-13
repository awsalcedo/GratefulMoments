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
}
