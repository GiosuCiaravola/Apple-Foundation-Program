//
//  AddWorkoutView.swift
//  GymZone Watch App
//
//  Created by Giosuè Ciaravola on 20/04/23.
//

import SwiftUI

struct AddWorkoutView: View {
    
//    variabile di tipo globale della view, che accede alla propietà che controlla la chiusura della stessa. Utile per chiudere la view tramite comando.
    @Environment(\.dismiss) private var dismiss
    
//  Dichiarazione della variabile con cui prenderemo il mome inserito nell'apposito TextField
    @State var workoutname: String = ""
    
//    definizione variabile d'ambiente che utilizzeremo per accedera a quella iniettata.
    @EnvironmentObject var workoutStore: WorkoutsStore
    
    var body: some View {
        VStack{
//             Utilizziamo il Form, anche se come la NavigationView, non è ottimizzato da Apple, e quindi possiamo usarlo solo per inserimenti semplici, come in questo caso in cui c'è un sisngolo TextField
            Form{
//                TextField in cui viene inserito il nome dell'allenamento, che catturiamo col Binding della variabile prima dichiarata
                Section(content: {TextField("name", text: $workoutname)}, header: {Text("Name")})
                Section(content:{
                    List{
//                        mostriamo poi tutti gli esercizi che vengono aggiunti durante la creazione del workout, per farlo semplicemente accediamo all'ultimo workout inserito (count-1), che abbiamo creato alla pressione del button che ha apaerto questa View
                        ForEach(workoutStore.workouts[workoutStore.workouts.count-1].exercises) { exercise in
                            NavigationLink(destination: SingleExerciseView(workoutIndex: workoutStore.workouts[workoutStore.workouts.count-1].id, exercise: exercise), label: {ExerciseCellWatch(exercise: exercise.exercisestat).lineLimit(1)})
                        }
//                        Sotto la lista di esercizi, motriamo il NavigationLink per agigungerne di nuovi
                        NavigationLink(destination: AddExerciseView(), label: {
                            HStack{
                                Image(systemName: "plus")
                                Text("Add Exercise")
                            }
                            .foregroundColor(.green)
                            .frame(maxWidth: .infinity, alignment: .center)
                        })
                    }
                }, header: {Text("Exercises")})
//                nel caso si voglia annnullare la creazione, cliccando su uesto bottone viene cancellato il workout creato e si torna alla view precedente
                Button(action: {
                    workoutStore.workouts.removeLast()
                    DataManager.shared.saveWorkouts(workoutStore.workouts)
                    dismiss()
                }) {
                    HStack{
                        Image(systemName: "trash")
                        Text("Delete")
                    }
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
//                nel caso si voglia salvare il workout creato, cliccando si questo bottone, viene agigornato il nome, salvato, e si torna alla view precedente
                Button(action: {
                    workoutStore.workouts[workoutStore.workouts.count-1].workoutname = workoutname
                    DataManager.shared.saveWorkouts(workoutStore.workouts)
                    dismiss()
                }) {
                    HStack{
                        Image(systemName: "square.and.arrow.down")
                        Text("Save")
                    }
                    .foregroundColor(.green)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
//        grazie a queste proprietà delle view, andiamo a anascondere il pulsante per tornare indetro "<", che il sistema mette in automatico sulle schermate quando si aprono tramite navigationlink. Lo facciamo perchè vogliamo che quest'ultima si chiude solo tramite i due bottoni di Delete o Save.
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Add Workout")
    }
}

struct AddWorkoutViewWatch_Previews: PreviewProvider {
    static var previews: some View {
        AddWorkoutView().environmentObject(WorkoutsStore())
    }
}
