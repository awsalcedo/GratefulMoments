//
//  MomentEntryView.swift
//  GratefulMoments
//
//  Created by ALEX WLADIMIR SALCEDO SILVA on 11/3/26.
//

import PhotosUI
import SwiftData
import SwiftUI

struct MomentEntryView: View {
    @State private var title = ""
    @State private var note = ""
    @State private var imageData: Data?
    @State private var newImage: PhotosPickerItem?
    @State private var isShowingCancelConfirmation = false

    @Environment(\.dismiss) private var dismiss

    /// utilice el modificador .sampleDataContainer() para configurar SwiftData y las entradas de Moment de ejemplo para
    /// la vista previa. Acceda a DataContainer a través del environment.
    @Environment(DataContainer.self) private var dataContainer

    var body: some View {
        NavigationStack {
            ScrollView {
                contentStack
            }
            // Para ocultar el teclado al desplazarse fuera de la pantalla
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("Grateful For")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", systemImage: "xmark") {
                        if title.isEmpty, note.isEmpty, imageData == nil {
                            dismiss()
                        } else {
                            isShowingCancelConfirmation = true
                        }
                    }
                    .confirmationDialog("Discard Moment", isPresented: $isShowingCancelConfirmation) {
                        Button("Discard Moment", role: .destructive) {
                            dismiss()
                        }
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Add", systemImage: "checkmark") {
                        let newMoment = Moment(
                            title: title,
                            note: note,
                            imageData: imageData,
                            timestamp: .now
                        )
                        dataContainer.context.insert(newMoment)
                        do {
                            try dataContainer.context.save()
                            dismiss()
                        } catch { }
                    }
                }
            }
        }
    }

    // PhotosPickerItem representa la imagen seleccionada de la biblioteca de fotos. La usarás para guardar la imagen.
    // PhotosPicker funciona como un botón, con una gran área para pulsar, y su icono se personaliza con el color de
    // acento de tu aplicación.

    private var photoPicker: some View {
        PhotosPicker(selection: $newImage) {
            Group {
                if let imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                } else {
                    Image(systemName: "photo.badge.plus.fill")
                        .font(.largeTitle)
                        .frame(height: 250)
                        .frame(maxWidth: .infinity)
                        .background(Color(white: 0.4, opacity: 0.32))
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        // Responda a la selección de fotos con un modificador .onChange.
        .onChange(of: newImage) {
            guard let newImage else { return }
            // carga la foto seleccionada en la aplicación mediante una tarea asíncrona.
            Task {
                // La función `loadTransferable` transfiere la imagen de la biblioteca de Fotos a tu aplicación en el
                // formato de datos solicitado.
                imageData = try await newImage.loadTransferable(type: Data.self)
            }
        }
    }

    var contentStack: some View {
        VStack(alignment: .leading) {
            TextField(text: $title) {
                Text("Title (Required)")
            }
            .font(.title.bold())
            .padding(.top, 48)
            Divider()

            TextField("Log your small wins", text: $note, axis: .vertical)
                .multilineTextAlignment(.leading)
                .lineLimit(5 ... Int.max) // al menos 5 lineas y todo el texto que deseen

            photoPicker
        }
        .padding()
    }
}

#Preview {
    MomentEntryView()
        .sampleDataContainer()
}
