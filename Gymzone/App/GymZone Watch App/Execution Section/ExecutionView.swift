//
//  ExecutionView.swift
//  GymZone Watch App
//
//  Created by Giosuè Ciaravola on 20/04/23.
//

import SwiftUI

//  View in cui mostriamo la lista di esercizi presenti nativamente nell'app, di cui è possibile vedere la singola esecuzione guidata

struct ExecutionView: View {
    
//    definizione della variabile in cui abbiamo l'array di esercizi
    var arraystatic = ExerciseDB()
    
    var body: some View {
//        mostriamo la lista con degli esercizi, in cui ognuno è un navigationlink che porta alla sua pagina singola
        List{
            ForEach(arraystatic.exercisedb) { exercise in NavigationLink(destination: SingleExecutionViewWatch(exercisestatic: exercise), label: {ExerciseCellWatch(exercise: exercise).lineLimit(1)})
            }
        }
        .navigationBarTitle("Executions")
//        con la proprietà .inline applicata al titolo della view, blocchiamo il titolo nella bassa in alto, senza possibilità di ingrandirsi come avviene, invece, nella ContentView
        .navigationBarTitleDisplayMode(.inline)
    }
}

//  Cella dela lista, in cui mostriamo animazione, nome e parte del corpo allenata
struct ExerciseCellWatch: View {

//    variabile in cui prendiamo l'esercizio da mostrare passato come parametro
    let exercise : ExerciseStatic

    var body: some View {
        HStack {
//            mostriamo la Gif
            Gif(images: exercise.image,width: 40,heigth: 40)
            Spacer().frame(width: 10)
            VStack(alignment: .leading, spacing: 5.0) {
//                mostriamo nome e parte del corpo dell'esericio, sfruttando il rawvalue impostato
                Text(exercise.exercisenamestatic)
                Text(exercise.bodypart.rawValue)
                    .font(.footnote)
            }
            Spacer()
        }
        .padding(-0)
    }
}

struct ExecutionView_Previews: PreviewProvider {
    static var previews: some View {
        ExecutionView()
    }
}
