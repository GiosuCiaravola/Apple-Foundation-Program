//
//  DataModel.swift
//  GymZone Watch App
//
//  Created by Giosuè Ciaravola on 20/04/23.
//

//  File che contiene tutte le classi e le strutture dati principali su cui si basa l'applicazione.

import Foundation

//  ci è utile creare questo tipo enumerato per le parti del corpo, aggiungendo anche un Raw Values di tipo String per le stampe
enum Bodyparts: String, Codable {
    case chest = "Chest"
    case biceps = "Biceps"
    case legs = "Legs"
    case shoulders = "Shoulders"
    case triceps = "Triceps"
    case back = "Back"
}

//  struttura che rappresenta una serie di un eserizio, questa è caratterizzata da un id, in modo che sia possibile usarla in un ForEach, un Int che indica il numero di ripetizioni, e un altro Int che indica il peso usato in quella serie. Non assegniamo direttamente l'id in quanto ci serve assegnarlo in maniera strategica successivamente, per farlo coincidere all'indice di quel determinato set nell'array che lo contiene in un esercizio.
struct WorkoutSet: Identifiable, Codable {
    var id: Int
    var reps: Int
    var weight: Int
}

//  struttura che rappresenta un esercizio statico, cioè quelli presenti di base sull'app. Anche questi sono caratterizzati da un id, che stavolta però viene assegnato in automatico dato che non ci interessa quale esso sia, ma solo che possiamo ciclare su di esso; un nome, una descrizione, la parte del corpo che allena, e un arrau di nome dei frame dell'animazione che lo rappresenta (usata nella GifView)
struct ExerciseStatic: Identifiable, Codable {
    var id = UUID()
    var exercisenamestatic: String
    var description: String
    var bodypart: Bodyparts
    var image: [String]
}

//  struttura che rappresenta un eserzio applicato ad una scheda. Esso è caratterizzato da un id che verrà assegnato in maniera strategica (come nel WorkoutSet), l'esercizio statico che caratterizza, le serie che verrano eseguite in quell'esercizio, e il numero di minuti e secondi del tempo di recupero per quell'esercizio.
struct Exercise: Identifiable, Codable {
    var id: Int
    var exercisestat: ExerciseStatic
    var sets: [WorkoutSet]
    var min: Int
    var sec: Int
  
//      costruttore che inizializza momentaneamente tutto a 0, tranne l'esercizio statico di riferimento che viene impostato a quello passato come parametro.
    init(exercisestat: ExerciseStatic) {
        self.id = 0
        self.exercisestat = exercisestat
        self.sets = [WorkoutSet(id: 0,reps: 0, weight: 0)]
        self.min = 0
        self.sec = 0
    }
}

//  struttura che rappresenta un allenamento, cioè un contenitore di esercizi. Esso contiene un'id che ancora una volta sarà unsato in maniera stategica (come nel WorkoutSet), l'effettivo array di esercizi, e la data di creazione dell'allenamento.
struct Workout: Identifiable, Codable {
    var id: Int
    var workoutname: String
    var exercises: [Exercise]
    
//    funzione che elimina un esercizio basandosi sul suo id passato come parametro, che coincide col suo indice nell'array. Dopo aver fatto ciò vengono aggiornati gli id degli esercizi sucessivi (li decrementiamo).
    mutating func deleteExercise(exerciseId: Int) {
        self.exercises.remove(at: exerciseId)
        for i in exerciseId..<self.exercises.count {
            self.exercises[i].id = i
        }
    }
}

