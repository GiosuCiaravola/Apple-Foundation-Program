//
//  SingleExecutionView.swift
//  GymZone Watch App
//
//  Created by Giosuè Ciaravola on 20/04/23.
//

import SwiftUI

// View per la singola esecuzione deell'esercizio in cui mostriamo animazione e descrizione

struct SingleExecutionViewWatch: View {
    
    let exercisestatic: ExerciseStatic
    
    var body: some View {
        ScrollView{
            Gif(images: exercisestatic.image, width: 150, heigth: 150)
            Spacer()
                .frame(height: 20)
            Text(exercisestatic.description)
                .font(.caption)
        }
        .navigationBarTitle(exercisestatic.exercisenamestatic)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SingleExecutionViewWatch_Previews: PreviewProvider {
    static var previews: some View {
        SingleExecutionViewWatch(exercisestatic: ExerciseStatic(exercisenamestatic: "Bench Press", description: "descrizione", bodypart: Bodyparts.chest, image: ["PP01", "PP02", "PP03", "PP04", "PP05", "PP06", "PP07", "PP08", "PP09", "PP10", "PP11", "PP12", "PP13", "PP14", "PP15", "PP16", "PP17", "PP18", "PP19", "PP20", "PP21", "PP22", "PP23", "PP24", "PP25", "PP26", "PP27", "PP28", "PP29", "PP30", "PP31", "PP32", "PP33", "PP34", "PP35", "PP36", "PP37", "PP38", "PP39", "PP40", "PP41", "PP42", "PP43", "PP44", "PP45", "PP46", "PP47", "PP48", "PP49", "PP50", "PP51", "PP52", "PP53", "PP54", "PP55", "PP56", "PP57", "PP58", "PP59", "PP60"]))
    }
}
