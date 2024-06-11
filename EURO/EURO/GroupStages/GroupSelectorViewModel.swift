//
//  GroupSelectorViewModel.swift
//  EURO
//
//  Created by Shounak Jindam on 10/06/24.
//

import SwiftUI

class GroupSelectorViewModel: ObservableObject {
    @Published var progress: Double
    @Published var showBottomSheet: Bool = false
    @Published var showScoreSheet: Bool = false
    @Published var countries: [Country] = [
        Country(name: "", imageName: ""),
        Country(name: "", imageName: ""),
        Country(name: "", imageName: ""),
        Country(name: "", imageName: "")
    ]
    
    @Published var scoreSheetDetail: [ScoreSheetModel] = [
        ScoreSheetModel(name: "Group Stage",
                        description: "Predict each group's final standing.",
                        points: "3 pts"),
        ScoreSheetModel(name: "Knockout rounds",
                        description: "Predict the winner of each tie.",
                        points: "3 pts"),
        ScoreSheetModel(name: "Contenders",
                        description: "Get a bonus point for each semi-finalist and finalist you get right.",
                        points: "+1 pt"),
        ScoreSheetModel(name: "Late or edited bracket",
                        description: "If you save after the knockout stage has started, you won't get any points.",
                        points: "0 pts")
    ]
    
    @Published var editMode: EditMode = .active
    
    @Published var allTeams: [Country] = [
        Country(name: "England", imageName: "ENG"),
        Country(name: "Spain", imageName: "ESP"),
        Country(name: "Germany", imageName: "GER"),
        Country(name: "France", imageName: "FRA")
    ]
    
    @Published var popularTeamPrediction: [Country] = [
        Country(name: "England", imageName: "ENG"),
        Country(name: "Spain", imageName: "ESP"),
        Country(name: "Germany", imageName: "GER"),
        Country(name: "France", imageName: "FRA")
    ]
    
    init(progress: Double) {
        self.progress = progress
    }
    
    func move(indices: IndexSet, newOffset: Int) {
        countries.move(fromOffsets: indices, toOffset: newOffset)
    }
    
    func addCountryIfNeeded(_ country: Country) {
        if let index = countries.firstIndex(where: { $0.name.isEmpty && !$0.isSelected }) {
            countries[index] = country
            countries[index].isSelected = true
            if progress < 1.0 {
                withAnimation {
                    progress += 1/28
                }
            }
            
            if let teamIndex = allTeams.firstIndex(of: country) {
                allTeams[teamIndex].isSelected = true
            }
            
            
        }
    }
}
