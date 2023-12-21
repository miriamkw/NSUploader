//
//  HeartRateObserver.swift
//  NSUploader
//
//  Created by Miriam K. Wolff on 18/10/2023.
//

import Foundation
import HealthKit

class HeartRateObserver {

    private let healthStore = HKHealthStore()

    // This function starts observing heart rate changes.
    func startObservingHeartRateChanges() {
        print("Starting to observe heart rate changes...")
        
        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!

        // Create an observer query to monitor heart rate changes.
        let query = HKObserverQuery(sampleType: heartRateType, predicate: nil) { (query, completionHandler, error) in
            if let error = error {
                // Handle the error
                print("Error observing heart rate changes: \(error.localizedDescription)")
            } else {
                // When heart rate data changes, you can fetch the latest data here
                
                self.fetchLatestHeartRateSample()
            }

            // Call the completion handler to indicate that the query has been handled.
            completionHandler()
        }

        // Execute the observer query to begin observing heart rate changes.
        healthStore.execute(query)
    }

    // This function fetches the latest heart rate sample.
    private func fetchLatestHeartRateSample() {
        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        
        // Create a predicate to fetch the most recent heart rate sample.
        let predicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictStartDate)
        
        let query = HKSampleQuery(sampleType: heartRateType, predicate: predicate, limit: 1, sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            if let error = error {
                // Handle the error
                print("Error fetching heart rate sample: \(error.localizedDescription)")
                return
            }
            
            if let heartRateSample = samples?.first as? HKQuantitySample {
                let heartRateValue = heartRateSample.quantity.doubleValue(for: HKUnit.count().unitDivided(by: .minute()))
                
                // Do something with the latest heart rate value, such as sending it to your API.
                self.sendHeartRateToAPI(heartRateValue: heartRateValue)
            }
        }
        healthStore.execute(query)
    }

    // Implement the function to send heart rate data to your API here.
    private func sendHeartRateToAPI(heartRateValue: Double) {
        
        print("HEARTRATE: ", heartRateValue)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let dateString = dateFormatter.string(from: Date())

        // Add your API request code here.
        let data = [
            "eventType": "Heartrate",
            "heartrate": heartRateValue,
            //"timestamp": dateString,
            // TODO: Add true timestamps - formatting is important to make it compatible with NS
            "timestamp": "2023-11-14T08:30:00.000Z",
            "created_at": "2023-11-14T08:30:00.000Z",
        ] as [String : Any]
        
        APIClient.shared.sendDataToAPI(endpoint: "/api/v1/activity.json", data: data) { result in
            switch result {
            case .success:
                print("Heart rate data sent successfully to API")
            case .failure(let error):
                print("Error sending heart rate data to API: \(error.localizedDescription)")
            }
        }
        
        // You can use URLSession or a networking library to send data to your API.
    }
}

