//
//  patron.swift
//  gunGame
//
//  Created by Vitaly Volshin on 29.09.2024.
//

import Foundation

enum PatronStatus: String, CustomStringConvertible {
    case charged = "charged"
    case damp = "damp"
    
    var description: String {
        return rawValue
    }
}

enum Caliber: String, CustomStringConvertible, CaseIterable {
    case v20 = "20"
    case v22 = "22"
    case v32 = "32"
    case v38 = "38"
    case v45 = "45"
    case v50 = "50"
    
    var description: String {
        return rawValue
    }
}

class Patron: Equatable {
    let id = UUID()
    var status: PatronStatus
    var caliber: Caliber
    weak var moonClip: Weapon?
    
    init(status: PatronStatus, caliber: Caliber) {
        self.status = status
        self.caliber = caliber
        self.moonClip = nil
    }
    
    static func == (lhs: Patron, rhs: Patron) -> Bool {
        return lhs.caliber == rhs.caliber && lhs.status == rhs.status
    }
    
    func shoot() {
        print("Bang \(self.caliber.rawValue)")
    }
}
