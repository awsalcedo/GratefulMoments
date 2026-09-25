//
//  BadgeDetailView.swift
//  GratefulMoments
//
//  Created by usradmin on 13/5/26.
//

import SwiftUI

struct UnlockedBadgeView: View {
    var badge: Badge
    
    var body: some View {
        /// Envuelve toda la vista en un NavigationLink que dirija a BadgeDetailView.
        /// En la vista previa, inserta la vista de insignia en un NavigationStack para asegurar que la navegación funcione correctamente.
        NavigationLink {
            BadgeDetailView(badge: badge)
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                Image(badge.details.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 70, height: 70)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Text(badge.details.title)
                    .font(.headline.bold())
                
                Text(badge.details.requirements)
                    .font(.caption2.bold())
                
                Spacer()
                
                /// Muestra la marca de tiempo de las insignias desbloqueadas. Recuerda que las marcas de tiempo solo aparecen en las insignias desbloqueadas.
                if let timestamp = badge.timestamp {
                    Text(timestamp, style: .date)
                        .font(.caption2.bold())
                }
            }
            .padding()
            .frame(width: 210, height: 225)
            .multilineTextAlignment(.leading)
            .foregroundStyle(.white)
            .background(badge.details.color.opacity(0.8))
            .clipShape(RoundedRectangle(cornerRadius: 16.0))
        }
    }
}

#Preview {
    NavigationStack {
        UnlockedBadgeView(badge: .sample)
    }
}
