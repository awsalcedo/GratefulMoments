//
//  MomentDetailView.swift
//  GratefulMoments
//
//  Created by ALEX WLADIMIR SALCEDO SILVA on 29/3/26.
//

import SwiftUI
import SwiftData

struct MomentDetailView: View {
    var moment: Moment
    @State private var showConfirmation = false
    
    @Environment(\.dismiss) private var dismiss
    @Environment(DataContainer.self) private var dataContainer

    var body: some View {
        ScrollView {
            contentStack
        }
        .navigationTitle(moment.title)
        .toolbar {
            ToolbarItem(placement: .destructiveAction) {
                Button {
                    showConfirmation = true
                } label: {
                    Image(systemName: "trash")
                }
                .confirmationDialog("Delete Moment", isPresented: $showConfirmation) {
                    Button("Delete Moment", role: .destructive) {
                        // Eliminar el momento del contenedor de datos
                        dataContainer.context.delete(moment)
                        try? dataContainer.context.save()
                        // Cerrar la vista de detalles después de eliminar el momento
                        dismiss()
                    }
                } message: {
                    Text("The moment will be permanently deleted. Earned badges won't be removed.")
                }
            }
        }
    }

    private var contentStack: some View {
        VStack(alignment: .leading) {
            Text(moment.timestamp, style: .date)
                .font(.subheadline)
            if !moment.note.isEmpty {
                Text(moment.note)
                    .textSelection(.enabled) // El modificador .textSelection permite a los usuarios mantener pulsado un
                // botón para copiar el texto.
            }
            // Comprobar que la imagen exista antes de mostrarla, desempaqueta de forma segura la propiedad de imagen
            // opcional
            if let image = moment.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

#Preview {
    NavigationStack {
        MomentDetailView(moment: .imageSample)
            .sampleDataContainer()
    }
}
