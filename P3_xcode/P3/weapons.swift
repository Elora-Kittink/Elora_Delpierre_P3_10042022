//
//  weapons.swift
//  P3
//
//  Created by Elora on 29/04/2022.
//

import Foundation

// enumeration of weapons available in the game with their respective damages
enum weapons {
    case sword
    case axe
    case arch
    
    var damages: Int {
        switch self {
        case .sword: return 50
        case .axe: return 75
        case .arch: return 25
        }
    }
}
