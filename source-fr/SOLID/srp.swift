/*:
# 🔐 The Single Responsibility Principle (Principe de responsabilite unique)

Une classe ne devrait avoir qu'une seule raison de changer.

Formulation plus precise : un module ne devrait etre responsable que devant un
seul acteur (partie prenante). Le SRP ne signifie pas « faire une seule chose »
— il s'agit de regrouper ce qui change pour les memes raisons et de separer ce
qui change pour des raisons differentes. Quand une classe sert plusieurs acteurs,
les modifications demandees par un acteur risquent de compromettre les attentes
d'un autre.

Exemple :
*/

protocol Openable {
    mutating func open()
}

protocol Closeable {
    mutating func close()
}

// Je suis la porte. J'ai un etat encapsule que vous pouvez modifier via des methodes.
struct PodBayDoor: Openable, Closeable {

    private enum State {
        case open
        case closed
    }

    private var state: State = .closed

    mutating func open() {
        state = .open
    }

    mutating func close() {
        state = .closed
    }
}

// Je suis uniquement responsable de l'ouverture, je ne sais pas ce qu'il y a a l'interieur ni comment fermer.
final class DoorOpener {
    private var door: Openable

    init(door: Openable) {
        self.door = door
    }

    func execute() {
        door.open()
    }
}

// Je suis uniquement responsable de la fermeture, je ne sais pas ce qu'il y a a l'interieur ni comment ouvrir.
final class DoorCloser {
    private var door: Closeable

    init(door: Closeable) {
        self.door = door
    }

    func execute() {
        door.close()
    }
}

let door = PodBayDoor()


// ⚠️ Seul `DoorOpener` est responsable de l'ouverture de la porte.
let doorOpener = DoorOpener(door: door)
doorOpener.execute()

// ⚠️ Si une autre operation doit etre effectuee lors de la fermeture de la porte,
// comme activer l'alarme, il n'est pas necessaire de modifier la classe `DoorOpener`.
let doorCloser = DoorCloser(door: door)
doorCloser.execute()
