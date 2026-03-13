/*:
# 🔐 The Single Responsibility Principle (単一責任の原則)

クラスが変更される理由は、一つだけであるべきです。

より正確な定義：モジュールは一つの、そしてただ一つのアクター（利害関係者）に
対して責任を負うべきです。SRPは「一つのことだけを行う」ということではなく、
同じ理由で変更されるものをまとめ、異なる理由で変更されるものを分離することです。
クラスが複数のアクターに仕えると、あるアクターが要求した変更が別のアクターの
期待を壊す可能性があります。

例：
*/

protocol Openable {
    mutating func open()
}

protocol Closeable {
    mutating func close()
}

// 私はドアです。カプセル化された状態を持ち、メソッドで変更できます。
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

// 私は開けることだけを担当し、中身や閉め方は知りません。
final class DoorOpener {
    private var door: Openable

    init(door: Openable) {
        self.door = door
    }

    func execute() {
        door.open()
    }
}

// 私は閉めることだけを担当し、中身や開け方は知りません。
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


// ⚠️ ドアを開ける責任を持つのは `DoorOpener` だけです。
let doorOpener = DoorOpener(door: door)
doorOpener.execute()

// ⚠️ ドアを閉める際にアラームを鳴らすなどの追加操作が必要でも、
// `DoorOpener` クラスを変更する必要はありません。
let doorCloser = DoorCloser(door: door)
doorCloser.execute()
