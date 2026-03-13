/*:
Swift 5 中的面向对象设计原则
=========================

A short cheat-sheet with Playground ([OOD-Principles-In-Swift-zh-CN.playground.zip](https://raw.githubusercontent.com/ochococo/OOD-Principles-In-Swift/master/OOD-Principles-In-Swift-zh-CN.playground.zip)).

👷 Project maintained by: [@oktawian](https://bsky.app/profile/oktawian.bsky.social) (Oktawian Chojnacki)

S.O.L.I.D.
==========

* [The Single Responsibility Principle (单一职责原则)](#-the-single-responsibility-principle-单一职责原则)
* [The Open Closed Principle (开闭原则)](#-the-open-closed-principle-开闭原则)
* [The Liskov Substitution Principle (里氏替换原则)](#-the-liskov-substitution-principle-里氏替换原则)
* [The Interface Segregation Principle (接口隔离原则)](#-the-interface-segregation-principle-接口隔离原则)
* [The Dependency Inversion Principle (依赖倒置原则)](#-the-dependency-inversion-principle-依赖倒置原则)

*/

import Foundation

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
/*:
# ✋ The Open Closed Principle (开闭原则)

应该能够扩展类的行为，而无需修改它。

软件实体（类、模块、函数）应该对扩展开放，但对修改关闭。关键的洞察是，当单一
变更在依赖模块中级联传播时，设计是脆弱的。通过依赖抽象（协议），可以通过编写
新代码来添加新行为——而不是修改现有的、可正常工作的代码。

示例：
 */

protocol Shooting {
    func shoot() -> String
}

// 我是一束激光。我可以射击。
final class LaserBeam: Shooting {
    func shoot() -> String {
        return "Ziiiiiip!"
    }
}

// 我拥有武器，相信我，我可以同时发射所有武器。轰！轰！轰！
final class WeaponsComposite {

    let weapons: [Shooting]

    init(weapons: [Shooting]) {
        self.weapons = weapons
    }

    func shoot() -> [String] {
        return weapons.map { $0.shoot() }
    }
}

let laser = LaserBeam()
var weapons = WeaponsComposite(weapons: [laser])

weapons.shoot()

// 我是一个火箭发射器。我可以发射火箭。
// ⚠️ 要添加火箭发射器的支持，我不需要修改现有类中的任何内容。
final class RocketLauncher: Shooting {
    func shoot() -> String {
        return "Whoosh!"
    }
}

let rocket = RocketLauncher()

weapons = WeaponsComposite(weapons: [laser, rocket])
weapons.shoot()
/*:
# 👥 The Liskov Substitution Principle (里氏替换原则)

派生类必须能够替换其基类。

子类型必须遵守其超类型的行为契约：不能加强前置条件、不能削弱后置条件、不能
违反不变量。使用基类型的调用者必须能够使用任何子类型而不自知，程序仍应正确
运行。违反此原则会导致脆弱的继承层次，客户端代码中会出现 `if/else` 类型检查。

示例：
*/

let requestKey: String = "NSURLRequestKey"

// 我是 NSError 的子类。我提供额外的功能，但不破坏原有的功能。
class RequestError: NSError {

    var request: NSURLRequest? {
        return self.userInfo[requestKey] as? NSURLRequest
    }
}

// 我无法获取数据，将返回 RequestError。
func fetchData(request: NSURLRequest) -> (data: NSData?, error: RequestError?) {

    let userInfo: [String:Any] = [requestKey : request]

    return (nil, RequestError(domain:"DOMAIN", code:0, userInfo: userInfo))
}

// 我不知道 RequestError 是什么，将失败并返回 NSError。
func willReturnObjectOrError() -> (object: AnyObject?, error: NSError?) {

    let request = NSURLRequest()
    let result = fetchData(request: request)

    return (result.data, result.error)
}

let result = willReturnObjectOrError()

