//
//  ScoreSheetModel.swift
//  EURO
//
//  Created by Shounak Jindam on 07/06/24.
//

import SwiftUI

struct ScoreSheetModel: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let description: String
    let points: String
}

