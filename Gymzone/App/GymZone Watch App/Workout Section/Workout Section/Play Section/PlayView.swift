//
//  PlayView.swift
//  GymZone Watch App
//
//  Created by Giosuè Ciaravola on 26/04/23.
//

import SwiftUI

//  View utile ad eseguire l'allenamento, in cui vengono mostrate delle informazioni generali come tempo trascorso, battito cardiaco e calorie bruciate su una prima schermata, e le informazioni dei singoli esercizi con timer ad hoc e al possibilità di cambiare i pesi delle serie in una secodna schermata

struct PlayView: View {
    
//    definizione variabile d'ambiente che utilizzeremo per accedera a quella iniettata.
    @EnvironmentObject var workoutStore: WorkoutsStore
    
//    dichiarazione della variabile in cui riceveremo come parametro l'indice dell'allenamento da eseguire
    var workoutIndex: Int
    
//    dichiarazioen della variabile in cui riceveremo come parametro la matrice per i pesi nuovi
    @State var newWeight: Array<Array<Int>>
    
//    dichiarazione della variabile per controlalre l'aniamzione del cuore che batte
    @State private var isAnimating = false
    
//    dichiarazione della variabile per controllare l'attivazione delle view che viaggiano su altri thread, come calorie, battiti e chrono
    @State var isActiveWorkout = true
    
//    variabile di tipo globale della view, che accede alla propietà che controlla la chiusura della stessa. Utile per chiudere la view tramite comando.
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
//        Questa view ci permette di mostrare i suo figli diretti in diverse pagine della stessa view che si pososno scorrere da sinistra a destra
        TabView{
            VStack {
                Text("Workout information")
                    .font(.headline)
                    .foregroundColor(.accentColor)
                Spacer()
                    .frame(height: 5)
//                richiamiamo la chronoView con il Binding sulla varibile booleana dichiarata
                ChronoView(isChronoRunning: $isActiveWorkout)
                Spacer()
                    .frame(height: 5)
                HStack{
//                    richiamiamo la burnedCaloriesView con il Binding sulla varibile booleana dichiarata
                    BurnedCaloriesView(isActive: $isActiveWorkout)
                    Text("Active\nKcal")
                        .font(.system(size:9))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                    .frame(height: 5)
                HStack{
//                    richiamiamo la heartRateView con il Binding sulla varibile booleana dichiarata
                    HeartRateView(isActive: $isActiveWorkout)
                    Text("BPM")
                        .font(.system(size:15))
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                        .scaleEffect(isAnimating ? 1.2 : 0.9)
//                        creaiamo l'animazione del battito cardiaco attivando l'animazone con l'apposita funzion, quando il cuore appare, facendo periodicamente cambiare il valore di scala dell'immagine del cuore
                        .onAppear {
                            withAnimation(Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                                        self.isAnimating = true
                                    }
                        }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                    .frame(height: 5)
//                quando il botone per teminare il workout viene remuto, viene attivata la variabile booleana nella struttura iniettata, in modo che venga mostrato il summary. Viene disattivata la variabile che tiene attive le funzioni che viaggiano su altri thred, e infine viene chiusa la pagina.
                Button(action: {
                    workoutStore.showSummary = true
                    self.isActiveWorkout = false
                    dismiss()
                }, label: {
                    HStack {
                        Text(verbatim: "End Workout")
//                        immagine di sistema non supportata su WatchOS. Importata negli assets
                        Image("flag.checkered")
                    }
                })
                    .foregroundColor(.black)
                    .buttonStyle(.borderedProminent)
                    .tint(.accentColor)
            }
            ScrollView {
//                Per ogni esercizio mostriamo l'animazione, il timer con il tempo ipostato per quell'esercizio, le serie impostate con quell'esercizio.
                ForEach(workoutStore.workouts[workoutIndex].exercises) {
                    exercise in
                    Text(verbatim: exercise.exercisestat.exercisenamestatic)
                        .foregroundColor(.accentColor)
                        .font(.title3)
                        .bold()
                    Gif(images: exercise.exercisestat.image, width: 150, heigth: 150)
                    TimerView(restTime: exercise.min * 60 + exercise.sec)
                    ForEach(exercise.sets) {
                        workoutSet in
                        VStack{
                            Spacer()
                                .frame(height: 10)
                            Text("Set \(workoutSet.id+1)")
                                .foregroundColor(.accentColor)
                            HStack{
                                Text("\(workoutSet.reps) x ")
//                                cambiamo il baseline offset per far si che le stringhe escano alla stessa altezza delcontenuto del picker.
                                    .baselineOffset(-12)
//                                per ogni serie abbiamo il picker per cambiare il peso, ed ogni picker lo valorizziamo con il valore della matrice inquadrato dall'indice dell'esercizio e quello della serie.
                                Picker("Weight", selection: $newWeight[exercise.id][workoutSet.id]) {
                                    ForEach(0..<300){
                                        Text("\($0)")
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                                .frame(width: 60, height: 60)
                                Text(" kg")
                                    .baselineOffset(-12)
                            }
                        }
//                        all'apparizione della View, vengono copiati i valori nella struttura nella variabile newWeight, così che nel picker, in quella specifica serie, appaiano i valori impostati l'ultima volta per quella serie di quell'esercizio.
                        .onAppear(perform: {
                            newWeight[exercise.id][workoutSet.id] = workoutStore.workouts[workoutIndex].exercises[exercise.id].sets[workoutSet.id].weight
                        })
//                        quando la View esce dalla vista, viene fatta la copia al contrario, e viene salvato il tutto in UserDefault
                        .onDisappear(perform: {
                            workoutStore.workouts[workoutIndex].exercises[exercise.id].sets[workoutSet.id].weight = newWeight[exercise.id][workoutSet.id]
                            DataManager.shared.saveWorkouts(workoutStore.workouts)
                        })
                    }
                    Divider()
                        .frame(height: 20)
                }
            }
        }
        .navigationTitle(workoutStore.workouts[workoutIndex].workoutname)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
}

struct PlayView_Previews: PreviewProvider {
    static var previews: some View {
        PlayView(workoutIndex: 0, newWeight: [])
    }
}
