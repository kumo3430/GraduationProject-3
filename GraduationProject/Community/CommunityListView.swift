//
//  CommunityListView.swift
//  GraduationProject
//
//  Created by heonrim on 2023/10/27.
//

import SwiftUI

struct Community: Identifiable {
    var id = UUID()
    var name: String
    var description: String
    var memberCount: Int
    var image: String
}

extension Color {
    static let morandiPink = Color(red: 222/255, green: 207/255, blue: 207/255)
    static let morandiBlue = Color(red: 194/255, green: 209/255, blue: 216/255)
    static let morandiGreen = Color(red: 206/255, green: 222/255, blue: 212/255)
}

struct CommunityListView: View {
    let communities = [
        Community(name: "每日冥想", description: "專注於冥想的社群", memberCount: 1234, image: "meditation"),
        Community(name: "健身挑戰", description: "健身愛好者的聚集地", memberCount: 5678, image: "fitness")
    ]
    
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.morandiGreen.opacity(0.1).edgesIgnoringSafeArea(.all)
                
                List {
                    ForEach(communities) { community in
                        NavigationLink(destination: Text(community.name)) {
                            HStack(spacing: 15) {
                                Image(community.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 70, height: 70)
                                    .background(Color.morandiGreen.opacity(0.6))
                                    .cornerRadius(35)
                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                                    .scaleEffect(scale)
                                    .onAppear {
                                        withAnimation(Animation.easeInOut(duration: 0.5)) {
                                            scale = 1.1
                                        }
                                    }
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(community.name)
                                        .font(.headline)
                                        .foregroundColor(Color.morandiBlue)
                                    Text(community.description)
                                        .font(.subheadline)
                                        .foregroundColor(Color.morandiPink)
                                    Text("\\(community.memberCount) members")
                                        .font(.footnote)
                                        .foregroundColor(Color.morandiBlue)
                                }
                            }
                            .padding(.vertical, 10)
                        }
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationBarTitle("社群列表", displayMode: .large)
            .navigationBarItems(trailing: NavigationLink(destination: AddCommunityView()) {
                Image(systemName: "plus")
            })
        }
    }
}

struct AddCommunityView: View {
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var category: String = ""
    @State private var coverPhoto: Image? = nil
    
    var body: some View {
        Form {
            Section(header: Text("基本資訊").foregroundColor(Color.morandiBlue)) {
                TextField("社群名稱", text: $name)
                TextField("描述", text: $description)
            }
            
            Section(header: Text("分類").foregroundColor(Color.morandiBlue)) {
                TextField("選擇分類", text: $category)
            }
            
            Section(header: Text("封面照片").foregroundColor(Color.morandiBlue)) {
                Text("選擇封面照片")
            }
            
            Button(action: {}) {
                Text("新增社群")
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .background(Color.morandiPink)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.top)
        }
        .navigationTitle("新增社群")
    }
}

#Preview {
    CommunityListView()
}
