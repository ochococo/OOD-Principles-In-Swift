/*:
# 🔐 The Single Responsibility Principle

A class should have one, and only one, reason to change.

Example:
*/

protocol CanBeOpened {
    func open()
}

protocol CanBeClosed {
    func close()
}

// I'm the door. I have an encapsulated state and you can change it using methods.
class Door : CanBeOpened,CanBeClosed {
    private var stateOpen = false

    func open() {
        stateOpen = true
    }

    func close() {
        stateOpen = false
    }
}

// I'm only responsible for opening, no idea what's inside or how to close.
class DoorOpener {
    let door:CanBeOpened

    init(door: CanBeOpened) {
        self.door = door
    }

    func execute() {
        door.open()
    }
}

// I'm only responsible for closing, no idea what's inside or how to open.
class DoorCloser {
    let door:CanBeClosed

    init(door: CanBeClosed) {
        self.door = door
    }

    func execute() {
        door.close()
    }
}

let door = Door()
let doorOpener = DoorOpener(door: door)
let doorCloser = DoorCloser(door: door)
doorOpener.execute()
doorCloser.execute()
