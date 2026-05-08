//
//  HexagonLayout.swift
//  GratefulMoments
//
//  Created by ALEX WLADIMIR SALCEDO SILVA on 7/5/26.
//

import SwiftUI

/// Proporcionará información de tamaño para el hexágono permitiendo diferentes diseños
enum HexagonLayout {
    case standard
    case large
    
    var size: CGFloat {
        switch self {
        case .standard:
            return 200.0
        case .large:
            return 350.0
        }
    }
    
    var timestampBottomPadding: CGFloat {
        0.08
    }
    
    var textBottomPadding: CGFloat {
        0.25
    }
    
    var timestampHeight: CGFloat {
        size * (textBottomPadding - timestampBottomPadding)
    }
    
    var titleFont: Font {
        switch self {
        case .standard:
            return .headline
        case .large:
            return .title.bold()
        }
    }
    
    var bodyFont: Font {
        switch self {
        case .standard:
            return .caption2
        case .large:
            return .body
        }
    }
}
