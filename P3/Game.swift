//
//  Model.swift
//  Projet3VSimple
//
//  Created by Elora on 11/04/2022.
//

import Foundation



// MARK: -



class Game {
    
    var numberOfPlayer = 2
    // array containing all the players of a game
    var players: [Player] = []
    
    var playersAlive: [Player] {
        players.filter{$0.isAlive}
    }
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
        
        createPlayers()
        
        for player in players {
            player.createSquad()
        }
        while playersAlive.count > 1 {
            playersAttacking(playerAttacking: playerTurn().0, playerOpponent: playerTurn().1)
        }
        print("\(playerTurn().1.name) a gagné !")
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
        let newPlayerName = Utils.checkReadLine()
        players.append(Player(name: newPlayerName))
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
            for character in player.squad {
                print(character.name, "avec \(character.pv) de pv, une arme de type \(character.weapon) qui inflige \(character.weapon.damages) de dégats")
            }
            
        }
    }
}



