//  struttra principale dell'applicazione, che contiene tutte le informazioni principali. Tra tutte l'array di allenamenti, e poi varie informazioni che vengono passate tra le view per costruire il Summary di fine allenamento.
class WorkoutsStore: ObservableObject {
    @Published var lastWorkoutCalories: String
    @Published var lastWorkoutAvarageHeartRate: String
    @Published var lastWorkoutRangeHeartRate: String
    @Published var lastWorkoutChrono: String 
    @Published var showSummary = false
    @Published var workouts: [Workout] = []
    
//    inizializzazione della struttura, usata all'apertura dell'app, che carica gli allenamento dalla memoria, in fornmato JSON, salvati con il meccanismo di UserDefault. Gli altri parametri vengono lasciati vuoti in quanto ci servono quando vengono eseguiti gli allenamenti.
    init() {
        workouts = DataManager.shared.loadWorkouts();
        lastWorkoutCalories = "";
        lastWorkoutAvarageHeartRate = "";
        lastWorkoutRangeHeartRate = "";
        lastWorkoutChrono = "";
    }
    
//    funzione che aggiunge un workout
    func addWorkout(_ workout: Workout) {
        workouts.append(workout)
    }
    
//    funziona che elimina un allenamento dal workoutStore, con la stessa meccanica ocn cui viene eliminato un Esercizio da un allenamento.
    func deleteWorkout(workoutId: Int) {
        self.workouts.remove(at: workoutId)
        for i in workoutId..<self.workouts.count {
            self.workouts[i].id = i;
        }
    }
}

