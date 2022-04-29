//
//  Dwarf.swift
//  P3
//
//  Created by Elora on 29/04/2022.
//

import Foundation


// class that inherits from the BaseType class
class Dwarf: BaseType {
    
    
    init(name: String) {
        super.init(pv: 25, weapon: .axe, healCapacity: false, name: name)
    }
}
