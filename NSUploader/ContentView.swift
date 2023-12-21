//
//  ContentView.swift
//  NSUploader
//
//  Created by Miriam K. Wolff on 18/10/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var isHealthKitAuthorized = false
    let healthKitManager = HealthKitManager()
    let heartRateObserver = HeartRateObserver() // Create an instance of the observer
        
    var body: some View {
        VStack {
            if isHealthKitAuthorized {
                Text("HealthKit access granted!")
            } else {
                Button("Request HealthKit Access") {
                    healthKitManager.requestAuthorization { success, error in
                        if success {
                            isHealthKitAuthorized = true
                            
                            // Start observing heart rate changes when access is granted
                            heartRateObserver.startObservingHeartRateChanges()

                        } else {
                            // Handle the authorization error
                        }
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
