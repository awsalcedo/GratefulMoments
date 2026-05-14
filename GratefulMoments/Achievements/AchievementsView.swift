//
//  AchievementsView.swift
//  GratefulMoments
//
//  Created by usradmin on 14/5/26.
//

import SwiftUI
import SwiftData

struct AchievementsView: View {
    
    /// Usa @Query para obtener las insignias almacenadas. Agrega dos consultas, cada una con un Predicate que filtre por marca de tiempo para devolver las insignias desbloqueadas y bloqueadas.
    @Query(filter: #Predicate<Badge> { $0.timestamp != nil })
    private var unlockedBadges: [Badge]
    
    @Query(filter: #Predicate<Badge> { $0.timestamp == nil })
    private var lockedBadges: [Badge]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                contentStack
            }
            .navigationTitle("Achievements")
        }
    }
    
    private var contentStack: some View {
        VStack {
            header("Your Badges")
            ForEach(sortedUnlockedBadges) { badge in
                Text(badge.details.title)
            }
            
            header("Locked Badges")
            ForEach(sortedLockedBadges) { badge in
                Text(badge.details.title)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
    
    /// Método que devuelve un encabezado de sección con el estilo adecuado. Úsalo para mostrar los encabezados de los distintivos de desbloqueado y bloqueado.
    /// Se lo hace con función porque necesito que el texto cambie mientras que en una propiedad computada no recibe parámetros, una propiedad computada sirve para vistas fijas.
    func header(_ text: String) -> some View {
        Text(text)
            .font(.subheadline.bold())
            .padding()
    }
    
    /// Ordena las insignias desbloqueadas por marca de tiempo y luego por título. Esto muestra las insignias en el orden en que se desbloquean. Cuando un mismo momento desbloquea varias insignias, los valores de la marca de tiempo coinciden, por lo que usar el título permite ordenar de forma consistente. Las insignias desbloqueadas tienen una marca de tiempo, como lo exige la consulta, por lo que forzar el desempaquetado con `timestamp!` es seguro. Documenta esta condición previa en la función para futuras consultas.
    /// La comparación lo hace mediante el uso de tuplas ($0.timestamp!, $0.details.title) porque Swift sabe comparar tuplas automáticamente
    /// Swift compara: primer elemento si empatan → segundo elemento si empatan → tercero etc.
    /// Se usa ! porque se le dice al compilador de que estoy seguro de que el valor no es nil, eso se llama un force unwrap
    /// El timestamp está declarado así: var timestamp: Date? entonces normalmente Swift obligaría a hacer esto: if let timestamp = badge.timestamp { }
    /// En conclusión: Compara dos insignias usando primero la fecha y luego el título.
    private var sortedUnlockedBadges: [Badge] {
        unlockedBadges.sorted {
            ($0.timestamp!, $0.details.title) < ($1.timestamp!, $1.details.title)
        }
    }
    
    /// Para crear un orden consistente, ordene las insignias bloqueadas en el orden en que se declaran utilizando el valor sin procesar de la enumeración details. Las insignias pueden desbloquearse en diferentes órdenes, pero .firstEntry siempre es la primera en desbloquearse y .perfectTen siempre es la última.
    private var sortedLockedBadges: [Badge] {
        lockedBadges.sorted { $0.details.rawValue < $1.details.rawValue }
    }
}

#Preview {
    AchievementsView()
        .sampleDataContainer()
}
