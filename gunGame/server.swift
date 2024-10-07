//
//  server.swift
//  gunGame
//
//  Created by Vitaly Volshin on 02.10.2024.
//

import Foundation

protocol PlayerAction: AnyObject {
    func findOpponent(for player: Profile) -> Profile?
    func fight(for player: Profile, opponent: Profile) -> Bool
}

class Server: PlayerAction {
    let serverName: String
    var players: [Profile] = []
    
    init(serverName: String, players: [Profile]) {
        self.serverName = serverName
        self.players = players
    }
    
    func findOpponent(for player: Profile) -> Profile? {
        let playersInSearch = players.filter( { return $0.status == .SEARCH && $0.id != player.id})
        
        if let playerToGo = playersInSearch.randomElement() {
            return playerToGo
        }
        
        return nil
    }
    
    func fight(for player: Profile, opponent: Profile) -> Bool {
        player.supply = generateSupply(for: player)
        opponent.supply = generateSupply(for: opponent)
        
        loadGun(for: player)
        loadGun(for: opponent)
        
        print("MyProfile nickname - \"\(player.nickname)\", weapon - \(player.gun.name), damage - \(player.gun.damage)")
        print("Opponent nickname - \"\(opponent.nickname)\", weapon - \(opponent.gun.name), damage - \(opponent.gun.damage)")
        
        for gamer in [player, opponent] {
            if let _ = gamer.gun as? Revolver {
                initialScroll(for: gamer)
            }
        }
        
        print("\nFight!\n")
        print("\(player.nickname) \(player.health) - \(opponent.health) \(opponent.nickname)\n")

        while (player.health > 0 && opponent.health > 0) && (!player.supply.isEmpty || !opponent.supply.isEmpty || !player.gun.isEmpty || !opponent.gun.isEmpty)  {
            let players = [player, opponent].shuffled()
            let attacker = players[0]
            let defender = players[1]
            
            print("\(attacker.nickname) shoot")

            if !canShoot(for: attacker) {
                print("\(player.nickname) \(player.health) - \(opponent.health) \(opponent.nickname)\n")
                continue
            }

            loadGun(for: attacker)
            
            let damage = attacker.gun.shoot() as? Int ?? 0
            defender.health -= damage
            print("\(player.nickname) \(player.health) - \(opponent.health) \(opponent.nickname)\n")
        }
        
        return opponent.health <= 0
    }
    
    private func loadGun(for gamer: Profile) {
        if let revolver = gamer.gun as? Revolver {
            if !revolver.isEmpty {
                return
            }
        
            _ = revolver.unloadAll()
            
            for bullet in gamer.supply {
                _ = revolver.add(bullet)
            }
            gamer.supply = Array(gamer.supply.dropFirst(6))
        }
        
        if let riffle = gamer.gun as? Riffle {
            if !riffle.isEmpty {
                return
            }
            
            if let firstBullet = gamer.supply.first {
                do {
                    _ = try riffle.add(firstBullet)
                } catch {
                    print("Unsuitable bullet caliber")
                }
                gamer.supply.removeFirst(1)
            }
        }
    }
    
    private func canShoot(for gamer: Profile) -> Bool {
        if let revolver = gamer.gun as? Revolver {            
            if revolver.isEmpty && !gamer.supply.isEmpty {
                print("\(gamer.nickname) drum is empty")
                print("\(gamer.nickname) adding elements")
                loadGun(for: gamer)
                print("\(gamer.nickname) scrolling")
                revolver.scroll()
                return false
            }
            
            if revolver.isEmpty && gamer.supply.isEmpty {
                print("\(gamer.nickname)'s drum is empty and out of supply")
            }
            return !revolver.isEmpty
        }
        
        if let riffle = gamer.gun as? Riffle {
            if riffle.isEmpty && !gamer.supply.isEmpty {
                loadGun(for: gamer)
            }
            
            if riffle.isEmpty && gamer.supply.isEmpty {
                print("\(gamer.nickname)'s drum is empty and out of supply")
                return false
            }
            
            return !riffle.isEmpty
        }
        
        if let _ = gamer.gun as? Knife {
            return true
        }
        
        return false
    }
    
    private func generateSupply(for gamer: Profile) -> [Patron] {
        if let revolver = gamer.gun as? Revolver, let caliber = revolver.caliber {
            return generateBullets(caliber: caliber, clipSize: 12)
        }
        
        if let riffle = gamer.gun as? Riffle, let caliber = riffle.caliber {
            return generateBullets(caliber: caliber, clipSize: 4)
        }
        
        if let _ = gamer.gun as? Knife {
            return []
        }
        
        return []
    }
    
    private func generateBullets(caliber: Caliber, clipSize: Int) -> [Patron] {
        var bullets: [Patron] = []
        for _ in 1...clipSize {
            let bulletRandom = Bool.random()
            let status: PatronStatus = bulletRandom ? .charged : .damp
            let bullet = Patron(status: status, caliber: caliber)
            bullets.append(bullet)
        }
        
        return bullets
    }
    
    private func initialScroll(for gamer: Profile) {
        if let _ = gamer.gun as? Revolver {
            print("\n\(gamer.nickname) scrolling")
        }
    }
}
