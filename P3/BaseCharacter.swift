//
//  BaseType.swift
//  P3
//
//  Created by Elora on 29/04/2022.
//

import Foundation

// class with empty basic characteristics

class BaseCharacter {
    
    var pv: Int
    var weapon: weapons
    var healCapacity: Bool
    var name: String
    var isAlive = true
    var pvMax: Int
    
    
    init(pv: Int, weapon: weapons, healCapacity: Bool, name: String, pvMax: Int) {
        
        self.pv = pv
        self.weapon = weapon
        self.healCapacity = healCapacity
        self.name = name
        self.pvMax = pvMax
    }
    // attack function
    func attack(enemy: BaseCharacter) {
        enemy.pv -= self.weapon.damages
        if enemy.pv < 0 {
            enemy.isAlive = false
        }
    }
    // heal teammate function set as not available basically
    func heal(injuredTeamMate: BaseCharacter){
        print("ce personnage ne peut pas soigner")
    }
}
