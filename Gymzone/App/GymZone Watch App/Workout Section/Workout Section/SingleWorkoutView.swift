//
//  SingleWorkoutView.swift
//  GymZone Watch App
//
//  Created by Giosuè Ciaravola on 20/04/23.
//

import SwiftUI

//  View di apertura del singolo allenamento, da cui è possibile eliminarlo, modificarlo  (eliminando gli esercizi), o eseguirlo.

struct SingleWorkoutView: View {
    
//    variabile che contiene il valore a cui il countdown deve essere azzerato
    private let startingCountdownSeconds = 4
    
//    variabile che contiene il valore che il countdown deve contare. Di tipo State perchè deve causare un ricaricamento della view ad ogni suo cambiamento.
    @State private var countdownSeconds = 4
    
//    variabile che attiva il countdown. Di tipo State perchè deve causare un ricaricamento della view ad ogni suo cambiamento.
    @State private var isCountdownRunning = false
    
//    variabile di tipo globale della view, che accede alla propietà che controlla la chiusura della stessa. Utile per chiudere la view tramite comando.
    @Environment(\.dismiss) private var dismiss
    
//    variabile che attiva l'apertura della PlayView. Di tipo State perchè deve causare un ricaricamento della view ad ogni suo cambiamento.
    @State private var showPlayView = false
    
//    definizione variabile d'ambiente che utilizzeremo per accedera a quella iniettata.
    @EnvironmentObject var workoutStore: WorkoutsStore
    
//    variabile che attiva l'apertura della SummaryView. Di tipo State perchè deve causare un ricaricamento della view ad ogni suo cambiamento.
    @State private var showSummaryView = false
    
//    variabile che contiene l'allenamento da visualizzate, passato come parametro alla view.
    let workout: Workout
    
