//
//  GroupStages.swift
//  EURO
//
//  Created by Shounak Jindam on 06/06/24.@
//

import SwiftUI

struct GroupStages: View {
    @State private var progress: Double = 0.0
    
    @State private var groupName: [String] = ["A", "B", "C", "D", "E", "F"]
    
    var body: some View {
        ZStack {
            FANTASYTheme.getColor(named: .CFSDKPrimary)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                navBar
                    .edgesIgnoringSafeArea(.top)
                    .frame(height: 80)
                sponsorImage
                ProgressBar(progress: $progress)
                groups
            }
        }
    }
    
    var groups: some View {
        ScrollView {
            VStack {
                ForEach(groupName.indices) { index in
                    GroupSelector(progress: $progress, groupName: $groupName[index])
                        .CFSDKcornerRadius(15, corners: .allCorners)
                        .frame(height: 350)
                        .padding()
                }
                ThirdPlaceView(progress: $progress)
                    .padding()
            }
        }
    }
    
    var navBar: some View {
        ZStack {
            FANTASYTheme.getImage(named: .Pattern)?
                .resizable()
                .scaledToFill()
                .frame(height: 130)
                .clipped()
            HStack {
                Button(action: {
                    
                }, label: {
                    FANTASYTheme.getImage(named: .BackChev)?
                        .padding()
                       
                })
                Spacer()
                Button(action: {
                    
                }, label: {
                    FANTASYTheme.getImage(named: .threeLines)?
                        .padding()
                       
                })
                
            }
            .padding(.top, 80)
                
        }
    }
    
    var sponsorImage: some View {
        FANTASYTheme.getImage(named: .VisitQatar)?
            .resizable()
            .scaledToFit()
            .padding(.horizontal, 40)
            .padding(.vertical, 10)
    }
}

struct ProgressBar: View {
    @Binding var progress: Double
    
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .frame(height: 5)
                .foregroundColor(Color.gray.opacity(0.3))
                .cornerRadius(10)
            
            Rectangle()
                .frame(width: CGFloat(progress) * UIScreen.main.bounds.width * 0.8, height: 5)
                .foregroundColor(.cfsdkAccent1)
                .cornerRadius(10)
        }
        .padding()
    }
}

#Preview {
    GroupStages()
}
