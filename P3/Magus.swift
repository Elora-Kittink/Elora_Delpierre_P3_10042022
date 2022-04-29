//
//  Magus.swift
//  P3
//
//  Created by Elora on 29/04/2022.
//

import Foundation

// class that inherits from the BaseType class
class Magus: BaseType {
    // override the heal function of mother class to allow Magus to heal
    override func heal(injuredTeamMate: BaseType) {
        injuredTeamMate.pv += 10
    }
    
    init(name: String) {
        super.init(pv: 50, weapon: .arch, healCapacity: true, name: name)
    }
}
