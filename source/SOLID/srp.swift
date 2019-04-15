/*:
# 🔐 The Single Responsibility Principle

A class should have one, and only one, reason to change. ([read more](https://docs.google.com/open?id=0ByOwmqah_nuGNHEtcU5OekdDMkk))

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

/*: 
> ⚠ Only the `DoorOpener` is responsible for opening the door.
*/

let doorOpener = DoorOpener(door: door)
doorOpener.execute()

/*: 
> ⚠ If another operation should be made upon closing the door,
> like switching on the alarm, you don't have to change the `DoorOpener` class.
*/

let doorCloser = DoorCloser(door: door)
doorCloser.execute()

