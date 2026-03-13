/*:
# 🔐 The Single Responsibility Principle (单一职责原则)

一个类应该有且只有一个变更的理由。

更精确的定义：一个模块应该对且仅对一个参与者（利益相关者）负责。SRP 并不是说
"只做一件事"——而是将因相同原因而变化的事物归为一组，将因不同原因而变化的事物
分开。当一个类服务于多个参与者时，一个参与者请求的变更可能会破坏另一个参与者的
预期。

示例：
*/

protocol Openable {
    mutating func open()
}

protocol Closeable {
    mutating func close()
}

// 我是一扇门。我有封装的状态，你可以通过方法来改变它。
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

// 我只负责开门，不知道里面是什么，也不知道如何关门。
final class DoorOpener {
    private var door: Openable

    init(door: Openable) {
        self.door = door
    }

    func execute() {
        door.open()
    }
}

// 我只负责关门，不知道里面是什么，也不知道如何开门。
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


// ⚠️ 只有 `DoorOpener` 负责开门。
let doorOpener = DoorOpener(door: door)
doorOpener.execute()

// ⚠️ 如果关门时需要执行额外操作，
// 比如打开警报，你不需要修改 `DoorOpener` 类。
let doorCloser = DoorCloser(door: door)
doorCloser.execute()