    var body: some View {
//        condizione per mostrare il countdown
        if isCountdownRunning {
//            view che ci permette di mostrare il cerchio di caricamento sovrapposto al numero del countdown
            ZStack{
//                View che basandosi su un progresso soggetto ad un binding (in questo caso countdownSeconds) normalizzato, mostra una progressione circolare
                CircularProgressView(progress: Double(4-(countdownSeconds))/4.0)
                    .frame(width: 130,height: 130)
                VStack{
//                    check per controllare a che nuemro del countdown siamo arrivati: all'inizio viene mostrato "Ready", poi i numeri da 3 a 1, e infine "Go"
                    if countdownSeconds == 4 {
                        Text("Ready")
                            .foregroundColor(.accentColor)
                            .font(.largeTitle)
//                        con il metodo .onReceive, presente su tutte le View di SwiftUI, andiamo a generare un evento quando la View su cui è applicato viene mostrata sullo standard Output. In questo caso viene stanziato un timer che emana eventi ogni secondo (every: 1), sul thread principale (on: .main), con priorità nella coda di esecuzione comune (in: .common). Il metodo "autoconnect()" è chiamato per avviare il timer e connetterlo all'editor di pubblicazione, in modo che l'editor inizi a emettere eventi. Ad ogni evento lanciato (ogni secondo) viene richiamata la funzione countdownCheck (vedere più in basso).
                            .onReceive(Timer.publish(every: 1, on: .main, in:.common).autoconnect()) { _ in
                                countdownCheck()
                            }
                    }
                    else if countdownSeconds == 0 {
                        Text("Go!")
                            .foregroundColor(.accentColor)
                            .font(.largeTitle)
                            .onReceive(Timer.publish(every: 1, on: .main, in:.common).autoconnect()) { _ in
                                countdownCheck()
                            }
                    }
                    else {
                        Text("\(countdownSeconds)")
                            .foregroundColor(.accentColor)
                            .font(.largeTitle)
                            .onReceive(Timer.publish(every: 1, on: .main, in:.common).autoconnect()) { _ in
                                countdownCheck()
                            }
                    }
                }
            }
            .navigationTitle("")
//            grazie a cquesto metodo nascondiamo il tasto per tornare indietro, presentato automaticamente nelle view aperte tramite navigationlink.
            .navigationBarBackButtonHidden(true)
        } else {
            ScrollView{
//                come detto l'unico modo per aprire un'altra view è usare un NavigationLink, quindi sia per aprire la PlayView alla fine del countdown, sia per aprire il SummaryView a fine allenamento, creiamo due NavigationLink, nascoste dietro un Button, che ativiamo tramite toggle
                ZStack{
//                    in questo NavigationLink, tramite il parametro isActive:, usiamo un booleano per richiamarla, passandogli l'id del workout (cioè il suo indice in workoutStore, così da poterlo accedere)
                    NavigationLink(destination: SummaryView(workoutIndex: workout.id), isActive: $showSummaryView) {
//                        usiamo una emptyView, una View di base vuota, dato che non possiamo lasciare le parentesi graffe vuote
                        EmptyView()
                    }
//                    in maniera analoga al precedente, attiviamo la NavigationLink che apre la PlayVew, passando come parametro sempre l'id del workout, e l'inizializzazione della matrice dei pesi nuovi, con 9 colonne (numero massimo di serie selezionabile durante la creazione di un Workout), e un numero di righe pari al numero di esercizi presente nell'allenamento
                    NavigationLink(destination: PlayView(workoutIndex: workout.id, newWeight: Array<Array<Int>>(repeating: Array<Int>(repeating: 0, count: 9), count: workout.exercises.count)), isActive: $showPlayView) {
                        EmptyView()
                    }
//                    Con questo bottone andiamo a far partire il countdown che aprirà la PlayView
                    Button(action: startCountdown) {
                        HStack{
//                            Notiamo come, a differenza delle situazioni precedenti, il simbolo di "play" di sistema, è presente su WatchOS
                            Image(systemName: "play")
                            Text("Start Workout")
                        }
                        .foregroundColor(.black)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.accentColor)
                }
                Spacer()
                    .frame(height: 10)
//                intestazione sezione esercizi
                Text("Exercises")
                    .font(.footnote)
                    .foregroundColor(.secondary)
//                andando ad impostare una largezza infinita con allineamento a sinistra, ci andiamo a rendere indipendente dalla dimensione dello schermo
                    .frame(maxWidth: .infinity, alignment: .leading)
//                per ogni esercizio dell'allenamento, mostriamo un NavigationLink contenente il solo nome dell'esercizio (con massimo una riga), che apre alla pagina del singolo esercizio
                ForEach(workout.exercises){exercise in
                    NavigationLink(destination: SingleExerciseView(workoutIndex: workout.id,exercise: exercise), label: {
                        Text(exercise.exercisestat.exercisenamestatic).lineLimit(1)
                    })
                }
                Spacer()
                    .frame(height: 20)
//                con questo bottone in forndo alla pagina è possibile eliminare l'allenamento, agigornando il DataManager
                Button(action: {
                    workoutStore.deleteWorkout(workoutId: workout.id)
                    DataManager.shared.saveWorkouts(workoutStore.workouts)
                    dismiss()
                }) {
                    HStack{
                        Image(systemName: "trash")
                        Text("Delete Workout")
                    }
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
//            quando la View appare, controlliamo se la showSummary del workoutStore è attiva, cioè se siamo entraty in questa viee dopo la fine dell'allenamentp, se si la rimettiamo a false, e apriamo la SummaryView con l'apposito toggle.
            .onAppear(perform: {
                if workoutStore.showSummary {
                    workoutStore.showSummary = false
                    self.showSummaryView.toggle()
                }
            })
            .navigationTitle(workout.workoutname)
        }
    }
    
//    funzione che controlla a quanto è arrivato il countdown, e nel caso bisogna ancora contare lo decrementa di 1 (causando il ricalcolo della view in cui viene mostrato il suo valore) causando una lieve vibrazione. In caso contrario ferma il countdown, causa una forte vibrazione e attiva il booleano legato all'apparizione della PlayView.
    func countdownCheck() {
        if countdownSeconds > 0 {
            countdownSeconds -= 1
//            per far vibrare il dispositivo ci serviamo della classe WKInterfaceDevice, una classe di WatchKit che rappresenta il dispositivo Apple Watch. Il metodo current() restituisce l'istanza di WKInterfaceDevice associata al dispositivo corrente. Il metodo play() è un metodo di WKInterfaceDevice che riproduce una vibrazione haptic in base al tipo di haptic specificato, che in questo caso viene preso dal tipo enumerato WKHHapticType. In particolare usiamo la vibrazione .success che è una vibrazione leggera.
            WKInterfaceDevice.current().play(WKHapticType.success)
        } else {
            isCountdownRunning = false
//            per la vibrazione finale usiamo .retry, più forte rispetto a .success
            WKInterfaceDevice.current().play(WKHapticType.retry)
            self.showPlayView.toggle()
        }
    }
    
//    questa funzione viene utilizzata per far partire il countdown, che semplicemente riimposta il tempo al valore impostato nell'apposita variabile, e cambia il valore del binding che causa il ricalcolo della View per mostrare proprio il countdown.
    func startCountdown() {
        countdownSeconds = startingCountdownSeconds
        isCountdownRunning = true
    }
}

struct SingleWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        let exercisestatic = ExerciseStatic(exercisenamestatic: "Incline Bench Press", description: "Lie face up on a flat bench, and grip a barbell with the hands slightly wider than shoulder-width. Press the feet into the ground and the hips into the bench while lifting the bar off the rack. Slowly lower the bar to the chest by allowing the elbows to bend out to the side. Stop when the elbows are just below the bench, and press feet into the floor to press the weight straight up to return to the starting position.", bodypart: Bodyparts.chest, image: ["PI01", "PI02", "PI03", "PI04", "PI05", "PI06", "PI07", "PI08", "PI09", "PI10", "PI11", "PI12", "PI13", "PI14", "PI15", "PI16", "PI17", "PI18", "PI19", "PI20", "PI21", "PI22", "PI23", "PI24", "PI25", "PI26", "PI27", "PI28", "PI29", "PI30", "PI31", "PI32", "PI33", "PI34", "PI35", "PI36", "PI37", "PI38", "PI39", "PI40", "PI41", "PI42", "PI43", "PI44", "PI45", "PI46", "PI47", "PI48", "PI49", "PI50", "PI51", "PI52", "PI53", "PI54", "PI55", "PI56", "PI57", "PI58", "PI59", "PI60"])
        let arrayExercise = [Exercise(exercisestat: exercisestatic), Exercise(exercisestat: exercisestatic)]
        SingleWorkoutView(workout: Workout(id: 1,workoutname: "Nome workout", exercises: arrayExercise))
    }
}
