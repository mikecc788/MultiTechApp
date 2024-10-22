//
//  Double.swift
//  iBreath-X
//
//  Created by app on 2024/8/24.
//

import Foundation
extension Double {
    
    func formattedInBnOrTrn() -> String {
        let trillion = 1_000_000_000_000.0
        let billion = 1_000_000_000.0

        if self >= trillion {
            let formattedNumber = self / trillion
            return String(format: "$%.2f Trn", formattedNumber)
        } else if self >= billion {
            let formattedNumber = self / billion
            return String(format: "$%.2f Bn", formattedNumber)
        } else {
            return String(format: "%.2f", self)
        }
    }
}
