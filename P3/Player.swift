//
//  Player.swift
//  P3
//
//  Created by Elora on 29/04/2022.
//

import Foundation

// Player class, create his team, choose character in team and make the choice to attack or heal
class Player {
    // name of the player
    var name: String
    // checks that the player is alive according to the living characters of his squad
    var isAlive: Bool {
        if (squad.first(where: {$0.isAlive}) != nil) {
            return true
        } else {
            return false
        }
    }

    // the squad/team of the player
    var squad: [BaseType] = []
    
    init(name: String){
        self.name = name
    }
    
    // function of team creation, continue as long as the squad array
    func createSquad() {
        
        var squad: [BaseType] = []
        while squad.count < 3 {
            
            print("les nom déjà pris sont : \(Game.charactersNames)")
            print("\(self.name) ajouter un personnage à votre équipe : tapez guerrier ou mage ou nain")
            let characterTypeChoosed = Utils.checkReadLine()
            let perso: BaseType?
            
            switch characterTypeChoosed {
            case "guerrier":
                print("Donnez un nom à votre Guerrier")
                let warriorName = Utils.checkReadLine()
                perso = Warrior(name: warriorName)
                
            case "mage":
                print("Donnez un nom à votre mage")
                let magusName = Utils.checkReadLine()
                perso = Magus(name: magusName)
                
            case "nain":
                print("donnez un nom à votre nain")
                let dwarfName = Utils.checkReadLine()
                perso = Dwarf(name: dwarfName)
                
                
            default:
                print("Nous n'avons pas compris votre choix")
                perso = nil
            }
// unwrap the optional, check that the name is not already taken and add the name to the list of taken names
            if let perso = perso,
               Game.charactersNames.first(where: {$0 == perso.name}) == nil {
                squad.append(perso)
                Game.charactersNames.append(perso.name)
            } else {
                print("erreur, recommencez !")
            }
        }
        // fill the empty squad array
        self.squad = squad
        
        // update the pv's squad
//        self.updateSquadPv(player: self)
    }
    
    
    // function that checks that the readline contains something and that the entry corresponds to a character in an array of a team given in parameter
    
    func choseInSquad(player: Player) -> BaseType {
        // if the readline is not empty put the content in the variable and move on, if empty replay the function
        let choice = Utils.checkReadLine()
        // compare the previous variable content to each character in squad, if find match return it, if not replay the function
        guard let characterChosen = player.squad.first(where: { $0.name == choice && $0.isAlive}) else {
            print("aucun personnage vivant ne corresponds à ce nom, choisissez à nouveau un personnage")
            return choseInSquad(player: player)
        }
        return characterChosen
        
    }
    
    // asks the player to make a choice between attacking an opponent or healing a teammate
    func attackOrHeal(playerAttacking: Player, playerAttacked: Player) {
        
        print("\(playerAttacking.name), souhaitez vous attaquer vos adversaires ou soigner vos personnages? Entrez attaquer ou soigner")
        //  optional unwrapping function
        let attackOrHealChoice = Utils.checkReadLine()
        //  if attack chosed
        if attackOrHealChoice == "attaquer" {
            print("choisissez un de vos combatant")
            // chose a character to fight whith the function checking readline and array
            let fighter = choseInSquad(player: playerAttacking)
            print("choisissez un ennemi dans l'équipe adverse : \(playerAttacked.squad.map({$0.name}))")
            // chose a character enemy whith the function checking readline and array
            let enemy = choseInSquad(player: playerAttacked)
            print("\(enemy.name) enemi à \(enemy.pv) points de vie")
            // launch the attack methode of character
            fighter.attack(enemy: enemy)
            print("\(enemy.name) enemi n'a plus que \(enemy.pv) de points de vie")
//            updateSquadPv(player: playerAttacked)
            // if heal chosed
        } else if attackOrHealChoice == "soigner" {
            // check that there is a mage alive in the squad
            guard let magus = playerAttacking.squad.first(where: { $0.healCapacity == true && $0.isAlive}) else {
                print("\(playerAttacking.name), vous n'avez aucun Mage vivant dans votre équipe")
                // if not return to the attack or heal choice function
                return attackOrHeal(playerAttacking: playerAttacking, playerAttacked: playerAttacked)
            }
            print("\(playerAttacking.name), votre mage est appelé, choisissez le personnage blessé que vous voulez soigner")
            
            //if there is a mage alive, chose a teammate to heal
            let injuredTeammate = choseInSquad(player: playerAttacking)
            print("\(injuredTeammate.name) blessé n'a plus que \(injuredTeammate.pv) points de vie")
            // heal the teammate chosed
            magus.heal(injuredTeamMate: injuredTeammate)
            print("\(injuredTeammate.name) soigné à maintenant \(injuredTeammate.pv) points de vie")
//            updateSquadPv(player: playerAttacking)
        } else {
            print("vous n'avez pas fait votre choix, tapez attaquer ou soigner")
            attackOrHeal(playerAttacking: playerAttacking, playerAttacked: playerAttacked)
        }
    }
    
}
