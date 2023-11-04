//
//  MindfulnessHubView.swift
//  GraduationProject
//
//  Created by heonrim on 2023/10/23.
//

import SwiftUI
import AVFoundation

struct MindfulnessHubView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "#F5F3F0").edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 30) {
                    FeatureButton(title: "正念冥想計時器", destination: MeditationTimerView(), icon: "timer")
                    FeatureButton(title: "呼吸練習工具", destination: BreathingExerciseView(), icon: "wind")
                    FeatureButton(title: "正念引言或名言", destination: MindfulnessQuoteView(), icon: "quote.bubble")
                }
                .padding()
            }
            .navigationTitle("正念練習")
        }
    }
}

struct FeatureButton<Destination: View>: View {
    var title: String
    var destination: Destination
    var icon: String

    var body: some View {
        NavigationLink(destination: destination) {
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                
                HStack {
                    Image(systemName: icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color(hex: "#A8A39D"))
                    Text(title)
                        .font(.title2)
                        .foregroundColor(Color(hex: "#A8A39D"))
                }
                .padding()
            }
            .padding(.horizontal)
        }
    }
}

class AudioPlayer: ObservableObject {
    var player: AVAudioPlayer?

    func playSound(soundName: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else { return }
        do {
            self.player = try AVAudioPlayer(contentsOf: url)
            self.player?.play()
        } catch {
            print("Error playing sound")
        }
    }

    func stopSound() {
        player?.stop()
    }
}

struct MeditationTimerView: View {
    @State private var meditationTime: Double = 10
    @State private var remainingTime: Double = 10 * 60 // Convert to seconds
    @State private var isPlaying: Bool = false
    @State private var selectedSound: Int = 0
    let sounds = ["Rain", "Forest", "Stream", "Guided Meditation"]
    
    @StateObject private var audioPlayer = AudioPlayer()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(hex: "#F5F3F0"), Color(hex: "#A8A39D")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 40) {
                Text(timeString(time: remainingTime))
                    .font(.system(size: 80, weight: .bold))
                    .foregroundColor(Color.white)

                Slider(value: $meditationTime, in: 1...60, step: 1)
                    .padding(.horizontal, 40)
                    .accentColor(Color.white)

                Button(action: togglePlayPause) {
                    Text(isPlaying ? "Pause" : "Start")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 20)
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(40)
                }
                .shadow(radius: 10)

                Picker("Meditation Sound", selection: $selectedSound) {
                                ForEach(0..<sounds.count) {
                                    Text(sounds[$0]).font(.title2)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .foregroundColor(Color.white)
                            .onChange(of: selectedSound) { newValue in
                                if isPlaying {
                                    audioPlayer.stopSound()
                                    audioPlayer.playSound(soundName: sounds[newValue])
                                }
                            }
            }
            .padding()
            .onReceive(timer) { _ in
                if isPlaying {
                    if remainingTime > 0 {
                        remainingTime -= 1
                    } else {
                        isPlaying = false
                        audioPlayer.stopSound()
                    }
                }
            }
        }
    }
    
    func togglePlayPause() {
            isPlaying.toggle()
            if isPlaying {
                remainingTime = meditationTime * 60
                audioPlayer.playSound(soundName: sounds[selectedSound])
            } else {
                audioPlayer.stopSound()
            }
        }
    
    func timeString(time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct BreathingExerciseView: View {
    @State private var isBreathing: Bool = false
    @State private var scale: CGFloat = 1
    @State private var phase: BreathingPhase = .inhale
    @StateObject private var audioPlayer = AudioPlayer()

    enum BreathingPhase {
        case inhale, exhale
    }

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(hex: "#F5F3F0"), Color(hex: "#A8A39D")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 40) {
                Text(phaseDescription)
                    .font(.largeTitle)
                    .foregroundColor(.white)

                Circle()
                    .scaleEffect(scale)
                    .animation(.easeInOut(duration: 4))
                    .foregroundColor(Color(hex: "#A8A39D").opacity(0.2))

                Button(action: toggleBreathing) {
                    Text(isBreathing ? "Stop" : "Start Breathing Exercise")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 20)
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(40)
                }
                .shadow(radius: 10)
            }
            .padding()
        }
    }

    var phaseDescription: String {
        switch phase {
        case .inhale:
            return "吸氣"
        case .exhale:
            return "呼氣"
        }
    }

    func toggleBreathing() {
        isBreathing.toggle()
        if isBreathing {
            startBreathingCycle()
        }
    }

    func startBreathingCycle() {
        let duration = 4.0

        switch phase {
        case .inhale:
            withAnimation {
                scale = 1.5
            }
            audioPlayer.playSound(soundName: "InhaleSound")
        case .exhale:
            withAnimation {
                scale = 1.0
            }
            audioPlayer.playSound(soundName: "ExhaleSound")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            if isBreathing {
                switch phase {
                case .inhale:
                    phase = .exhale
                case .exhale:
                    phase = .inhale
                }
                startBreathingCycle()
            }
        }
    }
}

struct MindfulnessQuoteView: View {
    @State private var currentQuote: Int = 0
    let quotes = [
        "Stay present.",
        "Embrace peace.",
        "Focus on the now.",
        "Live in the moment."
    ]

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(hex: "#F5F3F0"), Color(hex: "#A8A39D")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 40) {
                HStack {
                    Image(systemName: "quote.bubble")
                        .foregroundColor(Color(hex: "#A8A39D"))
                    Text(quotes[currentQuote])
                        .font(.title)
                        .foregroundColor(Color(hex: "#A8A39D"))
                        .multilineTextAlignment(.center)
                        .padding()
                        .transition(.slide)
                }
                
                HStack(spacing: 80) {
                    Button(action: {
                        if currentQuote > 0 {
                            withAnimation {
                                currentQuote -= 1
                            }
                        }
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                    }
                    .foregroundColor(currentQuote > 0 ? Color(hex: "#A8A39D") : Color.gray)
                    
                    Button(action: {
                        if currentQuote < quotes.count - 1 {
                            withAnimation {
                                currentQuote += 1
                            }
                        }
                    }) {
                        Image(systemName: "arrow.right")
                            .font(.title2)
                    }
                    .foregroundColor(currentQuote < quotes.count - 1 ? Color(hex: "#A8A39D") : Color.gray)
                }
            }
            .padding(.horizontal, 40)
        }
    }
}


struct MindfulnessHubView_Previews: PreviewProvider {
    static var previews: some View {
        MindfulnessHubView()
    }
}
