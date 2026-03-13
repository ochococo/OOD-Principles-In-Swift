/*:
# 🔐 The Single Responsibility Principle (Принцип єдиної відповідальності)

Клас повинен мати одну, і тільки одну, причину для зміни.

Точніше формулювання: модуль повинен відповідати перед одним, і тільки одним,
актором (зацікавленою стороною). SRP — це не про «робити одну річ», а про
групування разом того, що змінюється з однакових причин, і відокремлення того,
що змінюється з різних причин. Коли клас обслуговує кількох акторів, зміни,
запитані одним актором, можуть порушити очікування іншого.

Приклад:
*/

protocol Openable {
    mutating func open()
}

protocol Closeable {
    mutating func close()
}

// Я — двері. Маю інкапсульований стан, який можна змінити за допомогою методів.
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

// Я відповідаю лише за відкривання, не знаю що всередині і як закривати.
final class DoorOpener {
    private var door: Openable

    init(door: Openable) {
        self.door = door
    }

    func execute() {
        door.open()
    }
}

// Я відповідаю лише за закривання, не знаю що всередині і як відкривати.
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


// ⚠️ Тільки `DoorOpener` відповідає за відкривання дверей.
let doorOpener = DoorOpener(door: door)
doorOpener.execute()

// ⚠️ Якщо при закриванні дверей потрібно виконати додаткову операцію,
// наприклад, увімкнути сигналізацію, не потрібно змінювати клас `DoorOpener`.
let doorCloser = DoorCloser(door: door)
doorCloser.execute()
