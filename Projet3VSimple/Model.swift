//
//  Model.swift
//  Projet3VSimple
//
//  Created by Elora on 11/04/2022.
//

import Foundation



// MARK: -

// used to unwrap the many ReadLines
class Utils {
    
    static func checkReadLine() -> String {
        guard let line = readLine() else {
            print("vous n'avez pas répondu, recommencez")
            return checkReadLine()
        }
        return line
    }
}

class Game {
    
    var numberOfPlayer = 2
// array containing all the players of a game
    var players: [Player] = []
// counter of rounds playing
    var turnsCount = 0
// array of all the character's names of both squad
    static var charactersNames: [String] = []
    
    
// determines the player whose turn it is based on the number of turns
    func playerTurn() -> (Player, Player) {
        let playerTurnIndex = turnsCount % numberOfPlayer
        let playerNextIndex = (turnsCount + 1) % numberOfPlayer
        let playingFirst = players[playerTurnIndex]
        let playingNext = players[playerNextIndex]
        
        return (playingFirst, playingNext)
    }
    
// launch the squad creation, check if there are still fighters alive, if yes launch the attack, if no announce a winner
    func startPlaying() {
        for player in players {
            player.createSquad()
        }
        while playerTurn().0.squadPv > 0 {
        playersAttacking(playerAttacking: playerTurn().0, playerOpponent: playerTurn().1)
        }
        print("\(playerTurn().1.name) a gagné !")
        playerTurn().1.winner = true
        printStatistic(turnsCount: turnsCount)
    }
    
// fills the player array as long as it is not full
    func createPlayers(){
        while players.count < numberOfPlayer {
            createPlayer()
        }
    }
    
// creates a player and puts him in the array
    func createPlayer() {
        print("Comment s'appelle le joueur?")
        let playerOneName = Utils.checkReadLine()
        players.append(Player(name: playerOneName))
    }
    
    
// launches the action of the player whose turn it is and increments the turn counter
    func playersAttacking(playerAttacking: Player, playerOpponent: Player){
            print("\(playerAttacking.name) joue :")
            playerAttacking.attackOrHeal(playerAttacking: playerAttacking, playerAttacked: playerOpponent)
            turnsCount += 1
        
    }
    
    
    
    // displays the statistics of the finished game
    func printStatistic(turnsCount: Int) {
        print("la partie s'est terminée en \(turnsCount) tours !")
        for player in players {
            print("voici les personnages de l'équipe \(player.name) :")
            for character in player.playerSquad {
                print(character.name, "avec \(character.pv) de pv, une arme de type \(character.weapon) qui inflige \(character.weapon.damages) de dégats")
            }
            
        }
    }
}

// Player class, create his team, choose character in team and make the choice to attack or heal
class Player {
// name of the player
    var name: String
// is the player is winner?
    var winner: Bool = false
// the squad/team of the player
    var playerSquad: [BaseType] = []
    
    var squadPv = 0
// accumulate the pv of all characters to determine the total pv of the squad
    func updateSquadPv(player: Player){
        player.squadPv = 0
        for character in player.playerSquad {
            player.squadPv += character.pv
        }
    }
    
