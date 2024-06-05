//
//  GroupSelector.swift
//  EURO
//
//  Created by Shounak Jindam on 03/06/24.
//

import SwiftUI

struct Country: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let imageName: String
    var isSelected = false
}

struct ScoreSheetModel: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let description: String
    let points: String
}

struct GroupSelector: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showBottomSheet: Bool = false
    @State private var showScoreSheet: Bool = false
    
    
    @State private var countries: [Country] = [
        Country(name: "", imageName: ""),
        Country(name: "", imageName: ""),
        Country(name: "", imageName: ""),
        Country(name: "", imageName: "")
    ]
    
    @State private var scoreSheetDetail: [ScoreSheetModel] = [
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
    
    @State private var editMode: EditMode = .active
    
    @State private var allTeams: [Country] = [
        Country(name: "England", imageName: "ENG"),
        Country(name: "Spain", imageName: "ESP"),
        Country(name: "Germany", imageName: "GER"),
        Country(name: "France", imageName: "FRA")
    ]
    
    @State private var popularTeamPrediction: [Country] = [
        Country(name: "England", imageName: "ENG"),
        Country(name: "Spain", imageName: "ESP"),
        Country(name: "Germany", imageName: "GER"),
        Country(name: "France", imageName: "FRA")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            headerView
                .padding()
                .background {
                    FANTASYTheme.getColor(named: .CFSDKSecondary)
                }
            emptyGroup
        }
        .environment(\.editMode, $editMode)
    }
    
    //MARK: - VIEWS
    
    var headerView: some View {
        VStack {
            HStack {
                Text("       ")
                Text("Group A")
                    .foregroundStyle(.cfsdkAccent1)
                Spacer()
            }
            HStack(spacing: 50) {
                ForEach(allTeams.indices, id: \.self) { index in
                    VStack {
                        Button(action: {
                            addCountryIfNeeded(allTeams[index])
                        }, label: {
                            if allTeams[index].isSelected {
                                Image(systemName: "circle.fill")
                            } else {
                                Image(allTeams[index].imageName)
                            }
                        })
                        Text(allTeams[index].name.prefix(3).uppercased())
                            .foregroundStyle(.cfsdkWhite)
                    }
                    .disabled(allTeams[index].isSelected)
                }
            }
        }
    }
    
    var emptyGroup: some View {
        List {
            ForEach(countries.indices, id: \.self) { index in
                HStack {
                    Text("\(index + 1)")
                        .foregroundStyle(.cfsdkWhite)
                    Image(countries[index].imageName)
                    Text(countries[index].name)
                        .foregroundStyle(.cfsdkWhite)
                    
                }
            }
            .onMove(perform: move)
            .listRowBackground(FANTASYTheme.getColor(named: .CFSDKPrimary3))
            HStack {
                Spacer()
                viewGroupDetailButton
                Spacer()
            }
            .listRowBackground(FANTASYTheme.getColor(named: .CFSDKPrimary3))
        }
        
        .environment(\.editMode, .constant(countries.contains(where: { !$0.name.isEmpty }) ? EditMode.active : EditMode.inactive))
    }
    
    func move(indices: IndexSet, newOffset: Int) {
        countries.move(fromOffsets: indices, toOffset: newOffset)
    }
    
    func addCountryIfNeeded(_ country: Country) {
        if let index = countries.firstIndex(where: { $0.name.isEmpty && !$0.isSelected }) {
            countries[index] = country
            countries[index].isSelected = true
            
            if let teamIndex = allTeams.firstIndex(of: country) {
                allTeams[teamIndex].isSelected = true
            }
        }
    }
    
    var viewGroupDetailButton: some View {
        Button(action: {
            showBottomSheet.toggle()
        }, label: {
            Text("View Group A details")
                .foregroundStyle(.cfsdkAccent1)
        })
        .sheet(isPresented: $showBottomSheet, content: {
            bottomSheet
                .presentationCornerRadius(20)
                .presentationDetents([.fraction(0.55)])
                .presentationDragIndicator(.hidden)
                .background {
                    FANTASYTheme.getColor(named: .groupSheetBlue)
                }
        })
    }
    
    
    var bottomSheet: some View {
        ZStack {
            FANTASYTheme.getColor(named: .groupSheetBlue)
            VStack {
                HStack {
                    Text("Most popular Group E prediction")
                        .font(.subheadline)
                        .foregroundStyle(.cfsdkWhite)
                        .padding([.top, .leading], 10)
                    Spacer()
                    Button(action: {
                        showBottomSheet = false
                    }, label: {
                        Image(systemName: "xmark")
                            .tint(.cfsdkWhite)
                            .padding([.top, .trailing], 10)
                    })
                }
                .background {
                    FANTASYTheme.getColor(named: .groupSheetBlue)
                }
                VStack {
                    ForEach(popularTeamPrediction.indices, id: \.self) { index in
                        HStack {
                            Text("\(index + 1)")
                                .foregroundStyle(.cfsdkWhite)
                                .font(.subheadline)
                            Image(popularTeamPrediction[index].imageName)
                            Text(popularTeamPrediction[index].name)
                                .foregroundStyle(.cfsdkWhite)
                            Spacer()
                        }
                        .padding()
                        Divider()
                            .background {
                                Color.white.opacity(0.5)
                            }
                    }
                    Divider()
                    HStack{
                        Button(action: {
                            showScoreSheet.toggle()
                        }, label: {
                            Text("See how to score points")
                                .foregroundStyle(.cfsdkAccent1)
                        })
                        .padding()
                        Spacer()
                    }
                    .sheet(isPresented: $showScoreSheet, content: {
                        scorePointSheet
                            .presentationCornerRadius(20)
                            .presentationDetents([.fraction(0.65)])
                            .presentationDragIndicator(.hidden)
                            .background {
                                FANTASYTheme.getColor(named: .groupSheetBlue)
                            }
                    })
                }
                
            }
        }
        .ignoresSafeArea()
    }
    
    var scorePointSheet: some View {
        ZStack {
            FANTASYTheme.getColor(named: .CFSDKPrimary3)
            VStack {
                HStack {
                    Text("How to Score Points")
                        .font(.title3.bold())
                        .foregroundStyle(.cfsdkWhite)
                        .padding([.top, .leading], 20)
                    Spacer()
                    Button(action: {
                        showScoreSheet = false
                    }, label: {
                        Image(systemName: "xmark")
                            .tint(.cfsdkWhite)
                            .padding([.top, .trailing], 10)
                    })
                    
                }
                Divider()
                    .background {
                        Color.white.opacity(0.5)
                    }
                ForEach(scoreSheetDetail.indices, id: \.self) { index in
                    HStack {
                        Text(scoreSheetDetail[index].name)
                            .font(.title3.bold())
                            .foregroundStyle(.cfsdkWhite)
                            .padding([.top, .leading], 10)
                        Spacer()
                        Text(scoreSheetDetail[index].points)
                            .font(.title3.bold())
                            .foregroundStyle(scoreSheetDetail[index].points == "0 pts" ? .cfsdkAccentError: .cfsdkWhite)
                            .padding([.top, .trailing], 10)
                    }
                    HStack{
                        Text(scoreSheetDetail[index].description)
                            .font(.subheadline)
                            .foregroundStyle(.cfsdkWhite).opacity(0.7)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                    }
                    .padding(.leading,10)
                    Divider()
                        .background {
                            Color.white.opacity(0.5)
                        }
                }
                
                HStack{
                    Button(action: {
                        
                    }, label: {
                        Text("Read full article")
                            .foregroundStyle(.cfsdkAccent1)
                    })
                    .padding()
                    Spacer()
                }
            }
        }
        .ignoresSafeArea()
    }
}




struct GroupSelector_Previews: PreviewProvider {
    static var previews: some View {
        GroupSelector()
    }
}
