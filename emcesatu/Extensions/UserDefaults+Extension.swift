//
//  UserDefaults+Extension.swift
//  emcesatu
//
//  Created by Marshall Kurniawan on 11/04/22.
//

import Foundation

extension UserDefaults {
    private enum UserDefaultKeys: String {
        case hasOnboarded
    }
    
    var hasOnboarded:Bool {
        get {
            bool(forKey: UserDefaultKeys.hasOnboarded.rawValue)
        } set {
            setValue(newValue, forKey: UserDefaultKeys.hasOnboarded.rawValue)
        }
    }
}
