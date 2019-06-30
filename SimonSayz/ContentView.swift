//
//  ContentView.swift
//  SimonSayz
//
//  Created by Wiktor on 29/06/2019.
//  Copyright © 2019 Wiktor. All rights reserved.
//

import SwiftUI
import Combine

class ButtonSettings: BindableObject {
    let didChange = PassthroughSubject<Void, Never>()
    var alphas = [0.5, 0.5, 0.5, 0.5] {
        didSet {
            didChange.send(())
        }
    }
    var isTheFirstTime = true {
        didSet {
            didChange.send(())
        }
    }
    
    var guessArray = [Int]() {
        didSet {
            didChange.send(())
        }
    }
    
    var wait = 1.0 {
        didSet {
            didChange.send(())
        }
    }
    
    var subheadlineText = "To start press any button!" {
        didSet {
            didChange.send(())
        }
    }
    
}

struct ContentView : View {
    
    static var array: [Int] = []
    
    @EnvironmentObject var settings: ButtonSettings
    
    static func showSequence(settings: ButtonSettings) {
        func wait(time: Double, _ execute: @escaping () -> Void) {
            DispatchQueue.main.asyncAfter(deadline: .now() + time, execute: execute)
        }
        let semaphore = DispatchSemaphore(value: 0)
        for index in settings.guessArray {
            semaphore.wait()
            wait(time: 2.0) {
                settings.alphas[index] = 1.0
                wait(time: 0.3) {
                    settings.alphas[index] = 0.5
                    semaphore.signal()
                }
            }
        }
    }

    var body: some View {
        VStack {
            VStack() {
                Text("Simon Sayz")
                    .font(.title)
                Text(settings.subheadlineText)
                    .font(.subheadline)
                Text("Number of rounds: \(settings.guessArray.count)")
                    .padding()
            }
            .padding(.top, -70)
            
            HStack(spacing: 25) {
                SimonButton(color: .blue, index: 0)
                SimonButton(color: .red, index: 1)
                SimonButton(color: .green, index: 2)
                SimonButton(color: .yellow, index: 3)
            }
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
