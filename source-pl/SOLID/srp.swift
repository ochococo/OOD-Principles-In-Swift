/*:
# 🔐 The Single Responsibility Principle (Zasada jednej odpowiedzialności)

Klasa powinna mieć jeden, i tylko jeden, powód do zmiany.

Bardziej precyzyjna definicja: moduł powinien odpowiadać przed jednym, i tylko
jednym, aktorem (interesariuszem). SRP nie oznacza „rób jedną rzecz" — chodzi
o grupowanie razem tego, co zmienia się z tych samych powodów, i oddzielanie
tego, co zmienia się z różnych powodów. Gdy klasa obsługuje wielu aktorów,
zmiany żądane przez jednego aktora mogą naruszyć oczekiwania innego.

Przykład:
*/

protocol Openable {
    mutating func open()
}

protocol Closeable {
    mutating func close()
}

// Jestem drzwiami. Mam hermetyzowany stan, który można zmienić za pomocą metod.
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

// Odpowiadam tylko za otwieranie, nie wiem co jest w środku ani jak zamykać.
final class DoorOpener {
    private var door: Openable

    init(door: Openable) {
        self.door = door
    }

    func execute() {
        door.open()
    }
}

// Odpowiadam tylko za zamykanie, nie wiem co jest w środku ani jak otwierać.
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


// ⚠️ Tylko `DoorOpener` jest odpowiedzialny za otwieranie drzwi.
let doorOpener = DoorOpener(door: door)
doorOpener.execute()

// ⚠️ Jeśli przy zamykaniu drzwi trzeba wykonać dodatkową operację,
// np. włączyć alarm, nie trzeba zmieniać klasy `DoorOpener`.
let doorCloser = DoorCloser(door: door)
doorCloser.execute()

