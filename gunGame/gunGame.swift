//
//  gunGame.swift
//  gunGame
//
//  Created by Vitaly Volshin on 02.10.2024.
//

import Foundation

@main
struct Quest5 {
    static func main() throws {
        let players = createPlayers()
        
        let server = Server(serverName: "school", players: players)
        for player in players {
            player.playerActionDelegate = server
        }
        
        let own = players[0]
        if let opponent = own.requestOpponent() {
            let matchResult = own.startMatch(with: opponent)
            
            if matchResult {
                print("You WIN\n")
                print("\(own.nickname) winner")
            } else {
                print("You LOSE\n")
                print("\(opponent.nickname) winner")
            }
        } else {
            print("There are no available opponents")
        }
    }
}

func createPlayers() -> [Profile] {
    let revolverCaliber = setRandomRevolverCaliber()
    let riffleCaliber = setRandomRiffleCaliber()
    
    let player_1 = Profile(nickname: "blancara", age: 24,
                           gun: Revolver(name: "Revolver", caliber: revolverCaliber),
                           accountCreated: "13.09.2023", status: .SEARCH)
    let player_2 = Profile(nickname: "carlottc", age: 28,
                           gun: Riffle(name: "AWP", caliber: riffleCaliber),
                           accountCreated: "21.09.2024", status: .SEARCH)
    let player_3 = Profile(nickname: "santagam", age: 22, gun: Knife(name: "Butterfly knife", damage: 10),
                           accountCreated: "14.05.2024", status: .SEARCH)
    return [player_1, player_2, player_3]
}

func setRandomRevolverCaliber() -> Caliber? {
    let revolverCaliberRange = Caliber.allCases.filter( { return $0 != .v50})
    
    if let caliber = revolverCaliberRange.randomElement() {
        return caliber
    } else {
        return nil
    }
}

func setRandomRiffleCaliber() -> Caliber? {
    let riffleCaliberRange = Caliber.allCases.filter(
        { return $0 == .v38 || $0 == .v45 || $0 == .v50}
    )
    
    if let caliber = riffleCaliberRange.randomElement() {
        return caliber
    } else {
        return nil
    }
}
