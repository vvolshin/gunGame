//
//  profile.swift
//  gunGame
//
//  Created by Vitaly Volshin on 02.10.2024.
//

import Foundation

enum Status: String, CustomStringConvertible {
    case IN_PLAY = "IN PLAY"
    case SEARCH = "SEARCH"
    case IDLE = "IDLE"
    case OFFLINE = "OFFLINE"
    
    var description: String {
        return rawValue
    }
}

class Profile {
    let id: UUID
    var nickname: String
    var age: Int
    var gun: Weapon
    var accountCreated: String
    var status: Status
    var health: Int = 100
    var supply: [Patron] = []
    weak var playerActionDelegate: PlayerAction?
    lazy var serverURL: String? = {
        return "http://gameserver.com/\(id)-\(nickname)"
    }()
    
    init(nickname: String, age: Int, gun: Weapon, accountCreated: String, status: Status) {
        self.id = UUID()
        self.nickname = nickname
        self.age = age
        self.gun = gun
        self.accountCreated = accountCreated
        self.status = status
    }
    
    func requestOpponent() -> Profile? {
        return playerActionDelegate?.findOpponent(for: self)
    }
    
    func startMatch(with opponent: Profile) -> Bool {
        return playerActionDelegate?.fight(for: self, opponent: opponent) ?? false
    }
}
