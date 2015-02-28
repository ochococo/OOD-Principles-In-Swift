```swift
import Swift
import Foundation
```

The Principles of OOD implemented in Swift
==========================================
A short cheat-sheet with Xcode 6 Playground ([OOD-Principles-In-Swift.playground.zip]()).

👷 Project maintained by: [@nsmeme](http://twitter.com/nsmeme) (Oktawian Chojnacki)

## SOLID

* [The Single Responsibility Principle](#the-single-responsibility-principle)
* [The Open Closed Principle](#the-open-closed-principle)
* [The Liskov Substitution Principle](#the-liskov-substitution-principle)
* [The Interface Segregation Principle](#the-interface-segregation-principle)
* [The Dependency Inversion Principle](#the-dependency-inversion-principle)


#The Single Responsibility Principle

>	A class should have one, and only one, reason to change.
>**Source:** [butunclebob.com](http://butunclebob.com/ArticleS.UncleBob.PrinciplesOfOod)

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
>**Source:** [butunclebob.com](http://butunclebob.com/ArticleS.UncleBob.PrinciplesOfOod)

#The Liskov Substitution Principle

>	Derived classes must be substitutable for their base classes.
>**Source:** [butunclebob.com](http://butunclebob.com/ArticleS.UncleBob.PrinciplesOfOod)

#The Interface Segregation Principle

>	Make fine grained interfaces that are client specific.
>**Source:** [butunclebob.com](http://butunclebob.com/ArticleS.UncleBob.PrinciplesOfOod)

#The Dependency Inversion Principle

>	Depend on abstractions, not on concretions.
>**Source:** [butunclebob.com](http://butunclebob.com/ArticleS.UncleBob.PrinciplesOfOod)
