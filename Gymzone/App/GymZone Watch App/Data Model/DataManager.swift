//
//  DataManager.swift
//  GymZone Watch App
//
//  Created by Giosuè Ciaravola on 20/04/23.
//

import Foundation

class DataManager {
    
//    creiamo un'istanza di DataManager che potrà essere accessa globalmente all'interno dell'intera app. Questa sarà creata immediatamente grazie al modificatore static.
    static let shared = DataManager()

//    creiamo un'istanza di UserDefaults, una classe di Swift che consente di archiviare piccole quantità di dati (nel nostro caso una collezione di oggetti personalizzati), all'interno della memoria permanente del dispositivo. In particolare la stanziamo con il metodo .standard
    private let userDefaults = UserDefaults.standard
    
//    funzione che salva il nostro array di workout (presente in workoutStore), codificandolo in JSON
    func saveWorkouts(_ workouts: [Workout]) {
//        definiamo la variabile data di ripo Data?, assegnandogli proprio il risultato del try? del metodo encode() della classe JSONEncoder applicato sul nostro array di workout, che li serializza in formato JSON. Applichiamo un try perchè la serializzazione potrebbe non andare a buon fine e quindi restituire nil.
        let data = try? JSONEncoder().encode(workouts)
//        tramite il metodo set, salviamo nella cache dello UserDefaults, associato alla chiave "workouts", il nostro array di worout serializzato in JSON
        userDefaults.set(data, forKey: "workouts")
//        successivamente sincronizziamo il tutto in modo che i dati, dalla cache, vengano salvati in archivio
        userDefaults.synchronize()
    }
    
//    funzione pposta alla precedente, che ricarica dalla memoria l'array di workout e lo restituisce
    func loadWorkouts() -> [Workout] {
//        con una guard (struttura simile ad un if, ma più efficiente per la gestione di operazioni che potrebbero causare da errori), ricarichiamo i dati con il metodo .data di UserDefaults (attraverso la chiave prima impostata). Se va a buon fine questa prima operazione, eseguiamo la seconda operazione del guard, che consiste nel decodificare i dati, cioè col metodo .decode, andiamo a decodificare i dati in un array di Workout. Se una di queste due operazioni dovesse andare in errore (cioè non vengono trovati dati relativi alla chiave indicata (caso di prima esecuzione), o non si riesca a decodificare gli stessi), si va nel caso else in cui ritorniamo un array vuoto. Se tutto va a buon fine si ritorna l'array ottenuto.
        guard let data = userDefaults.data(forKey: "workouts"),
              let workouts = try? JSONDecoder().decode([Workout].self, from: data)
        else {
            return []
        }
        
        return workouts
    }
}
