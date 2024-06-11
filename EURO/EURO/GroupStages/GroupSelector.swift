//
//  GroupSelector.swift
//  EURO
//
//  Created by Shounak Jindam on 03/06/24.
//

import SwiftUI

struct GroupSelector: View {
    
    @Binding var progress: Double
    @Binding var groupName: String
    
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
    
    @ObservedObject var viewModel: GroupSelectorViewModel

    var body: some View {
        VStack(spacing: 0) {
            if viewModel.countries.filter({ !$0.name.isEmpty }).count == 4 {
                successHeaderView
                    .padding(.horizontal, 0)
                    .background {
                        FANTASYTheme.getColor(named: .groupHeaderBlue)
                    }
            } else {
                headerView
                    .padding(.vertical, 16)
                    .padding(.horizontal, 0)
                    .background {
                        FANTASYTheme.getColor(named: .groupHeaderBlue)
                    }
            }
            emptyGroup
                .padding(.top, 0)
        }
        .environment(\.editMode, $viewModel.editMode)
    }

    //MARK: - VIEWS

    var headerView: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Group " + "\(groupName)")
                    .foregroundStyle(.cfsdkAccent1)
                Spacer()
            }
            .padding(.bottom, 10)
            .padding(.horizontal, 40)
            HStack(spacing: 50) {
                ForEach(viewModel.allTeams.indices, id: \.self) { index in
                    VStack {
                        Button(action: {
                            viewModel.addCountryIfNeeded(viewModel.allTeams[index])
                        }, label: {
                            if viewModel.allTeams[index].isSelected {
                                Image(systemName: "circle.fill")
                            } else {
                                Image(viewModel.allTeams[index].imageName)
                                    .resizable()
                                    .frame(width: 36, height: 36)
                                    .clipShape(Circle())
                            }
                        })
                        Text(viewModel.allTeams[index].name.prefix(3).uppercased())
                            .foregroundStyle(.cfsdkWhite)
                    }
                    .disabled(viewModel.allTeams[index].isSelected)
                }
            }
        }
    }

    var successHeaderView: some View {
        HStack {
            VStack(spacing: 0) {
                HStack {
                    Text("Group " + "\(groupName)")
                        .foregroundStyle(.cfsdkAccent1)
                    Spacer()
                }
                .padding(.bottom, 10)
                .padding(.horizontal, 40)
                Text("Drag teams to re-order")
                    .foregroundStyle(.cfsdkWhite)
            }
            FANTASYTheme.getImage(named: .Pattern)?
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 100)
        }
    }

    var emptyGroup: some View {
        List {
            ForEach(viewModel.countries.indices, id: \.self) { index in
                HStack {
                    Text("\(index + 1)")
                        .foregroundStyle(.cfsdkWhite)
                    Image(viewModel.countries[index].imageName)
                        .resizable()
                        .frame(width: 25, height: 25)
                        .clipShape(Circle())
                    Text(viewModel.countries[index].name)
                        .foregroundStyle(.cfsdkWhite)
                }
            }
            .onMove(perform: viewModel.move)
            .listRowBackground(FANTASYTheme.getColor(named: .CFSDKPrimary3))
            HStack {
                Spacer()
                viewGroupDetailButton
                Spacer()
            }
            .listRowBackground(FANTASYTheme.getColor(named: .CFSDKPrimary3))
        }
        .environment(\.editMode, .constant(viewModel.countries.contains(where: { !$0.name.isEmpty }) ? EditMode.active : EditMode.inactive))
        .listStyle(PlainListStyle())
    }

    var viewGroupDetailButton: some View {
        Button(action: {
            viewModel.showBottomSheet.toggle()
        }, label: {
            Text("View Group A details")
                .foregroundStyle(.cfsdkAccent1)
        })
        .sheet(isPresented: $viewModel.showBottomSheet, content: {
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
                        viewModel.showBottomSheet = false
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
                    ForEach(viewModel.popularTeamPrediction.indices, id: \.self) { index in
                        HStack {
                            Text("\(index + 1)")
                                .foregroundStyle(.cfsdkWhite)
                                .font(.subheadline)
                            Image(viewModel.popularTeamPrediction[index].imageName)
                                .resizable()
                                .frame(width: 25, height: 25)
                                .clipShape(Circle())
                            Text(viewModel.popularTeamPrediction[index].name)
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
                            viewModel.showScoreSheet.toggle()
                        }, label: {
                            Text("See how to score points")
                                .foregroundStyle(.cfsdkAccent1)
                        })
                        .padding()
                        Spacer()
                    }
                    .sheet(isPresented: $viewModel.showScoreSheet, content: {
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
            FANTASYTheme.getColor(named: .groupSheetBlue)
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("See how to score points")
                        .foregroundStyle(.cfsdkWhite)
                        .padding([.top, .leading], 10)
                    Spacer()
                    Button(action: {
                        viewModel.showScoreSheet = false
                    }, label: {
                        Image(systemName: "xmark")
                            .tint(.cfsdkWhite)
                            .padding([.top, .trailing], 10)
                    })
                }
                .background {
                    FANTASYTheme.getColor(named: .groupSheetBlue)
                }
                ForEach(viewModel.scoreSheetDetail, id: \.self) { scoreSheet in
                    HStack {
                        Text(scoreSheet.name)
                            .foregroundStyle(.cfsdkAccent1)
                            .padding(.top, 20)
                            .padding(.horizontal, 10)
                        Spacer()
                    }
                    HStack(alignment: .center, spacing: 0) {
                        VStack(alignment: .leading) {
                            Text(scoreSheet.description)
                                .foregroundStyle(.cfsdkWhite)
                                .font(.subheadline)
                                .padding(.top, 20)
                                .padding(.leading, 10)
                                .padding(.bottom, 20)
                                .padding(.trailing, 5)
                        }
                        Text(scoreSheet.points)
                            .foregroundStyle(.cfsdkAccent1)
                            .font(.subheadline)
                            .padding(.horizontal, 10)
                    }
                }
                Spacer()
            }
        }
        .ignoresSafeArea()
    }
}

