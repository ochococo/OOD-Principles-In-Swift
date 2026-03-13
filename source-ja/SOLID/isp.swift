/*:
# 🍴 The Interface Segregation Principle (インターフェース分離の原則)

クライアントに特化したきめ細かいインターフェースを作成しましょう。

クライアントが使用しないメソッドへの依存を強制されるべきではありません。
インターフェースが大きくなりすぎると、クライアントは呼び出さないメソッドと
結合してしまい、それら無関係なメソッドの変更がクライアントの再コンパイルや
再デプロイを強制する可能性があります。肥大化したインターフェースを、より小さく
役割に特化したプロトコルに分割することで、依存関係を狭く凝集的に保てます。

例：
 */

// 私は着陸場を持っています。
protocol LandingSiteHaving {
    var landingSite: String { get }
}

// 私は LandingSiteHaving オブジェクトに着陸できます。
protocol Landing {
    func land(on: LandingSiteHaving) -> String
}

// 私はペイロードを持っています。
protocol PayloadHaving {
    var payload: String { get }
}

// 私は車両からペイロードを取得できます（例：Canadarm経由）。

protocol PayloadFetching {
    func fetchPayload(vehicle: PayloadHaving) -> String
}

final class InternationalSpaceStation: PayloadFetching {


    // ⚠ 宇宙ステーションは SpaceXCRS8 の着陸能力について何も知りません。
    func fetchPayload(vehicle: PayloadHaving) -> String {
        return "Deployed \(vehicle.payload) at April 10, 2016, 11:23 UTC"
    }
}

// 私はバージ（はしけ）です——着陸場を持っています（まあ、おわかりですね）。
final class OfCourseIStillLoveYouBarge: LandingSiteHaving {
    let landingSite = "a barge on the Atlantic Ocean"
}

// 私はペイロードを持ち、着陸場のある場所に着陸できます。
// 私はとても限定的な宇宙船です、わかっています。
final class SpaceXCRS8: Landing, PayloadHaving {

    let payload = "BEAM and some Cube Sats"

    // ⚠️ CRS8 は着陸場の情報だけを知っています。
    func land(on: LandingSiteHaving) -> String {
        return "Landed on \(on.landingSite) at April 8, 2016 20:52 UTC"
    }
}

let crs8 = SpaceXCRS8()
let barge = OfCourseIStillLoveYouBarge()
let spaceStation = InternationalSpaceStation()

spaceStation.fetchPayload(vehicle: crs8)
crs8.land(on: barge)
