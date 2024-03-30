//
//  GymZoneApp.swift
//  GymZone Watch App
//
//  Created by Giosuè Ciaravola on 19/04/23.
//

import SwiftUI
import HealthKit

//  Applicazione completamente scritta in SwiftUI, come versione stand alone per WatchOS dell'applicazione sviluppata durante il corso "Apple Foundation Program". Oltre alla completa riprogettazione delle interfacce, a causa sia delle ristrette dimensioni, che dei diversi elementi grafici, si è introdotto l'utilizzo dell'HealthKit, per ottenere informazioni come Calorie bruciate e Battito cardiaco in tempo reale.

@main
struct GymZoneApp: App {
    //    Inizializzazione della variabile d'ambiente, cioè il contenitore principale delle nostre strutture dati, inizializzato col costruttore principale.
    @StateObject var workoutStoreNew = WorkoutsStore()
    var body: some Scene {
        WindowGroup {
//            iniettiamo la variabile d'ambiente in tutte le View nidificate nella ContentView (cioè tutte)
            ContentView().environmentObject(workoutStoreNew)
        }
    }
}
