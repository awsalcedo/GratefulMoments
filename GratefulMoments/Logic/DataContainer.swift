//
//  DataContainer.swift
//  GratefulMoments
//
//  Created by ALEX WLADIMIR SALCEDO SILVA on 16/3/26.
//

import SwiftData
import SwiftUI

// Clase para configurar SwiftData
// Tener un lugar centralizado para el contenedor del modelo evita que la configuración de datos afecte a tus vistas.

// Marcar la clase `DataContainer` con `@MainActor` garantiza que cualquier interacción con el contenedor desde tus
// vistas se realice en el hilo principal, lo cual es necesario para las actualizaciones de la interfaz de usuario

// La macro `@Observable` le indica a SwiftUI que supervise tu `DataContainer` en busca de cambios. Agregas el
// contenedor al entorno para que el contenedor del modelo y cualquier propiedad futura de `DataContainer` estén
// disponibles a través de la jerarquía de vistas.

@Observable
@MainActor
class DataContainer {
    let modelContainer: ModelContainer

    var context: ModelContext {
        modelContainer.mainContext
    }

    init(includeSampleMoments: Bool = false) {
        let schema = Schema([
            Moment.self
        ])

        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: includeSampleMoments)

        do {
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])

            if includeSampleMoments {
                loadSampleMoments()
            }
            try context.save()
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }

    private func loadSampleMoments() {
        for moment in Moment.sampleData {
            context.insert(moment)
        }
    }
}

private let sampleContainer = DataContainer(includeSampleMoments: true)

/// extensión de vista para simplificar la adición del contenedor de datos de ejemplo a tus vistas previas.
extension View {
    func sampleDataContainer() -> some View {
        environment(sampleContainer)
            .modelContainer(sampleContainer.modelContainer)
    }
}
