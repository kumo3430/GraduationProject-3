//
//  CheckSpaceView.swift
//  GraduationProject
//
//  Created by heonrim on 2023/9/24.
//

import SwiftUI
import Combine

struct CheckSpaceView: View {
    @State var accumulatedValue: Float = 0.0
    @State var isTaskCompleted: Bool  = false
    @State private var isCompleted: Bool = false
    @State private var repetition1Count: String = ""
    @State private var repetition2Count: String = ""
    @State private var repetition3Count: String = ""
    @State private var repetition4Count: String = ""
    @State private var isToday1: Int = 0
    @State private var isToday2: Int = 0
    @State private var isToday3: Int = 0
    @State private var isToday4: Int = 0
    
    let titleColor = Color(red: 229/255, green: 86/255, blue: 4/255)
    let customBlue = Color(red: 175/255, green: 168/255, blue: 149/255)
    var task: Task
    @EnvironmentObject var taskStore: TaskStore
    let habitType: String = "間隔學習"
    let intervalLearningType: String = "學習"
    static let remainingValuePublisher = PassthroughSubject<(isCompleted: Bool,days: Int), Never>()
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(task.title)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(titleColor)
                    .padding(.bottom, 1)
                
                Text("習慣類型：\(habitType)")
                    .font(.system(size: 13, weight: .medium, design: .default))
                    .foregroundColor(Color.secondary)
                    .padding(.bottom, 1)
                
                Text("間隔學習階段: \(intervalLearningType)")
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundColor(customBlue)
                    .padding(.bottom, 1)
                
