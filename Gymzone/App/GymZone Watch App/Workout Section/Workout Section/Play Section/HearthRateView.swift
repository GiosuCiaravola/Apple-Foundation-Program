//
//  HearthRateView.swift
//  GymZone Watch App
//
//  Created by Giosuè Ciaravola on 04/05/23.
//

import SwiftUI
import HealthKit

struct HeartRateView: View {
    
//    Dichiarazione della variabile di stato per la frequenza cardiaca
    @State private var heartRate: Double = 0.0
    
//    Dichiarazione del timer per l'esecuzione periodica della scansione del battito cardiaco
    @State private var timer: Timer?
    
//    Istanza di HKHealthStore per accedere ai dati di HealthKit
    let healthStore = HKHealthStore()
    
//    Dichiarazione del binding per attivare le query
    @Binding var isActive: Bool
    
//    Dichiarazione di varie variabili utili ai calcoli delle statistiche per il Summary
    @State var min = 200
    @State var max = 0
    @State var sum = 0
    @State var count = 0
    
//    definizione variabile d'ambiente che utilizzeremo per accedera a quella iniettata.
    @EnvironmentObject var workoutStore: WorkoutsStore
    
    var body: some View {
        VStack {
            Text("\(Int(heartRate))")
                .font(.system(size:20))
        }
//        all'apparizione chiede l'autorizzazione e fa partire le scansioni
        .onAppear {
            self.authorizeHealthKit()
            self.startHeartRateUpdates()
        }
    }
    
//    funzione per richiedere autorizzazioni con gestione dei casi
    func authorizeHealthKit() {
        let typesToRead: Set = [HKObjectType.quantityType(forIdentifier: .heartRate)!]
        healthStore.requestAuthorization(toShare: typesToRead, read: typesToRead) { success, error in
            if success {
                print("Successfully authorized HealthKit")
            } else {
                print("Error authorizing HealthKit: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
//    funzione che richiede la ferquenza cardiaca
    func startHeartRateUpdates() {
//        verifichiamo di riuscire a recuperare il tipo .heartRate
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            print("Heart rate type not available")
            return
        }
//        verificata la disponibilità, andiamo a dichiarare la query che recupera la frequenza e lo converte in battiti al mionuti salvandolo nella variabile di stato corrispondente
        let query = HKObserverQuery(sampleType: heartRateType, predicate: nil) { query, completionHandler, error in
            if error != nil {
                print("Error starting heart rate updates: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            self.fetchLatestHeartRateSample { sample in
                if let sample = sample {
                    let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                    let heartRate = sample.quantity.doubleValue(for: heartRateUnit)
                    DispatchQueue.main.async {
                        self.heartRate = heartRate
                    }
                }
            }
        }
//        viene eseguita la query scandita da un 
        healthStore.execute(query)
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.fetchLatestHeartRateSample { sample in
                if let sample = sample {
                    let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                    let heartRate = sample.quantity.doubleValue(for: heartRateUnit)
//                    passiamo il valore al thread principale per la stampa
                    DispatchQueue.main.async {
                        self.heartRate = heartRate
//                        salviamo minimo e massimo per il range nel summary
                        if Int(heartRate) < min {
                            min = Int(heartRate)
                        }
                        if Int(heartRate) > max {
                            max = Int(heartRate)
                        }
//                        salviamo somma e numero di battiti per calcolare la media per il summary
                        sum = sum + Int(heartRate);
                        count = count + 1;
                        workoutStore.lastWorkoutRangeHeartRate = "\(min)-\(max)"
                        workoutStore.lastWorkoutAvarageHeartRate = "\(Int(sum/count))"
                    }
                }
            }
        }
    }
    
//    funzione che recupera l'ultimo campione di frequenza cardiaca
    func fetchLatestHeartRateSample(completion: @escaping (HKQuantitySample?) -> Void) {
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            print("Heart rate type not available")
            completion(nil)
            return
        }
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: heartRateType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { query, results, error in
            if error != nil {
                print("Error fetching latest heart rate sample: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            let samples = results as? [HKQuantitySample]
            completion(samples?.first)
        }
//        controllo sul Binding per terminare le query
        if isActive {
            healthStore.execute(query)
        } else {
            healthStore.stop(query)
        }
    }
}
