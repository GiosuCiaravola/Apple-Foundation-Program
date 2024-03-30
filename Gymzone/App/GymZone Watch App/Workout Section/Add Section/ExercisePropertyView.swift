//
//  ExercisePropertyView.swift
//  GymZone Watch App
//
//  Created by Giosuè Ciaravola on 20/04/23.
//

import SwiftUI

//  View in cui possiamo Caratterizzare un esercizio statico, per aggiungerlo al Workout

struct ExercisePropertyView: View {
    
//    definizione della variabile in cui abbiamo l'array di esercizi
    @Environment(\.dismiss) private var dismiss
    
//    definizione variabile d'ambiente che utilizzeremo per accedera a quella iniettata.
    @EnvironmentObject var workoutStore: WorkoutsStore
    
//    variabile in cui prendiamo l'esericio statico selezionato nella AddExerciseView
    let exercisestatic: ExerciseStatic
    
//    varabile in cui prendiamo il numero delle serie selezionato.
    @State var sets = 1
    
//    varabile in cui prendiamo il numero delle rieptizioni selezionato.
    @State var rep = 1
    
//    varabile in cui prendiamo il numero dei minuti di recuopero selezionato.
    @State var selectedMin = 0
    
//    varabile in cui prendiamo il numero dei secondi di recupero selezionato.
    @State var selectedSec = 0
    
    var body: some View {
        ScrollView {
//            animazione dell'esercizio
            Gif(images: exercisestatic.image, width: 150, heigth: 150)
//            sezione per le serie
            Text(verbatim: "Sets")
                .font(.headline)
            HStack{
//                Utilizziamo la View Picker, che ci permette di selezionare un valore tra una lista di opzioni. Dopo aver selezionato l'elemento grafico o si scorre la lista con lo swipe, o tramite la Digital Crown, con una vibrazione ad ogni elemento transitato per il selettore. Il Primo parametro passatto a questa View è proprio il la Label che deve apparire al di sopra di esso alla sua selezione, mentre il secondo, è la variabile che cattura il valore selezionato. Il terzo parametro, o contenuto della View (come in questo caso), è la lista di opazioni, in questo caso numeri interi da 0 a 9 (si da per assunto che non si possano selezionare più di 9 serie che sono già molto al di sopra della media (4)), mostrando come valore da mostrare proprio il valore della variabile di riferimento, che in questo caso essendo sets, che è stato inizializzato ad 1 (in quanto non ha senso che sia 0 se ho selezionato l'eserciio), all'apertura della View sarà proprio sulla opzione "1"
                Picker("Sets", selection: $sets) {
                    ForEach(0..<10){
                        Text("\($0)")
                    }
                }
//                questo modificatore ci fa scegliere il tipo di Picker, in questo caso il tipo Wheel, è il tipico selettore di Apple che fa apparire i valori come su una ruota che gira dall'alto in basso e viceversa
                .pickerStyle(WheelPickerStyle())
                .frame(height: 80)
                Text(verbatim: " x ")
//                analogamente per le rep (si da sempre per assunto il valore massimo)
                Picker("Reps", selection: $rep) {
                    ForEach(0..<61){
                        Text("\($0)")
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(height: 80)
            }
            Spacer()
                .frame(height: 20)
            Text(verbatim: "Rest time")
                .font(.headline)
            HStack{
//                analogamente per i minuti
                Picker("Minutes", selection: $selectedMin) {
                    ForEach(0..<60){
                        Text("\($0)")
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(height: 80)
                Text(verbatim: " : ")
//                analogamente per i secondi
                Picker("Seconds", selection: $selectedSec) {
                    ForEach(0..<60){
                        Text("\($0)")
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(height: 80)
            }
            Spacer()
                .frame(height: 20)
//            Bottone per salvare i parametri impostati per l'esercizio scelto
            Button(action: {
                addExercise()
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
        .navigationTitle(exercisestatic.exercisenamestatic)
    }
    
//    in questa funzione andiamo a creare l'Exercise ed aggiungerlo al Workout
    func addExercise(){
//        dichiariamo l'array di serie
        var arraySet: [WorkoutSet] = []
//        popoliamo l'array col numero di serie selezionato (almeno 1), impostando come peso 0 (verrà modificato alla prima esecuzione dell'allenamento)
        for index in 1...(sets){
//            notiamo che come id andiamo ad assegnare l'indice che avrà quel set nell'array
            arraySet.append(WorkoutSet(id: index-1, reps: rep, weight: 0))
        }
//        dichiariamo e inizializziamo l'Exercise con il costruttore che richiede l'esercizio statico scelto, andando poi a modificare gli altri parametri
        var exercisefin = Exercise(exercisestat: exercisestatic)
//        modifichiamo l'id, assegnando sempre l'indice di quell'esercizio nell'array di esercizi di quel Workout (count-1)
        exercisefin.id = workoutStore.workouts[workoutStore.workouts.count-1].exercises.count
//        come serie l'array prima creato
        exercisefin.sets = arraySet
//        assegniamo i minuti
        exercisefin.min = selectedMin
//        assegniamo i secondi
        exercisefin.sec = selectedSec
//        aggiungiamo l'esercizio all'ultimo workout creato (quello che stiamo modificando)
        workoutStore.workouts[workoutStore.workouts.count-1].exercises.append(exercisefin)
    }
}

struct ExercisePropertyView_Previews: PreviewProvider {
    static var previews: some View {
        ExercisePropertyView(exercisestatic: ExerciseStatic(exercisenamestatic: "Bench Press", description: "descrizione", bodypart: Bodyparts.chest, image: ["PP01", "PP02", "PP03", "PP04", "PP05", "PP06", "PP07", "PP08", "PP09", "PP10", "PP11", "PP12", "PP13", "PP14", "PP15", "PP16", "PP17", "PP18", "PP19", "PP20", "PP21", "PP22", "PP23", "PP24", "PP25", "PP26", "PP27", "PP28", "PP29", "PP30", "PP31", "PP32", "PP33", "PP34", "PP35", "PP36", "PP37", "PP38", "PP39", "PP40", "PP41", "PP42", "PP43", "PP44", "PP45", "PP46", "PP47", "PP48", "PP49", "PP50", "PP51", "PP52", "PP53", "PP54", "PP55", "PP56", "PP57", "PP58", "PP59", "PP60"]))
    }
}
