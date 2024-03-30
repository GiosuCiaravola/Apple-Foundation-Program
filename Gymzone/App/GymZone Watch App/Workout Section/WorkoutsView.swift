//
//  WorkoutViewWatch.swift
//  GymZone Watch App
//
//  Created by Giosuè Ciaravola on 20/04/23.
//

import SwiftUI

//  View in cui vediamo la lista di Workout creati, e il bottone per poterne creare di nuovi

struct WorkoutsView: View {
    
//    variabile che attiva l'apertura della AddView. Di tipo State perchè deve causare un ricaricamento della view ad ogni suo cambiamento.
    @State private var showAddView = false
    
//    definizione variabile d'ambiente che utilizzeremo per accedera a quella iniettata.
    @EnvironmentObject var workoutStore: WorkoutsStore
    
    var body: some View {
        ScrollView{
//            usiamo lo stesso metodo visto nella SingleWorkoutView per nascondere il navigationLink che verrà attivato tramite toggle
            ZStack{
                NavigationLink(destination: AddWorkoutView(), isActive: $showAddView) {
                    EmptyView()
                }
//                questo bottone porta alla creazione di un alenamento. Prima di farlo, crea un contenitore per il nuovo allenamento, mettendo un nome moementaneo, e agigornando la memoria
                Button(action: {
                    workoutStore.addWorkout(Workout(id: workoutStore.workouts.count, workoutname: "Workout \(workoutStore.workouts.count+1)", exercises: []))
                    DataManager.shared.saveWorkouts(workoutStore.workouts)
                    self.showAddView.toggle()
                }) {
                    HStack{
                        Image(systemName: "plus")
                        Text("New Workout")
                    }
                    .foregroundColor(.black)
                }
                .buttonStyle(.borderedProminent)
                .tint(.accentColor)
            }
//            controlliamo se ci sono effettivamente allenamenti in memoria, altrimenti andiamo a mostrare una Stringa alternativa.
            if workoutStore.workouts.isEmpty {
                Spacer()
                    .frame(width: 100, height: 50)
                Text("No workouts")
                    .foregroundColor(.secondary)
            } else {
                Spacer()
                    .frame(height: 5)
                Text("My workouts")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
//                se gli allenamenti ci sono li mostriamo come navigationlink che ci portano alle SingleWorkoutView dei singoli allenamenti
                ForEach(workoutStore.workouts){workout in
                    NavigationLink(destination: SingleWorkoutView(workout: workout), label: {
                        Text(workout.workoutname)
                    })
                }
            }
        }
        .navigationTitle("Workouts")
    }
}

struct WorkoutsView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutsView().environmentObject(WorkoutsStore())
    }
}
