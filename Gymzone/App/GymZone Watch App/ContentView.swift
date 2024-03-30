//
//  ContentView.swift
//  GymZone Watch App
//
//  Created by Giosuè Ciaravola on 19/04/23.
//

import SwiftUI
import HealthKit

//  View di apertura dell'applicazione, che contiene una versione alternativa del MenuBar sviluppato su IOS: comprende due Navigation Link, che contengono la parte di Esecuzione e di Schede di allenamenti.

struct ContentView: View {
    
//    Richiamo per la variabile d'ambiente
    @EnvironmentObject var workoutStore: WorkoutsStore
    
    var body: some View {
//      View generale, che su Iphone veniva usato come contenitore principale. Su watch non completamente ottimizzata, e quindi utilizzabile solo per schermate semplici come questa in cui ci sono solo due link.
        NavigationView {
//          View che ci permette di disporre i due link come elementi di una lista
            List{
//              View che ci permette di creare un bottone cliccabile che apre una nuova view. A differenza di IOS in cui potevamo aprire una schermata in diversi modi, in questo sistema, questo è l'unico modo per spostarsi tra le view
                NavigationLink(destination: WorkoutsView(), label: {
//                  Contenitore orizzontale, usato per affiancare il simbolo, al testo
                    HStack{
//                      semplice elemento grafico, utile per aggiungere dello spazio
                        Spacer()
                            .frame(width: 5)
//                      View contenitore per immagini, in questo caso contiene un'immagine di sistema che era stata usata nell'applicazione principale. Purtroppo WatchOS non supporta tutti gli AFSymbols nativi di Apple, motivo per cui il simbolo non viene richiamato come "di sistema" ma viene invocato tramite il suo nome. Questo perchè il simbolo è stato scaricato proprio da "AFSymbols" come pacchetto SVG, e caricato negli assets come "Symbols image".
                        Image("dumbbell.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
//                        la proprietà qui sotto usata, è utile per cambiare il colore principale della View. In questo caso viene applicato il colore impostato negli assets come "AccentColor", cioè il verde di sistema.
                            .foregroundColor(.accentColor)
                        Spacer()
                            .frame(width: 15)
                        Text("My Workouts")
                    }
                })
//              Situazione analoga al NavigationLink precedente.
                NavigationLink(destination: ExecutionView(), label: {
                    HStack{
                        Spacer()
                            .frame(width: 5)
                        Image("figure.strengthtraining.traditional")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.accentColor)
                        Spacer().frame(width: 15)
                        Text("Executions")
                    }
                })
            }
//          proprietà utile per impostatare il titolo della View
            .navigationBarTitle("GymZone")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
