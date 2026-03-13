/*:
# 🔐 The Single Responsibility Principle (Principio de responsabilidad única)

Una clase debe tener una, y solo una, razón para cambiar.

Una formulación más precisa: un módulo debe ser responsable ante uno, y solo
uno, actor (interesado). El SRP no se trata de "hacer una sola cosa" — se
trata de agrupar las cosas que cambian por las mismas razones y separar las
que cambian por razones diferentes. Cuando una clase sirve a múltiples actores,
los cambios solicitados por un actor pueden romper las expectativas de otro.

Ejemplo:
*/

protocol Openable {
    mutating func open()
}

protocol Closeable {
    mutating func close()
}

// Soy una puerta. Tengo un estado encapsulado que se puede cambiar mediante métodos.
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

// Solo soy responsable de abrir, no sé qué hay dentro ni cómo cerrar.
final class DoorOpener {
    private var door: Openable

    init(door: Openable) {
        self.door = door
    }

    func execute() {
        door.open()
    }
}

// Solo soy responsable de cerrar, no sé qué hay dentro ni cómo abrir.
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


// ⚠️ Solo `DoorOpener` es responsable de abrir la puerta.
let doorOpener = DoorOpener(door: door)
doorOpener.execute()

// ⚠️ Si al cerrar la puerta se debe realizar una operación adicional,
// como activar la alarma, no es necesario cambiar la clase `DoorOpener`.
let doorCloser = DoorCloser(door: door)
doorCloser.execute()
