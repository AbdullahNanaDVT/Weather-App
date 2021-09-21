//
//  Array+Extension.swift
//  Weather App
//
//  Created by Abdullah Nana on 2021/09/21.
//

import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