                HStack {
                    VStack(alignment: .center) {
                        Text("第一天")
                            .font(.system(size: 12, weight: isToday1 == 1 ? .bold : .medium, design: .serif))
                            .foregroundColor(isToday1 == 1 ? titleColor : Color.secondary)
                        
                        Text(repetition1Count)
                            .font(.system(size: 12, weight: .semibold, design: .default))
                            .foregroundColor(customBlue)
                        Button(action: {
//                                task.isReviewChecked0 = true
                                isTaskCompleted = true
                            CheckSpaceView.remainingValuePublisher.send((isCompleted: isTaskCompleted,days: 1))
                        }) {
                            Image(systemName: self.isToday1 == 0 && task.isReviewChecked0 ? "xmark" : "checkmark")
                                .foregroundColor(isTaskCompleted ? Color.morandiGreen : Color.white)
                                .padding(6)
                                .background(Capsule().fill(customBlue).shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 2))
                                .font(.system(size: 16))
                        }
                        .disabled(isTaskCompleted || isToday1 != 1)
                        .padding(.horizontal, 10)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .center) {
                        Text("第三天")
                            .font(.system(size: 12, weight:  isToday2 == 1 ? .bold : .medium, design: .serif))
                            .foregroundColor(Color.secondary)
                        
                        Text(repetition2Count)
                            .font(.system(size: 12, weight: .semibold, design: .default))
                            .foregroundColor(customBlue)
                        Button(action: {
//                            task.isReviewChecked0 = true
                            isTaskCompleted = true
                            CheckSpaceView.remainingValuePublisher.send((isCompleted: isTaskCompleted,days: 2))
                        }) {
                            Image(systemName: isToday2 == 0 && task.isReviewChecked1 ? "xmark" : "checkmark")
                                .foregroundColor(isTaskCompleted ? Color.gray : Color.white)
                                .padding(6)
                                .background(Capsule().fill(customBlue).shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 2))
                                .font(.system(size: 16))
                        }
                        .disabled(isTaskCompleted || isToday2 != 1)
                        .padding(.horizontal, 10)
                    }
                    Spacer()
                    
                    VStack(alignment: .center) {
                        Text("第七天")
                            .font(.system(size: 12, weight:  isToday3 == 1 ? .bold : .medium, design: .serif))
                            .foregroundColor(Color.secondary)
                        
                        Text(repetition3Count)
                            .font(.system(size: 12, weight: .semibold, design: .default))
                            .foregroundColor(customBlue)
                        Button(action: {
//                            task.isReviewChecked0 = true
                            isTaskCompleted = true
                            CheckSpaceView.remainingValuePublisher.send((isCompleted: isTaskCompleted,days: 3))                        }) {
                            Image(systemName: isToday3 == 0 && task.isReviewChecked2 ? "xmark" : "checkmark")
                                .foregroundColor(isTaskCompleted ? Color.gray : Color.white)
                                .padding(6)
                                .background(Capsule().fill(customBlue).shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 2))
                                .font(.system(size: 16))
                        }
                        .disabled(isTaskCompleted || isToday3 != 1)
                        .padding(.horizontal, 10)
                    }
                    Spacer()
                    
                    VStack(alignment: .center) {
                        Text("第十四天")
                            .font(.system(size: 12, weight:  isToday4 == 1 ? .bold : .medium, design: .serif))
                            .foregroundColor(Color.secondary)
                        
                        Text(repetition4Count)
                            .font(.system(size: 12, weight: .semibold, design: .default))
                            .foregroundColor(customBlue)
                        Button(action: {
//                            task.isReviewChecked0 = true
                            isTaskCompleted = true
                            CheckSpaceView.remainingValuePublisher.send((isCompleted: isTaskCompleted,days: 4))
                        }) {
                            Image(systemName: isToday4 == 0 && task.isReviewChecked3 ? "xmark" : "checkmark")
                                .foregroundColor(isTaskCompleted ? Color.gray : Color.white)
                                .padding(6)
                                .background(Capsule().fill(customBlue).shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 2))
                                .font(.system(size: 16))
                        }
                        .disabled(isTaskCompleted || isToday4 != 1)
                        .padding(.horizontal, 10)
                    }
                }
                .padding(.horizontal, 10)
            }
            .padding(12)
            .background(isTaskCompleted ? Color.gray : Color.clear)
            if isTaskCompleted {
                Image(systemName: "checkmark")
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .bold))
                    .padding(15)
                    .background(Circle().fill(Color.green))
            }
        }
        .background(isTaskCompleted ? Color.gray : Color.clear)
        .onAppear() {
            let today = formattedDate(Date())
            print("Today\(today)")
            print("repetition1Count\(formattedDate(task.repetition1Count))")
            if today == formattedDate(task.repetition1Count) {
                isToday1 = 1
            } else if today > formattedDate(task.repetition1Count) {
                isToday1 = 0
            } else if today < formattedDate(task.repetition1Count) {
                isToday1 = 2
            }
            if today == formattedDate(task.repetition2Count) {
                isToday2 = 1
            } else if today > formattedDate(task.repetition2Count) {
                isToday2 = 0
            } else if today < formattedDate(task.repetition2Count) {
                isToday2 = 2
            }
            if today == formattedDate(task.repetition3Count) {
                isToday3 = 1
            } else if today > formattedDate(task.repetition3Count) {
                isToday3 = 0
            } else if today < formattedDate(task.repetition3Count) {
                isToday3 = 2
            }
            if today == formattedDate(task.repetition4Count) {
                isToday4 = 1
            } else if today > formattedDate(task.repetition4Count) {
                isToday4 = 0
            } else if today < formattedDate(task.repetition4Count) {
                isToday4 = 2
            }
            print("isToday1\(isToday1)")
            repetition1Count = formattedDate(task.repetition1Count)
            repetition2Count = formattedDate(task.repetition2Count)
            repetition3Count = formattedDate(task.repetition3Count)
            repetition4Count = formattedDate(task.repetition4Count)
        }
    }
}

struct CheckSpaceView_Previews: PreviewProvider {
    @State static var  sampleTodo = Task(
        id: 1,
        label: "SampleLabel",
        title: "SampleTitle",
        description: "SampleDescription",
        nextReviewDate: Date(),
        nextReviewTime: Date(),
        repetition1Count:  Date(),
        repetition2Count:  Date(),
        repetition3Count:  Date(),
        repetition4Count:  Date(),
        isReviewChecked0: false,
        isReviewChecked1: false,
        isReviewChecked2: false,
        isReviewChecked3: false
    )
    
    static var previews: some View {
        CheckSpaceView( task: sampleTodo)
            .environmentObject(TaskService.shared)
    }
}
