/*:
# 🔐 The Single Responsibility Principle (단일 책임 원칙)

클래스에는 단 한 가지 변경 이유만 존재해야 한다.

보다 정제된 정의: 모듈은 하나의, 오직 하나의 액터(이해관계자)에 대해서만
책임져야 한다. SRP는 "한 가지 일만 하라"는 것이 아니라, 같은 이유로 변경되는
것들을 모으고 다른 이유로 변경되는 것들을 분리하는 것이다. 하나의 클래스가
여러 액터를 담당하면, 한 액터가 요청한 변경이 다른 액터의 기대를 깨뜨릴 수 있다.

예시:
*/

protocol Openable {
    mutating func open()
}

protocol Closeable {
    mutating func close()
}

// 문. 캡슐화된 상태를 갖고 있으며 메서드를 사용해 변경할 수 있다.
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

// 여는 일만 담당하며 안에 무엇이 들어있는 지, 어떻게 닫는 지 모른다.
final class DoorOpener {
    private var door: Openable

    init(door: Openable) {
        self.door = door
    }

    func execute() {
        door.open()
    }
}

// 닫는 일만 담당하며 안에 무엇이 들어있는 지, 어떻게 여는 지 모른다.
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

// ⚠️ `DoorOpeneer`만이 문을 여는 책임이 있다.
let doorOpener = DoorOpener(door: door)
doorOpener.execute()

// ⚠️ 문을 닫은 후 다른 작업을 해야 하는 경우,
// 알람을 켜는 것처럼 `DoorOpener` 클래스를 변경할 필요가 없다.
let doorCloser = DoorCloser(door: door)
doorCloser.execute()

