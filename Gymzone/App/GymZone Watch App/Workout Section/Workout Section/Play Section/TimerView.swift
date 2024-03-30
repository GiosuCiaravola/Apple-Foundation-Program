//
//  TimerView.swift
//  GymZone Watch App
//
//  Created by Giosuè Ciaravola on 05/05/23.
//

import SwiftUI

struct TimerView: View {
    
//    dichiarazione variabile di stato che conta il tempo rimasto
    @State private var timeRemaining = 0
    
//    dichiaraione variabile di stato attiva se il timer è in esecuzione
    @State private var isTimerRunning = false
    
//    dichiarazione della variabile di stato che verrà passata come parametro, indicando il tempo da contare
    @State var restTime: Int

    var body: some View {
        VStack {
            Text("Rest time")
                .foregroundColor(.accentColor)
            ZStack {
                Text(String(format: "%02d:%02d", timeRemaining / 60, timeRemaining % 60))
//                progrsso del timer mostrato tramite la view definita in basso
                CircularProgressView(progress: Double(restTime - timeRemaining) / Double(restTime))
                    .frame(width: 80, height: 80)
            }
            Spacer()
                .frame(height: 10)
            HStack {
//                bottone che azzera il timer e lo fa partire
                Button("Start") {
                    timeRemaining = restTime;
                    startTimer()
                }
                .buttonStyle(.borderedProminent)
                .foregroundColor(.black)
                .tint(.accentColor)
//                se il timer è in movimento il tasto è disattivato
                .disabled(isTimerRunning)
//                bottone ce azzera il timer e lo ferma
                Button("Reset") {
                    timeRemaining = restTime;
                    resetTimer()
                }
                .buttonStyle(.borderedProminent)
                .foregroundColor(.black)
                .tint(.accentColor)
//                se il timer è fermo il tasto è disattivato
                .disabled(!isTimerRunning)
            }
        }
    }

//    funzione che fa partire il timer
    private func startTimer() {
        isTimerRunning = true
//        dichiarazione del timer che ogni secondo conta un decrementa di 1 l'apposita variabile
        _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if isTimerRunning && timeRemaining > 0 {
                timeRemaining -= 1
            } else {
//                se il timer arriva a 0 scateniamo la vibrazione
                if timeRemaining == 0 {
                    WKInterfaceDevice.current().play(WKHapticType.retry)
                }
//                se il timer arriva a 0 oppure viene fermato con reset, fermiamo il timer invalidandolo e aggiorniamo la variabile booleana (utile solo nel caso il timer arrivi a 0)
                timer.invalidate()
                isTimerRunning = false
            }
        }
    }
    
//    funzione che ferma il timer cambiando lo stato dell'apposita variabile booleana
    func resetTimer() {
        isTimerRunning = false
    }
}

//  View che ci permette di indicare il progresso in maniera circolare
struct CircularProgressView: View {
//    Variabile per controllare l'attivazione dell'animazione
    @State private var isAnimating = false
    
//    variabile per ricevere il progresso da mostrare
    var progress: Double
    
    var body: some View {
        VStack {
            ZStack {
//                impostiamo un cerchio grigio di sfondo statico
                Circle()
                    .stroke(lineWidth: 6.0)
                    .opacity(0.3)
//                e poi un secondo cerchio sovrapposto che verrà colorato piano piano in abse al progresso
                Circle()
//                      con trim andiamo a dire quale porzione del cerchio debba colorarsi. nello specifo da 0, al valore del progresso, che col timer avanza.
                    .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
//                      con stroke possiamo rendere arrotorndata la punta della sezione del cerchio che avanza.
                    .stroke(style: StrokeStyle(lineWidth: 6.0, lineCap: .round, lineJoin: .round))
//                      con totationEffect andiamo a spostare l'origina del cerchio che originariamente sta a destra (ad ore 3), mentre noio lo vogliamo in alto (ad ora 12).
                    .rotationEffect(Angle(degrees: 270.0))
                    .foregroundColor(.accentColor)
//                      rendiamo il taglio animato
                    .animation(.easeInOut(duration: 1), value: progress)
            }
        }
//        facciamo partire l'animazione
        .onAppear() {
            withAnimation(.easeInOut(duration: 1)) {
                self.isAnimating = true
            }
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(restTime: 200)
    }
}