    init(name: String){
        self.name = name
    }
    
// function of team creation, continue as long as the squad array
    func createSquad() {

        var squad: [BaseType] = []
        while squad.count < 3 {
            
            print("les nom déjà pris sont : \(Game.charactersNames)")
            print("ajouter un personnage à votre équipe : tapez guerrier ou mage ou colosse ou nain")
            let characterTypeChoosed = Utils.checkReadLine()
            switch characterTypeChoosed {
            case "guerrier":
                print("Donnez un nom à votre Guerrier")
                 let warriorName = Utils.checkReadLine()
                if Game.charactersNames.first(where: {$0 == warriorName}) == nil {
                    let warriorCharacter = Warrior(name: warriorName)
                    squad.append(warriorCharacter)
                    Game.charactersNames.append(warriorName)
                } else {
                    print("ce nom est déjà pris !")
                }
                
                
            case "mage":
                print("Donnez un nom à votre mage")
               let magusName = Utils.checkReadLine()
                if  Game.charactersNames.first(where: {$0 == magusName}) == nil{
                    let magusCharacter = Magus(name: magusName)
                    squad.append(magusCharacter)
                    Game.charactersNames.append(magusName)
                } else {
                    print("ce nom est déjà pris !")
                }
                
                           
            case "nain":
                print("donnez un nom à votre nain")
              let dwarfName = Utils.checkReadLine()
                if  Game.charactersNames.first(where: {$0 == dwarfName}) == nil{
                    let dwarfCharacter = Dwarf(name: dwarfName)
                    squad.append(dwarfCharacter)
                    Game.charactersNames.append(dwarfName)
                } else {
                    print("ce nom est déjà pris !")
                }
                
                
            default:
                print("Nous n'avons pas compris votre choix, recommencez")
            }
            
        }
// fill the empty squad array
        self.playerSquad = squad
        
// update the pv's squad
        self.updateSquadPv(player: self)
    }
    
    
// function that checks that the readline contains something and that the entry corresponds to a character in an array of a team given in parameter
    
    func choseInSquad(player: Player) -> BaseType {
// if the readline is not empty put the content in the variable and move on, if empty replay the function
        let choice = Utils.checkReadLine()
// compare the previous variable content to each character in squad, if find match return it, if not replay the function
        guard let characterChosen = player.playerSquad.first(where: { $0.name == choice && $0.pv > 0}) else {
            print("\(player.name) aucun personnage ne corresponds à ce nom, choisissez à nouveau un personnage")
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
                print("les personnage dans la partie sont : \(Game.charactersNames)")
                print("choisissez un de vos combatant")
// chose a character to fight whith the function checking readline and array
                let fighter = choseInSquad(player: playerAttacking)
                print("choisissez un ennemi dans l'équipe de \(playerAttacked.name)")
// chose a character enemy whith the function checking readline and array
                let enemy = choseInSquad(player: playerAttacked)
                print("\(enemy.name) enemi à \(enemy.pv) points de vie")
// launch the attack methode of character
                fighter.attack(enemy: enemy)
                print("\(enemy.name) enemi n'a plus que \(enemy.pv) de points de vie")
                updateSquadPv(player: playerAttacked)
// if heal chosed
            } else if attackOrHealChoice == "soigner" {
// check that there is a mage alive in the squad
                guard let magus = playerAttacking.playerSquad.first(where: { $0.healCapacity == true && $0.pv >= 0}) else {
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
                updateSquadPv(player: playerAttacking)
            } else {
                print("vous n'avez pas fait votre choix, tapez attaquer ou soigner")
                attackOrHeal(playerAttacking: playerAttacking, playerAttacked: playerAttacked)
            }
        }

    }
    

// class with empty basic characteristics

class BaseType {
    
    var pv: Int
    var weapon: weapons
    var healCapacity: Bool
    var name: String

    
    init(pv: Int, weapon: weapons, healCapacity: Bool, name: String) {
        
        self.pv = pv
        self.weapon = weapon
        self.healCapacity = healCapacity
        self.name = name
    }
// attack function
    func attack(enemy: BaseType) {
        enemy.pv -= self.weapon.damages
        if enemy.pv < 0 {
            enemy.pv = 0
        }
    }
// heal teammate function set as not available basically
    func heal(injuredTeamMate: BaseType){
        print("ce personnage ne peut pas soigner")
    }
}


// class that inherits from the BaseType class
class Warrior: BaseType {
    
    init(name: String) {
        super.init(pv: 50, weapon: .sword, healCapacity: false, name: name)
        
    }
}



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


// class that inherits from the BaseType class
class Dwarf: BaseType {
    
    
    init(name: String) {
        super.init(pv: 25, weapon: .axe, healCapacity: false, name: name)
    }
}

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



