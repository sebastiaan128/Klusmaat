//
//  File.swift
//  Klusmaat
//
//  Created by Floris Ellenbroek on 06/11/2026.
//

import Foundation

extension String {
    var isValidEmail: Bool {
        let regex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return self.range(of: regex, options: .regularExpression) != nil
    }
}