// 好的。从我的角度来看，这是一个完美的 NSError 实例。
let error: Int? = result.error?.code

// ⚠️ 但等等！这是什么？它同时也是 RequestError！太棒了！
if let requestError = result.error as? RequestError {
    requestError.request
}
/*:
# 🍴 The Interface Segregation Principle (接口隔离原则)

创建针对特定客户端的细粒度接口。

任何客户端都不应该被迫依赖它不使用的方法。当接口变得过于庞大时，其客户端会与
它们从不调用的方法耦合——而对这些无关方法的更改可能迫使客户端重新编译或重新
部署。将臃肿的接口拆分为更小的、特定角色的协议，可以保持依赖关系的精简和内聚。

示例：
 */

// 我有一个着陆场。
protocol LandingSiteHaving {
    var landingSite: String { get }
}

// 我可以降落在 LandingSiteHaving 对象上。
protocol Landing {
    func land(on: LandingSiteHaving) -> String
}

// 我有载荷。
protocol PayloadHaving {
    var payload: String { get }
}

// 我可以从飞行器上取回载荷（例如通过 Canadarm）。

protocol PayloadFetching {
    func fetchPayload(vehicle: PayloadHaving) -> String
}

final class InternationalSpaceStation: PayloadFetching {


    // ⚠ 空间站完全不了解 SpaceXCRS8 的着陆能力。
    func fetchPayload(vehicle: PayloadHaving) -> String {
        return "Deployed \(vehicle.payload) at April 10, 2016, 11:23 UTC"
    }
}

// 我是一艘驳船——我有一个着陆场（嗯，你懂的）。
final class OfCourseIStillLoveYouBarge: LandingSiteHaving {
    let landingSite = "a barge on the Atlantic Ocean"
}

// 我有载荷，可以降落在拥有着陆场的物体上。
// 我是一个功能非常有限的航天器，我知道。
final class SpaceXCRS8: Landing, PayloadHaving {

    let payload = "BEAM and some Cube Sats"

    // ⚠️ CRS8 只知道着陆场的信息。
    func land(on: LandingSiteHaving) -> String {
        return "Landed on \(on.landingSite) at April 8, 2016 20:52 UTC"
    }
}

let crs8 = SpaceXCRS8()
let barge = OfCourseIStillLoveYouBarge()
let spaceStation = InternationalSpaceStation()

spaceStation.fetchPayload(vehicle: crs8)
crs8.land(on: barge)
/*:
# 🔝 The Dependency Inversion Principle (依赖倒置原则)

依赖于抽象，而不是具体实现。

两条正式规则定义了此原则：(1) 高层模块不应依赖于低层模块——两者都应依赖于
抽象。(2) 抽象不应依赖于细节——细节应依赖于抽象。通过反转源代码依赖关系，
使其指向策略而非机制，高层业务逻辑就不会受到基础设施和实现细节变更的影响。

示例：
*/

protocol TimeTraveling {
    func travelInTime(time: TimeInterval) -> String
}

final class DeLorean: TimeTraveling {
	func travelInTime(time: TimeInterval) -> String {
		return "Used Flux Capacitor and travelled in time by: \(time)s"
	}
}

final class EmmettBrown {
	private let timeMachine: TimeTraveling

    // ⚠️ Emmett Brown 接收的是 `TimeTraveling` 设备，而不是具体的 `DeLorean` 类！
	init(timeMachine: TimeTraveling) {
		self.timeMachine = timeMachine
	}

	func travelInTime(time: TimeInterval) -> String {
		return timeMachine.travelInTime(time: time)
	}
}

let timeMachine = DeLorean()

let mastermind = EmmettBrown(timeMachine: timeMachine)
mastermind.travelInTime(time: -3600 * 8760)
/*:

Info
====

📖 Descriptions from: [The Principles of OOD by Uncle Bob](http://butunclebob.com/ArticleS.UncleBob.PrinciplesOfOod)

*/
