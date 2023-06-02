//
//  Extensions.swift
//  Netflix Clone
//
//  Created by Dimas Wisodewo on 02/06/23.
//

import Foundation

extension String {
    
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
