//
//  ChronoView.swift
//  GymZone Watch App
//
//  Created by Giosuè Ciaravola on 05/05/23.
//

import SwiftUI

//  View che stampa il tempo passato dal momento in cui è stata aperta (quando l'allenamento inizia), e quando finisce (in realtà ogni volta che sparisce dalla vista), carica il tempo passato nella rispettiva del WorkoutStore (così da poterla mostrare nel Summary)

struct ChronoView: View {
    
//    definizione variabile d'ambiente che utilizzeremo per accedera a quella iniettata.
    @EnvironmentObject var workoutStore: WorkoutsStore
    
//    varoibile in cui contiamo il tempo, inizialmente a 0
    @State private var elapsedTime = TimeInterval.zero
    
//    booleana che attiviamo dalla View chiamante tramite Binding
    @Binding var isChronoRunning: Bool
    
    var body: some View {
//        semplicementre mostriamo il tempo passato nel formato definito
        Text("\(formattedElapsedTime)")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(Font.system(size: 20, design: .monospaced))
            .onAppear(perform: {
//                facciamo partire il tempo
                if self.isChronoRunning {
                    self.startChrono()
                }
            })
            .onDisappear(perform: {
//                copiamo il tempo passato nella variabile d'ambiente per il Summary
                workoutStore.lastWorkoutChrono = formattedElapsedTime
            })
    }
    
//    tempo formattato in maniera leggibile, dato che contiamo solo i millisecondi
    private var formattedElapsedTime: String {
        let totalMilliseconds = Int(elapsedTime * 1000)
        let hours = totalMilliseconds / 3600000
        let minutes = (totalMilliseconds % 3600000) / 60000
        let seconds = (totalMilliseconds % 60000) / 1000
        let milliseconds = (totalMilliseconds % 1000) / 10
        
//        controllo che effettuiamo per non mostrare sempre anche lo "00" delle ore, che risutla sgradevole, così lo mostriamo solo se serve.
        if hours > 0 {
            return String(format: "%02d:%02d:%02d,%02d", hours, minutes, seconds, milliseconds)
        } else {
            return String(format: "%02d:%02d,%02d", minutes, seconds, milliseconds)
        }
    }
    
//    funzione con cui facciamo partire il Timer che conta i millisecondi
    private func startChrono() {
        isChronoRunning = true
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            if isChronoRunning {
                print("dio \(elapsedTime)")
                self.elapsedTime += 0.01
            } else {
//                controlliamo ogni volta se isChronoRunning è attivo, perchè in caso contrario significa che l'allenamento è finito e si può fermare il Timer
                timer.invalidate()
            }
        }
    }
    
//    funzione per fermare il conteggio
    private func stopChrono() {
        isChronoRunning = false
    }
}

//struct ChronoView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChronoView()
//    }
//}
