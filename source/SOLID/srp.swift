/*:
# 🔐 The Single Responsibility Principle

A class should have one, and only one, reason to change.

A refined formulation: a module should be responsible to one, and only one,
actor (stakeholder). SRP is not about "doing one thing" — it is about gathering
together the things that change for the same reasons and separating those that
change for different reasons. When a class serves multiple actors, changes
requested by one actor risk breaking the expectations of another.

Example:
*/

protocol Openable {
    mutating func open()
}

protocol Closeable {
    mutating func close()
}

// I'm the door. I have an encapsulated state and you can change it using methods.
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

// I'm only responsible for opening, no idea what's inside or how to close.
final class DoorOpener {
    private var door: Openable

    init(door: Openable) {
        self.door = door
    }

    func execute() {
        door.open()
    }
}

// I'm only responsible for closing, no idea what's inside or how to open.
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

 
// ⚠️ Only the `DoorOpener` is responsible for opening the door.
let doorOpener = DoorOpener(door: door)
doorOpener.execute()

// ⚠️ If another operation should be made upon closing the door,
// like switching on the alarm, you don't have to change the `DoorOpener` class.
let doorCloser = DoorCloser(door: door)
doorCloser.execute()

