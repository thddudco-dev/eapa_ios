//
//  String+Extension.swift
//  EAPA
//
//  Created by 송영채 on 2023/01/06.
//

import Foundation

extension String {
    
    var nsNumberValue: NSNumber {
        if let intValue = Int(self) {
            let numberValue = NSNumber(value: intValue)
            return numberValue
        }
        return 0
    }
    
}
