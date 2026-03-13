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
