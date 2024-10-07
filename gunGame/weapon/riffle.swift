//
//  rifle.swift
//  gunGame
//
//  Created by Vitaly Volshin on 02.10.2024.
//

import Foundation

class Riffle: Weapon {
    var chamber: Patron?
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
    
    var caliber: Caliber? {
        get {
            return _caliber
        }
        set {
            _caliber = newValue
        }
    }
    
    var isEmpty: Bool {
        get {
            return chamber == nil
        }
    }
    
    private var _name: String
    private var _damage: Int
    private var _caliber: Caliber?
    
    init (name: String, caliber: Caliber?) {
        self._name = name
        self._caliber = caliber
        self.chamber = nil
        
        guard let caliber = caliber, let intCaliber = Int(caliber.rawValue) else {
            self._damage = 0
            return
        }

        self._damage = intCaliber
    }
    
    init (name: String, caliber: Caliber?, bullet: Patron?) throws {
        self._name = name
        self._caliber = caliber
        self.chamber = bullet
        
        if bullet?.caliber != caliber {
            throw WeaponError.wrongCaliber
        }
        
        if let intCaliber = Int(caliber?.rawValue ?? "") {
            self._damage = intCaliber
        } else {
            self._damage = 0
        }
    }
    
    func add(_ bullet: Patron) throws -> Bool {
        guard chamber == nil else {
            return false
        }
        
        if bullet.moonClip != nil {
            return false
        }
        
        chamber = bullet
        bullet.moonClip = self
        
        return true
    }
    
    func shoot() -> Any? {
        guard let bullet = chamber else {
            print("Click")
            return nil
        }
        
        switch bullet.status {
        case .charged:
            bullet.shoot()
            chamber = nil
            return damage
        case .damp:
            chamber = nil
            print("Click")
            return nil
        }
    }
    
    func unload() -> Patron? {
        guard let bullet = chamber else {
            return nil
        }
        
        chamber = nil
        
        return bullet
    }
}
