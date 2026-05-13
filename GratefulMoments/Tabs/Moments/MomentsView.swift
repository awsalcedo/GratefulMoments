//
//  MomentsView.swift
//  GratefulMoments
//
//  Created by ALEX WLADIMIR SALCEDO SILVA on 28/3/26.
//

import SwiftData
import SwiftUI

struct MomentsView: View {
    @State private var showCreateMoment = false
    /// Agrega una query para recuperar los Moments guardados del data store
    @Query(sort: \Moment.timestamp)
    private var moments: [Moment]
    
    static let offsetAmount: CGFloat = 70.0

    var body: some View {
        NavigationStack {
            ScrollView {
                pathItems
                    .frame(maxWidth: .infinity)
            }
            .overlay {
                if moments.isEmpty {
                    ContentUnavailableView {
                        Label("No moments yet!", systemImage: "exclamationmark.circle.fill")
                    } description: {
                        Text("Post a note or photo to start filling this space with gratitude.")
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showCreateMoment = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .sheet(isPresented: $showCreateMoment) {
                        MomentEntryView()
                    }
                }
            }
            /// Utilice .defaultScrollAnchor para configurar la vista de desplazamiento de modo que se muestre el momento más reciente. .defaultScrollAnchor controla la posición del contenido en ScrollView. ScrollAnchorRole ofrece personalización según diferentes roles. Su initialOffset determina la posición inicial de desplazamiento, y su sizeChanges determina los ajustes de diseño cuando cambia el tamaño del contenido, por ejemplo, cuando se agrega o elimina un momento.
            .defaultScrollAnchor(.bottom, for: .initialOffset)
            .defaultScrollAnchor(.bottom, for: .sizeChanges)
            /// Alinea el ScrollView en la parte superior cuando su contenido quepa en la pantalla para que coincida con el comportamiento predeterminado de la lista. En la vista previa sin momentos, agrega un ModelContainer y guarda un nuevo momento para probar el cambio. ScrollAnchorRole.alignment se refiere a cómo una vista de desplazamiento debe alinear su contenido cuando el tamaño de su contenido es menor que el tamaño del contenedor de la vista de desplazamiento.
            .defaultScrollAnchor(.top, for: .alignment)
            .navigationTitle("Grateful Moments")
        }
    }

    private var pathItems: some View {
        /// Al usar la función .enumerated() en el array moments, se obtiene acceso al índice de cada elemento. La función sin utiliza el índice para crear un valor oscilante, lo que resulta en un patrón en zigzag. Almacenar la magnitud del desplazamiento en una constante estática facilita el ajuste del efecto.
        ForEach(moments.enumerated(), id: \.0) { index, moment in
            NavigationLink {
                MomentDetailView(moment: moment)
            } label: {
                if moment == moments.last {
                    MomentHexagonView(moment: moment, layout: .large)
                } else {
                    MomentHexagonView(moment: moment)
                        .offset(x: sin(Double(index) * .pi / 2) * Self.offsetAmount)
                }
            }
            /// Aplica una transición personalizada a medida que los momentos se desplazan dentro o fuera de la pantalla usando .scrollTransition. Desaparece por completo al desplazarse y reduce el tamaño del hexágono al 80%. La fase de transición se refiere a la etapa en la que se encuentra una vista durante una transición, como aparecer o desaparecer mediante el desplazamiento. La fase de identidad se refiere a cuando el contenido se muestra normalmente, en lugar de estar en transición.
            .scrollTransition { content, phase in
                content
                    .opacity(phase.isIdentity ? 1 : 0)
                    .scaleEffect(phase.isIdentity ? 1 : 0.8)
            }
        }
    }
}

#Preview {
    MomentsView()
        .sampleDataContainer() // Configura la vista previa con datos de ejemplo
}

#Preview("No moments") {
    MomentsView()
        .modelContainer(for: [Moment.self])
        .environment(DataContainer())
}