//  Struttura dati che contiene gli essercizi presenti di base nell'applicazione.
class ExerciseDB {
    @Published var exercisedb: [ExerciseStatic] = [
        ExerciseStatic(exercisenamestatic: "Alternate Dumbbell Curl", description: "Begin by standing up straight with a dumbbell in each hand, palms facing inwards towards your thighs.Keep your elbows tucked in close to your sides and exhale as you curl one dumbbell towards your shoulder, rotating your forearm so that your palm faces your shoulder at the top of the movement. Hold the contraction for a brief moment and then slowly lower the dumbbell back down to the starting position, inhaling as you go. Repeat the same movement with the opposite arm, alternating between left and right arm curls for the desired number of repetitions. As you progress through the exercise, you can choose to perform the curls in a more controlled or explosive manner, depending on your fitness goals and desired intensity.", bodypart: Bodyparts.biceps, image: ["CA001", "CA002", "CA003", "CA004", "CA005", "CA006", "CA007", "CA008", "CA009", "CA010", "CA011", "CA012", "CA013", "CA014", "CA015", "CA016", "CA017", "CA018", "CA019", "CA020", "CA021", "CA022", "CA023", "CA024", "CA025", "CA026", "CA027", "CA028", "CA029", "CA030", "CA031", "CA032", "CA033", "CA034", "CA035", "CA036", "CA037", "CA038", "CA039", "CA040", "CA041", "CA042", "CA043", "CA044", "CA045", "CA046", "CA047", "CA048", "CA049", "CA050", "CA051", "CA052", "CA053", "CA054", "CA055", "CA056", "CA057", "CA058", "CA059", "CA060", "CA061", "CA062", "CA063", "CA064", "CA065", "CA066", "CA067", "CA068", "CA069", "CA070", "CA071", "CA072", "CA073", "CA074", "CA075", "CA076", "CA077", "CA078", "CA079", "CA080", "CA081", "CA082", "CA083", "CA084", "CA085", "CA086", "CA087", "CA088", "CA089", "CA090", "CA091", "CA092", "CA093", "CA094", "CA095", "CA096", "CA097", "CA098", "CA099", "CA100", "CA101", "CA102", "CA103", "CA104", "CA105", "CA106", "CA107", "CA108", "CA109", "CA110", "CA111", "CA112", "CA113", "CA114", "CA115", "CA116", "CA117", "CA118", "CA119", "CA120"]),
        ExerciseStatic(exercisenamestatic: "Barbell Bent Over Row", description: "Grip a barbell with palms down so that the wrists, elbows, and shoulders are in a straight line. Lift the bar from the rack, bend forward at the hips, and keep the back straight with a slight bend in the knees. Lower the bar towards the floor until the elbows are completely straight, and keep the back flat as the bar is pulled towards the belly button. Then slowly lower the bar to the starting position and repeat. ", bodypart: Bodyparts.back, image: ["R01", "R02", "R03", "R04", "R05", "R06", "R07", "R08", "R09", "R10", "R11", "R12", "R13", "R14", "R15", "R16", "R17", "R18", "R19", "R20", "R21", "R22", "R23", "R24", "R25", "R26", "R27", "R28", "R29", "R30", "R31", "R32", "R33", "R34", "R35", "R36", "R37", "R38", "R39", "R40", "R41", "R42", "R43", "R44", "R45", "R46", "R47", "R48", "R49", "R50", "R51", "R52", "R53", "R54", "R55", "R56", "R57", "R58", "R59", "R60"]),
        ExerciseStatic(exercisenamestatic: "Barbell French Press", description: "Begin by lying on a flat bench with your feet flat on the floor and your head positioned at the end of the bench. Grasp a barbell with an overhand grip, hands positioned slightly closer than shoulder-width apart. Hold the barbell with your arms extended straight up above your chest, keeping your elbows locked. Inhale and slowly lower the barbell towards your forehead by bending your elbows, keeping your upper arms stationary. Pause briefly at the bottom of the movement, then exhale as you press the barbell back up to the starting position, extending your arms straight up again. Repeat the movement for the desired number of repetitions, focusing on keeping your elbows stationary and avoiding any movement in your shoulders.", bodypart: Bodyparts.triceps, image: ["FP01", "FP02", "FP03", "FP04", "FP05", "FP06", "FP07", "FP08", "FP09", "FP10", "FP11", "FP12", "FP13", "FP14", "FP15", "FP16", "FP17", "FP18", "FP19", "FP20", "FP21", "FP22", "FP23", "FP24", "FP25", "FP26", "FP27", "FP28", "FP29", "FP30", "FP31", "FP32", "FP33", "FP34", "FP35", "FP36", "FP37", "FP38", "FP39", "FP40", "FP41", "FP42", "FP43", "FP44", "FP45", "FP46", "FP47", "FP48", "FP49", "FP50", "FP51", "FP52", "FP53", "FP54", "FP55", "FP56", "FP57", "FP58", "FP59", "FP60"]),
        ExerciseStatic(exercisenamestatic: "Bench Press", description: "Lie face up on a flat bench, and grip a barbell with the hands slightly wider than shoulder-width. Press the feet into the ground and the hips into the bench while lifting the bar off the rack. Slowly lower the bar to the chest by allowing the elbows to bend out to the side. Stop when the elbows are just below the bench, and press feet into the floor to press the weight straight up to return to the starting position.", bodypart: Bodyparts.chest, image: ["PP01", "PP02", "PP03", "PP04", "PP05", "PP06", "PP07", "PP08", "PP09", "PP10", "PP11", "PP12", "PP13", "PP14", "PP15", "PP16", "PP17", "PP18", "PP19", "PP20", "PP21", "PP22", "PP23", "PP24", "PP25", "PP26", "PP27", "PP28", "PP29", "PP30", "PP31", "PP32", "PP33", "PP34", "PP35", "PP36", "PP37", "PP38", "PP39", "PP40", "PP41", "PP42", "PP43", "PP44", "PP45", "PP46", "PP47", "PP48", "PP49", "PP50", "PP51", "PP52", "PP53", "PP54", "PP55", "PP56", "PP57", "PP58", "PP59", "PP60"]),
        ExerciseStatic(exercisenamestatic: "Dumbbell Curl", description: "Begin by standing up straight with a dumbbell in each hand, palms facing inwards towards your thighs. Keep your elbows tucked in close to your sides and exhale as you curl one dumbbell towards your shoulder, rotating your forearm so that your palm faces your shoulder at the top of the movement. Hold the contraction for a brief moment and then slowly lower the dumbbell back down to the starting position, inhaling as you go.Repeat the same movement with the opposite arm, alternating between left and right arm curls for the desired number of repetitions.As you progress through the exercise, you can choose to perform the curls in a more controlled or explosive manner, depending on your fitness goals and desired intensity.", bodypart: Bodyparts.biceps, image: ["C01", "C02", "C03", "C04", "C05", "C06", "C07", "C08", "C09", "C10", "C11", "C12", "C13", "C14", "C15", "C16", "C17", "C18", "C19", "C20", "C21", "C22", "C23", "C24", "C25", "C26", "C27", "C28", "C29", "C30", "C31", "C32", "C33", "C34", "C35", "C36", "C37", "C38", "C39", "C40", "C41", "C42", "C43", "C44", "C45", "C46", "C47", "C48", "C49", "C50", "C51", "C52", "C53", "C54", "C55", "C56", "C57", "C58", "C59", "C60"]),
        ExerciseStatic(exercisenamestatic: "Dumbbell Front Raise", description: "Begin by standing up straight with a dumbbell in each hand, palms facing your thighs. Keep your arms straight and exhale as you lift one dumbbell straight out in front of you until it reaches shoulder height. Hold the contraction for a brief moment and then slowly lower the dumbbell back down to the starting position, inhaling as you go. Repeat the same movement with the opposite arm, alternating between left and right arm raises for the desired number of repetitions. As you progress through the exercise, you can choose to perform the raises in a more controlled or explosive manner, depending on your fitness goals and desired intensity.", bodypart: Bodyparts.shoulders, image: ["AF01", "AF02", "AF03", "AF04", "AF05", "AF06", "AF07", "AF08", "AF09", "AF10", "AF11", "AF12", "AF13", "AF14", "AF15", "AF16", "AF17", "AF18", "AF19", "AF20", "AF21", "AF22", "AF23", "AF24", "AF25", "AF26", "AF27", "AF28", "AF29", "AF30", "AF31", "AF32", "AF33", "AF34", "AF35", "AF36", "AF37", "AF38", "AF39", "AF40", "AF41", "AF42", "AF43", "AF44", "AF45", "AF46", "AF47", "AF48", "AF49", "AF50", "AF51", "AF52", "AF53", "AF54", "AF55", "AF56", "AF57", "AF58", "AF59", "AF60"]),
        ExerciseStatic(exercisenamestatic: "Dumbbell Overhead Triceps Exctensions", description: "Begin by standing up straight with your feet shoulder-width apart and holding a dumbbell in both hands with both palms facing up. Raise the dumbbell above your head and keep your elbows close to your ears. Your upper arms should be vertical and perpendicular to the floor, and the dumbbell should be positioned behind your head with your forearms pointing up. Inhale and slowly lower the dumbbell behind your head, keeping your upper arms stationary. Pause briefly at the bottom of the movement, then exhale as you contract your triceps and lift the dumbbell back up to the starting position. Repeat the movement for the desired number of repetitions, making sure to keep your core engaged and avoiding any movement in your shoulders.", bodypart: Bodyparts.triceps, image: ["TC01", "TC02", "TC03", "TC04", "TC05", "TC06", "TC07", "TC08", "TC09", "TC10", "TC11", "TC12", "TC13", "TC14", "TC15", "TC16", "TC17", "TC18", "TC19", "TC20", "TC21", "TC22", "TC23", "TC24", "TC25", "TC26", "TC27", "TC28", "TC29", "TC30", "TC31", "TC32", "TC33", "TC34", "TC35", "TC36", "TC37", "TC38", "TC39", "TC40", "TC41", "TC42", "TC43", "TC44", "TC45", "TC46", "TC47", "TC48", "TC49", "TC50", "TC51", "TC52", "TC53", "TC54", "TC55", "TC56", "TC57", "TC58", "TC59", "TC60"]),
        ExerciseStatic(exercisenamestatic: "Incline Bench Press", description: "Lie face up on a flat bench, and grip a barbell with the hands slightly wider than shoulder-width. Press the feet into the ground and the hips into the bench while lifting the bar off the rack. Slowly lower the bar to the chest by allowing the elbows to bend out to the side. Stop when the elbows are just below the bench, and press feet into the floor to press the weight straight up to return to the starting position.", bodypart: Bodyparts.chest, image: ["PI01", "PI02", "PI03", "PI04", "PI05", "PI06", "PI07", "PI08", "PI09", "PI10", "PI11", "PI12", "PI13", "PI14", "PI15", "PI16", "PI17", "PI18", "PI19", "PI20", "PI21", "PI22", "PI23", "PI24", "PI25", "PI26", "PI27", "PI28", "PI29", "PI30", "PI31", "PI32", "PI33", "PI34", "PI35", "PI36", "PI37", "PI38", "PI39", "PI40", "PI41", "PI42", "PI43", "PI44", "PI45", "PI46", "PI47", "PI48", "PI49", "PI50", "PI51", "PI52", "PI53", "PI54", "PI55", "PI56", "PI57", "PI58", "PI59", "PI60"])
    ]
}
