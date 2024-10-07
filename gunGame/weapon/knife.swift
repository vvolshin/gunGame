//
//  knife.swift
//  gunGame
//
//  Created by Vitaly Volshin on 02.10.2024.
//

import Foundation

class Knife: Weapon {
    var name: String {
        get {
            return _name
        }
        set {
            _name = newValue
        }
    }
    var damage: Int {
        get {
            return _damage
        }
    }
    var isEmpty: Bool = false
    
    private var _name: String
    private var _damage: Int
    
    init (name: String, damage: Int) {
        self._name = name
        self._damage = damage
    }
    
    func shoot() -> Any? {
        print("Crrr! \(damage)")
        return damage
    }
}
