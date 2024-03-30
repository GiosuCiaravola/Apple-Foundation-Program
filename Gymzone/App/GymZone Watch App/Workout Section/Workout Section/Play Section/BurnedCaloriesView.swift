//
//  BurnedCalorieView.swift
//  GymZone Watch App
//
//  Created by Giosuè Ciaravola on 05/05/23.
//

import SwiftUI
import HealthKit

struct BurnedCaloriesView: View {
    
//    definizione variabile d'ambiente che utilizzeremo per accedera a quella iniettata.
    @EnvironmentObject var workoutStore: WorkoutsStore
    
//    Dichiarazione dell'istanza HealthStore per accedere ai dati di HealthKit
    let healthStore = HKHealthStore()
    
//    Dichiarazione della variabile per controllare il primo recupero dei dati
    @State private var firstTime = true
    
//    Dichiarazione della varaibile per conservare le calorie bruciate quando l'allenamento è partito
    @State private var startCalories: Double = 0
    
//    Dichiarazione della variabile per ricevere le calorie bruciate
    @State private var caloriesBurned: Double = 0
    
//    Dichiarazione della varaibile per controllare l'attivazione della view
    @Binding var isActive: Bool
    
    var body: some View {
        VStack {
            Text("\(Int(caloriesBurned))")
                .font(.system(size:20))
        }
//        Inizia a monitorare le calorie bruciate quando la vista appare
        .onAppear(perform: startTracking)
    }
    
//    Funzione per richiedere l'autorizzazione a HealthKit e iniziare a monitorare le calorie bruciate
    private func startTracking() {
        let calorieType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
        
        let typesToRead: Set = [calorieType]
        
        healthStore.requestAuthorization(toShare: typesToRead, read: typesToRead) { (success, error) in
            if success {
//                Creazione della query per monitorare le calorie bruciate
                let query = HKObserverQuery(sampleType: calorieType, predicate: nil) { (query, completionHandler, error) in
                    self.updateCalories()
                }
                
//                Registrazione della query con HealthKit
                healthStore.execute(query)
            } else {
                print("Authorization failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
//    Funzione per aggiornare le calorie bruciate
    private func updateCalories() {
        let calorieType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
        
//          Creazione della query per ottenere le calorie bruciate
        let query = HKStatisticsQuery(quantityType: calorieType, quantitySamplePredicate: nil, options: .cumulativeSum) { (query, result, error) in
            if let result = result {
                if let sum = result.sumQuantity() {
                    let calories = sum.doubleValue(for: .kilocalorie())
//                    passiamo il valore al thread principale per la stampa
                    DispatchQueue.main.async {
//                        Dato che con questa quey otteniamo le calorie bruciate da inizio giornata fino al momento della query, per ottenere quelle bruciate solo da quando l'allenamento è iniziamo, alla prima query (appena parte l'allenamento), andremo a conservare il valore iniziale, che ogni volta lo sottraiamo a qullo ricalcolato
                        if firstTime {
                            startCalories = calories
                            firstTime = false
                        }
                        self.caloriesBurned = calories - startCalories
//                        copiamo le calorie bruciate nella variabile d'ambiente per il Summary
                        workoutStore.lastWorkoutCalories = "\(Int(self.caloriesBurned))"
                    }
                }
            } else {
                print("Query failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
        
        if isActive {
//            Esecuzione della query con HealthKit
            healthStore.execute(query)
        } else {
//            Interrompi il monitoraggio se il bottone Stop è stato premuto
            healthStore.stop(query)
        }
    }
}
