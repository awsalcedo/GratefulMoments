//
//  HexagonAccesoryView.swift
//  GratefulMoments
//
//  Created by usradmin on 25/9/26.
//

import SwiftUI

struct HexagonAccesoryView: View {
    let moment: Moment
    let hexagonLayout: HexagonLayout
    
    var body: some View {
        
        NavigationLink {
            if badges.count == 1 {
                BadgeDetailView(badge: badges[0])
            } else {
                MomentDetailView(moment: moment)
            }
        } label: {
            badgeView
        }
    }
    
    private var badgeView: some View {
        Group {
            if badges.count > 1 {
                Text("+\(badges.count)")
                    .bold()
                    .frame(width: size * 0.5, height: size * 0.5)
                    .padding(8)
                    .background {
                        Image("Blank")
                            .resizable()
                            .frame(width: size, height: size)
                            .shadow(radius: 2)
                    }
                    .foregroundStyle(.gray)
            } else if let badge = badges.first {
                Image(badge.details.image)
                    .resizable()
                    .frame(width: size, height: size)
                    .shadow(radius: 2)
            }
        }
        .offset(y: yOffset)
    }
    
    private var yOffset: CGFloat {
        let radius = hexagonLayout.size / 2
        
        /// 30 grados apuntan a la esquina superior derecha de un hexágono.
        let yOffsetFromHexagonCenter = sin(Angle.degrees(30).radians) * radius
        return radius - yOffsetFromHexagonCenter - (size / 2)
    }
    
    private var badges: [Badge] {
        moment.badges
    }
    
    /// Define el tamaño de la vista accesoria como 1/5 del tamaño del hexágono. Las vistas accesorias suelen ser mucho más pequeñas que las vistas a las que complementan.
    /// Al establecer el tamaño del accesorio como un porcentaje del tamaño de la vista principal, el accesorio se verá bien incluso si añades tamaños a HexagonLayout.
    private var size: CGFloat {
        hexagonLayout.size / 5
    }
}

#Preview("Single badge") {
    MomentHexagonView(moment: .sample, layout: .large)
        .sampleDataContainer()
}

#Preview("Multiple badges") {
    MomentHexagonView(moment: .imageSample, layout: .large)
        .sampleDataContainer()
}
