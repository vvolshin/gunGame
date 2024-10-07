//
//  main.swift
//  gunGame
//
//  Created by Vitaly Volshin on 24.09.2024.
//

import Foundation

class Revolver: Equatable, Weapon {
    private var revolverMoonClip: [Patron?]
    
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
            return _isEmpty
        }
    }
    
    private var _name: String
    private var _damage: Int
    private var _caliber: Caliber?
    private var _isEmpty: Bool {
        return revolverMoonClip.allSatisfy { $0 == nil }
    }
    
    var pointer: Patron? {
        get {
            return revolverMoonClip[0]
        }
    }
    
    init(name: String, caliber: Caliber?) {
        self._name = name
        self.revolverMoonClip = Array(repeating: nil, count: 6)
        self._caliber = caliber

        guard let caliber = caliber, let intCaliber = Int(caliber.rawValue) else {
            self._damage = 0
            return
        }

        self._damage = intCaliber
    }
    
    init(name: String, caliber: Caliber?, bullets: [Patron?]) throws {
        self._name = name
        
        if bullets.count > 6 {
            throw WeaponError.indexOutOfRange
        }
        
        if let exmapleBullet = bullets[0] {
            for bullet in bullets[1...] {
                if bullet == nil {
                    continue
                }
                
                if bullet?.caliber != exmapleBullet.caliber {
                    throw WeaponError.differentCaliber
                }
            }
        }
        
        self.revolverMoonClip = bullets + Array(repeating: nil, count: 6 - bullets.count)
        self._caliber = caliber

        guard let caliber = caliber, let intCaliber = Int(caliber.rawValue) else {
            self._damage = 0
            return
        }

        self._damage = intCaliber
    }
    
    static func == (lhs: Revolver, rhs: Revolver) -> Bool {
        guard lhs.revolverMoonClip.count == rhs.revolverMoonClip.count else {
            return false
        }
        
        let doubledMoonClip = lhs.revolverMoonClip + lhs.revolverMoonClip
        
        for startIndex in doubledMoonClip.indices {
            let endIndex = startIndex + rhs.revolverMoonClip.count
            let subArray = doubledMoonClip[startIndex..<endIndex]
            
            if Array(subArray) == rhs.revolverMoonClip {
                return true
            }
        }
        
        return false
    }
    
    subscript(index: Int) -> Patron {
        get throws {
            guard index >= 0 && index < revolverMoonClip.count else {
                throw WeaponError.indexOutOfRange
            }
            
            return revolverMoonClip[index]!
        }
    }
    
    func add(_ bullet: Patron) -> Bool {
        guard revolverMoonClip.contains(where: { $0 == nil }) else {
            return false
        }
        
        guard bullet.caliber == self.caliber else {
            return false
        }
        
        if bullet.moonClip != nil {
            return false
        }
        
        for index in 0..<revolverMoonClip.count {
            if revolverMoonClip[index] == nil {
                revolverMoonClip[index] = bullet
                bullet.moonClip = self
                return true
            }
        }
        
        return false
    }
    
    func add(_ bullets: [Patron]) -> Bool {
        guard !bullets.isEmpty else {
            return false
        }
        
        guard revolverMoonClip.contains(where: { $0 == nil }) else {
            return false
        }
        
        var flag: Bool = false
        
        for bullet in bullets {
            if bullet.moonClip != nil {
                continue
            }
            
            if bullet.caliber != self.caliber {
                continue
            }

            if let index = revolverMoonClip.firstIndex(where: { $0 == nil }) {
                revolverMoonClip[index] = bullet
                bullet.moonClip = self
                flag = true
            } else {
                break
            }
        }
        
        return flag
    }
    
    private func shift(_ step: Int) {
        if step < 0 {
            shiftLeft()
        }
        
        if step > 0 {
            shiftRight(step)
        }
    }
    
    private func shiftRight(_ step: Int) {
        var newMoonClip = Array(repeating: nil as Patron?, count: revolverMoonClip.count)
        
        for index in revolverMoonClip.indices {
            let value = revolverMoonClip[index]
            let newIndex = (index + step) % revolverMoonClip.count
            newMoonClip[newIndex] = value
        }
        
        revolverMoonClip = newMoonClip
    }
    
    private func shiftLeft() {
        for index in 0..<revolverMoonClip.count - 1 {
            revolverMoonClip[index] = revolverMoonClip[index + 1]
        }
        
        revolverMoonClip[revolverMoonClip.count - 1] = nil
    }
    
    func shoot() -> Any? {
        guard let bullet = revolverMoonClip[0] else {
            print("Click")
            return nil
        }
        
        switch bullet.status {
        case .charged:
            shift(-1)
            bullet.shoot()
            return damage
        case .damp:
            shift(-1)
            print("Click")
            return nil
        }
    }
    
    func unload(_ index: Int) throws -> Patron? {
        guard index >= 0, index < 6 else {
            throw WeaponError.indexOutOfRange
        }
        
        let bullet = revolverMoonClip[index]
        revolverMoonClip[index] = nil
        
        return bullet
    }
    
    func unloadAll() -> [Patron?] {
        let outcome = revolverMoonClip
        
        for index in revolverMoonClip.indices {
            revolverMoonClip[index] = nil
        }
        
        return outcome
    }
    
    func scroll() {
        let step: Int = Int.random(in: 0...5)
        
        shift(step)
    }
    
    func getSize() -> Int {
        return revolverMoonClip.count
    }
}

extension Revolver {
    func toStringDescription() -> String {
        var description: String = ""
        description += "Structure: RevolverMoonClip \(self.revolverMoonClip[0]?.caliber.rawValue ?? "") caliber\n"
        
        description += "Objects: \(showObjects())\n"
        
        if let pointerValue = pointer {
            description += "Pointer: \(Patron.self)(\(pointerValue.id), \(pointerValue.status.rawValue), \(pointerValue.caliber.rawValue))"
        } else {
            description += "Pointer: nil"
        }
        
        return description
    }
    
    func showObjects() -> String {
        let description = revolverMoonClip.map { bullet -> String in
            if let value = bullet {
                return "\(Patron.self)(\(value.id), \(value.status.rawValue), \(value.caliber.rawValue))"
            } else {
                return "nil"
            }
        }.joined(separator: ", ")
        
        return "[\(description)]"
    }
}
