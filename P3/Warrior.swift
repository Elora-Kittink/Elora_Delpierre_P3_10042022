//
//  Warrior.swift
//  P3
//
//  Created by Elora on 29/04/2022.
//

import Foundation

// class that inherits from the BaseType class
class Warrior: BaseType {
    
    init(name: String) {
        super.init(pv: 50, weapon: .sword, healCapacity: false, name: name)
        
    }
}
