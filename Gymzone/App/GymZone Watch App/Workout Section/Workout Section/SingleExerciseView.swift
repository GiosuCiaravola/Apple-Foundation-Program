//
//  SingleExecutionView.swift
//  GymZone Watch App
//
//  Created by Giosuè Ciaravola on 26/04/23.
//

import SwiftUI

//  View in cui visualizziamo un singolo esercizio con tutte le sue proprietà: esecuzione, serie con i rispettivi kg (0 alla creazione) e ripetizioni, tempo di recupero e possibilità di eliminazione.

struct SingleExerciseView: View {
    
//    definizione variabile d'ambiente che utilizzeremo per accedera a quella iniettata.
    @EnvironmentObject var workoutStore: WorkoutsStore
    
//    variabile in cui prendiamo l'id del workout cui appartiene l'esercizio aperto
    let workoutIndex: Int
    
//    variabile di tipo globale della view, che accede alla propietà che controlla la chiusura della stessa. Utile per chiudere la view tramite comando.
    @Environment(\.dismiss) private var dismiss
    
//    variabile in cui prendiamo una copia dell'esercizio da mostrare
    let exercise: Exercise
    
    var body: some View {
        ScrollView{
//            View creata da me, pssibile trovare la sua definizione in GifView, che ci permette di mostrare l'animazione dell'esercizio con dimensioni passate come parametri
            Gif(images: exercise.exercisestat.image, width: 150, heigth: 150)
//            per ogni serie dell'esercizi0, mostriamo le rispettive rep, e i rispettivi kg
            ForEach(exercise.sets) { workoutSet in
                HStack {
                    Text("Set \(workoutSet.id + 1):")
                        .foregroundColor(.accentColor)
                    Text("\(workoutSet.reps) reps, \(workoutSet.weight) kg")
                }
                Spacer()
                    .frame(height: 5)
            }
            
//            mostriamo il tempo di recumero
            HStack {
                Text("Rest time:")
                    .foregroundColor(.accentColor)
                Spacer()
                Text(String(format: "%02d:%02d", exercise.min, exercise.sec))
            }
            .padding(.horizontal, 16)
            Spacer()
                .frame(height: 10)
//            bottone per la cancellazione, analogo a quello per l'allenamento in SingleWorkoutView
            Button(action: {
                workoutStore.workouts[workoutIndex].deleteExercise(exerciseId: exercise.id)
                DataManager.shared.saveWorkouts(workoutStore.workouts)
                dismiss()
            }) {
                HStack{
                    Image(systemName: "trash")
                    Text("Delete Exercise")
                }
                .foregroundColor(.red)
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }.navigationTitle(exercise.exercisestat.exercisenamestatic)
    }
}

struct SingleExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        let exercisestatic = ExerciseStatic(exercisenamestatic: "Incline Bench Press", description: "Lie face up on a flat bench, and grip a barbell with the hands slightly wider than shoulder-width. Press the feet into the ground and the hips into the bench while lifting the bar off the rack. Slowly lower the bar to the chest by allowing the elbows to bend out to the side. Stop when the elbows are just below the bench, and press feet into the floor to press the weight straight up to return to the starting position.", bodypart: Bodyparts.chest, image: ["PI01", "PI02", "PI03", "PI04", "PI05", "PI06", "PI07", "PI08", "PI09", "PI10", "PI11", "PI12", "PI13", "PI14", "PI15", "PI16", "PI17", "PI18", "PI19", "PI20", "PI21", "PI22", "PI23", "PI24", "PI25", "PI26", "PI27", "PI28", "PI29", "PI30", "PI31", "PI32", "PI33", "PI34", "PI35", "PI36", "PI37", "PI38", "PI39", "PI40", "PI41", "PI42", "PI43", "PI44", "PI45", "PI46", "PI47", "PI48", "PI49", "PI50", "PI51", "PI52", "PI53", "PI54", "PI55", "PI56", "PI57", "PI58", "PI59", "PI60"])
        SingleExerciseView(workoutIndex: 0, exercise: Exercise(exercisestat: exercisestatic))
    }
}
