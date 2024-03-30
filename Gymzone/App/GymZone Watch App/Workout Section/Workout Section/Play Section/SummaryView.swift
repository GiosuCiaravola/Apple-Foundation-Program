//
//  SummaryView.swift
//  GymZone Watch App
//
//  Created by Giosuè Ciaravola on 05/05/23.
//

import SwiftUI

//  View che stampa una serie di informazioni di fine workout (si sono omessi i pesi effettuati in quanto quelli possono già essere visualizzati dalla View del singolo Workout esplodendo i singoli esercizi)

struct SummaryView: View {
    
//    dichiarazione dell avariabile in cui riceveremo tramite parametro l'esercizio appena termianto
    var workoutIndex: Int
    
//    definizione variabile d'ambiente che utilizzeremo per accedera a quella iniettata.
    @EnvironmentObject var workoutStore: WorkoutsStore
    
//    variabile di tipo globale della view, che accede alla propietà che controlla la chiusura della stessa. Utile per chiudere la view tramite comando.
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView{
            VStack {
                Text(verbatim: "Workout finished:")
                    .foregroundColor(.accentColor)
                    .font(.system(size: 13))
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    Text(verbatim: workoutStore.workouts[workoutIndex].workoutname)
                        .font(.system(size: 23))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image("dumbbell.fill")
                        .frame(alignment: .trailing)
                        .foregroundColor(.accentColor)
                }
            }
            Divider()
            VStack {
                Text(verbatim: "Total time:")
                    .foregroundColor(.accentColor)
                    .font(.system(size: 13))
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    Text(verbatim: workoutStore.lastWorkoutChrono)
                        .font(.system(size: 23))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                        .frame(width: 1)
                    Image(systemName: "clock.fill")
                        .frame(alignment: .trailing)
                        .foregroundColor(.accentColor)
                }
            }
            Divider()
            VStack {
                Text(verbatim: "Active kilocalories:")
                    .foregroundColor(.accentColor)
                    .font(.system(size: 13))
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    Text(verbatim: workoutStore.lastWorkoutCalories + " kcal")
                        .font(.system(size: 23))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemName: "flame")
                        .frame(alignment: .trailing)
                        .foregroundColor(.accentColor)
                }
            }
            Divider()
            VStack {
                Text(verbatim: "Avarage heart rate:")
                    .foregroundColor(.accentColor)
                    .font(.system(size: 13))
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    Text(verbatim: workoutStore.lastWorkoutAvarageHeartRate + " BPM")
                        .font(.system(size: 23))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                        .frame(width: 1)
                    Image(systemName: "heart.fill")
                        .frame(alignment: .trailing)
                        .foregroundColor(.accentColor)
                }
                Text(verbatim: "Range:")
                    .foregroundColor(.accentColor)
                    .font(.system(size: 12))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(verbatim: workoutStore.lastWorkoutRangeHeartRate + " BPM")
                    .font(.system(size: 14))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            Divider()
            Button(action: {dismiss()}, label: {Text(verbatim: "Done")})
                .foregroundColor(.black)
                .buttonStyle(.borderedProminent)
                .tint(.accentColor)
        }
        .navigationTitle("Summary")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView(workoutIndex: 0)
    }
}
