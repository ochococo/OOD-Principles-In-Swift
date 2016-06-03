/*:
# 🔐 The Single Responsibility Principle

A class should have one, and only one, reason to change. ([read more](https://docs.google.com/open?id=0ByOwmqah_nuGNHEtcU5OekdDMkk))

Example:
*/

protocol CanBeOpened {
    func open()
}

protocol CanBeClosed {
    func close()
}

// I'm the door. I have an encapsulated state and you can change it using methods.
final class PodBayDoor: CanBeOpened, CanBeClosed {

    private enum State {
        case Open
        case Closed
    }

    private var state: State = .Closed

    func open() {
        state = .Open
    }

    func close() {
        state = .Closed
    }
}

// I'm only responsible for opening, no idea what's inside or how to close.
class DoorOpener {
    let door: CanBeOpened

    init(door: CanBeOpened) {
        self.door = door
    }

    func execute() {
        door.open()
    }
}

// I'm only responsible for closing, no idea what's inside or how to open.
class DoorCloser {
    let door: CanBeClosed

    init(door: CanBeClosed) {
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

