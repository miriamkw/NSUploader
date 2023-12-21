//
//  HealthKitManager.swift
//  NSUploader
//
//  Created by Miriam K. Wolff on 18/10/2023.
//

import HealthKit

class HealthKitManager {

    let healthStore = HKHealthStore()

    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, nil)
            return
        }

        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!

        healthStore.requestAuthorization(toShare: nil, read: [heartRateType]) { (success, error) in
            DispatchQueue.main.async {
                completion(success, error)
            }
        }
        
        healthStore.enableBackgroundDelivery(for: heartRateType, frequency: .immediate) { (success, error) in
            if success {
                // Background delivery enabled
                print("Background delivery enabled")
            } else {
                // Handle the error
                print("Something went wrong with background deliveries")
            }
        }
    }
}

