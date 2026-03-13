/*:
# 🔐 The Single Responsibility Principle (Prinzip der einzigen Verantwortung)

Eine Klasse sollte einen, und nur einen, Grund zur Änderung haben.

Eine präzisere Formulierung: Ein Modul sollte gegenüber einem, und nur einem,
Akteur (Stakeholder) verantwortlich sein. Das SRP bedeutet nicht „mach nur eine
Sache" — es geht darum, Dinge zusammenzufassen, die sich aus denselben Gründen
ändern, und Dinge zu trennen, die sich aus unterschiedlichen Gründen ändern. Wenn
eine Klasse mehreren Akteuren dient, können Änderungen, die von einem Akteur
angefordert werden, die Erwartungen eines anderen verletzen.

Beispiel:
*/

protocol Openable {
    mutating func open()
}

protocol Closeable {
    mutating func close()
}

// Ich bin eine Tür. Ich habe einen gekapselten Zustand, der über Methoden geändert werden kann.
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

// Ich bin nur für das Öffnen zuständig, ich weiß nicht was drin ist oder wie man schließt.
final class DoorOpener {
    private var door: Openable

    init(door: Openable) {
        self.door = door
    }

    func execute() {
        door.open()
    }
}

// Ich bin nur für das Schließen zuständig, ich weiß nicht was drin ist oder wie man öffnet.
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


// ⚠️ Nur der `DoorOpener` ist für das Öffnen der Tür verantwortlich.
let doorOpener = DoorOpener(door: door)
doorOpener.execute()

// ⚠️ Wenn beim Schließen der Tür eine zusätzliche Operation ausgeführt werden soll,
// z. B. das Einschalten des Alarms, muss die Klasse `DoorOpener` nicht geändert werden.
let doorCloser = DoorCloser(door: door)
doorCloser.execute()
