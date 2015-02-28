```swift
import Swift
import Foundation
```

The Principles of OOD implemented in Swift 1.2
==============================================
A short cheat-sheet with Xcode 6.3 Playground ([OOD-Principles-In-Swift.playground.zip](https://raw.githubusercontent.com/ochococo/OOD-Principles-In-Swift/master/OOD-Principles-In-Swift.playground.zip)).

👷 Project maintained by: [@nsmeme](http://twitter.com/nsmeme) (Oktawian Chojnacki)

## SOLID

* [The Single Responsibility Principle](#the-single-responsibility-principle)
* [The Open Closed Principle](#the-open-closed-principle)
* [The Liskov Substitution Principle](#the-liskov-substitution-principle)
* [The Interface Segregation Principle](#the-interface-segregation-principle)
* [The Dependency Inversion Principle](#the-dependency-inversion-principle)


#The Single Responsibility Principle

>	A class should have one, and only one, reason to change.

Example:

```swift
protocol CanBeOpened {
    func open()
}

protocol CanBeClosed {
    func close()
}

// I'm the door. I have an encapsulated state.
class Door:CanBeOpened,CanBeClosed {
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

    init(door:CanBeOpened) {
        self.door = door
    }

    func execute() {
        door.open()
    }
}

// I'm only responsible for closing, no idea what's inside or how to open.
class DoorCloser {
    let door:CanBeClosed

    init(door:CanBeClosed) {
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
```

#The Open Closed Principle

>	You should be able to extend a classes behavior, without modifying it.

#The Liskov Substitution Principle

>	Derived classes must be substitutable for their base classes.

#The Interface Segregation Principle

>	Make fine grained interfaces that are client specific.

#The Dependency Inversion Principle

>	Depend on abstractions, not on concretions.


Info
====

🍺 Playground generated with: [playground](https://github.com/jas/playground) by [@jasonsandmeyer](http://twitter.com/jasonsandmeyer)

📖 Descriptions from: [Uncle Bob](http://butunclebob.com/ArticleS.UncleBob.PrinciplesOfOod)

🚀 How to generate playground (+zip) from this README: [GENERATE.md](https://github.com/ochococo/Design-Patterns-In-Swift/blob/master/GENERATE.md)