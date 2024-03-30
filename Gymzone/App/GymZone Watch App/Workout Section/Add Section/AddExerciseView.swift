//
//  AddExerciseView.swift
//  GymZone Watch App
//
//  Created by Giosuè Ciaravola on 20/04/23.
//

import SwiftUI

//  View in cui mostiamo la lista di esercizi nativi presenti nell'app, in modo da scegliere, durante la creazione, quale caratterizzare e aggiungere al proprio allenamento

struct AddExerciseView: View {
    
//    definizione della variabile in cui abbiamo l'array di esercizi
    var arraystatic = ExerciseDB()
    
    var body: some View {
        List{
//            Nella lista di esercizi mostrati, quando selezionati, portano alla View di caratterizzazione dell'esercizio selezionato
            ForEach(arraystatic.exercisedb) { exercise in
                NavigationLink(destination: ExercisePropertyView(exercisestatic: exercise), label: {ExerciseCellWatch(exercise: exercise).lineLimit(1)})
            }
        }
        .navigationTitle("Add Exercise")
    }
}

struct AddExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        AddExerciseView()
    }
}
