//
//  DiaryView.swift
//  GraduationProject
//
//  Created by heonrim on 2023/10/23.
//

import SwiftUI


struct DiaryEntry: Identifiable {
    let id: UUID
    let date: Date
    let content: String
    let attachments: [Attachment]
}

enum Attachment {
    case image(UIImage)
}

struct DiaryView: View {
    @State private var diaryEntries: [DiaryEntry] = []
    @State private var showingEditor = false

    var body: some View {
        NavigationView {
            List(diaryEntries, id: \.id) { entry in
                NavigationLink(destination: DiaryEntryDetailView(entry: entry)) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(entry.date, style: .date)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text(entry.content)
                                .lineLimit(1)
                                .font(.headline)
                        }
                        Spacer()
                        Image(systemName: "arrow.right.circle.fill")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
                }
            }
            .listStyle(PlainListStyle())
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
            .navigationTitle("習慣日記")
            .navigationBarItems(trailing: Button(action: { showingEditor = true }) {
                Image(systemName: "plus.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.white)
            })
            .sheet(isPresented: $showingEditor) {
                DiaryEntryEditor { newEntry in
                    diaryEntries.append(newEntry)
                    showingEditor = false
                }
            }
        }
    }
}

struct DiaryEntryDetailView: View {
    let entry: DiaryEntry

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(entry.date, style: .date)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(entry.content)
                    .font(.title)
                ForEach(entry.attachments.indices, id: \.self) { index in
                    let attachment = entry.attachments[index]
                    switch attachment {
                    case .image(let image):
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(10)
                            .shadow(radius: 10)
                            .padding(.top)
                    }
                }

            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 15).fill(Color.white).shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5))
            .padding()
        }
        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
        .navigationTitle("日記詳情")
    }
}

struct DiaryEntryEditor: View {
    @State private var content: String = ""
    @State private var attachments: [Attachment] = []
    let onSave: (DiaryEntry) -> Void

    var body: some View {
        VStack {
            Text("新日記")
                .font(.largeTitle)
                .padding()
            TextEditor(text: $content)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
            Button("保存") {
                let newEntry = DiaryEntry(id: UUID(), date: Date(), content: content, attachments: attachments)
                onSave(newEntry)
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(radius: 10)
            .padding()
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
    }
}

#Preview {
    DiaryView()
}
