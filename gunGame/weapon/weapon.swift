//
//  weapon.swift
//  gunGame
//
//  Created by Vitaly Volshin on 02.10.2024.
//

import Foundation

enum WeaponError: Error, CustomStringConvertible {
    case indexOutOfRange
    case differentCaliber
    case wrongCaliber
    
    var description: String {
        switch self {
        case .indexOutOfRange:
            return "Error: index is out of range"
        case .differentCaliber:
            return "Error: different calibers in a moon clip"
        case .wrongCaliber:
            return "Error: wrong caliber in a moon clip"
        }
    }
}

protocol Weapon: AnyObject {
    var name: String { get set }
    var damage: Int { get }
    var isEmpty: Bool { get }
    func shoot() -> Any?
}
