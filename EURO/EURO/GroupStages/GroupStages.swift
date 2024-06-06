//
//  GroupStages.swift
//  EURO
//
//  Created by Shounak Jindam on 06/06/24.
//

import SwiftUI

struct GroupStages: View {
    var body: some View {
        ScrollView {
            ForEach(0..<1) { index in
                GroupSelector()
            }
        }
    }
}

#Preview {
    GroupStages()
}
