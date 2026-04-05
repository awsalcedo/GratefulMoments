//
//  Hexagon.swift
//  GratefulMoments
//
//  Created by ALEX WLADIMIR SALCEDO SILVA on 29/3/26.
//

import SwiftUI

/*
 Hexagon acepta contenido de otras vistas, así que incluye un tipo Content genérico en la declaración de la estructura. Declara una propiedad @ViewBuilder para poder pasar fácilmente cualquier vista de SwiftUI. Reemplaza el cuerpo con el contenido y mueve el marcador de posición a la vista previa.
 */

struct Hexagon<Content: View>: View {
    private let borderWidth = 2.0
    var borderColor: Color = .ember
    var size: CGFloat = 350
    var moment: Moment? = nil
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        ZStack {
            if let backkground = moment?.image {
                Image(uiImage: backkground)
                    .resizable()
                    .scaledToFill()
            }
            content()
                .frame(width: size, height: size)
        }
        /*
         Transforma la vista en un hexágono aplicando una máscara que oculte todo lo que se encuentre detrás del símbolo SF hexagonal.

         La máscara es una herramienta útil al usar formas irregulares o mostrar contenido que excede el área de visualización.
         */
        .mask{
            Image(systemName: "hexagon.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size - borderWidth, height: size - borderWidth)
        }
        .background {
            Image(systemName: "hexagon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size, height: size)
                .foregroundStyle(borderColor)
        }
        .frame(width: size, height: size)
    }
}

#Preview {
    Hexagon(moment: Moment.imageSample) {
        Text(Moment.imageSample.title)
            .foregroundStyle(Color.white)
    }
    .sampleDataContainer()
}
