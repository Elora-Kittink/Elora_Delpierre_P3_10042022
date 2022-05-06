//
//  Utils.swift
//  P3
//
//  Created by Elora on 29/04/2022.
//

import Foundation

// used to unwrap the many ReadLines
class Utils {
    
    static func checkReadLine() -> String {
        guard let line = readLine() else {
            print("vous n'avez pas répondu, recommencez")
            return checkReadLine()
        }
        return line
    }
}
