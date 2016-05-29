/*:
# 🔐 The Single Responsibility Principle

A class should have one, and only one, reason to change.

Example:
*/

// I'm the door. I have an encapsulated state and you can change it.
final class PodBayDoor {

    enum State {
        case Open
        case Closed
    }

    var state: State = .Closed
}

// I'm only responsible for opening, no idea what's inside or how to close.
final class DoorOpener {
    let door: PodBayDoor

    init(door: PodBayDoor) {
        self.door = door
    }

    func execute() {
        door.state = .Open
    }
}

// I'm only responsible for closing, no idea what's inside or how to open.
final class DoorCloser {
    let door: PodBayDoor

    init(door: PodBayDoor) {
        self.door = door
    }

    func execute() {
        door.state = .Closed
    }
}

let door = PodBayDoor()

// NOTE: Only the `DoorOpener` is responsible for opening the door.
let doorOpener = DoorOpener(door: door)

// NOTE: If another operation should be made upon closing the door,
//       like switching on the alarm, you don't have to change the `DoorOpener` class.
let doorCloser = DoorCloser(door: door)

doorOpener.execute()
doorCloser.execute()
