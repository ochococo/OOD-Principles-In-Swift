/*:
Swift 5 におけるオブジェクト指向設計原則
=========================

A short cheat-sheet with Playground ([OOD-Principles-In-Swift-ja.playground.zip](https://raw.githubusercontent.com/ochococo/OOD-Principles-In-Swift/master/OOD-Principles-In-Swift-ja.playground.zip)).

👷 Project maintained by: [@oktawian](https://bsky.app/profile/oktawian.bsky.social) (Oktawian Chojnacki)

S.O.L.I.D.
==========

* [The Single Responsibility Principle (単一責任の原則)](#-the-single-responsibility-principle-単一責任の原則)
* [The Open Closed Principle (開放閉鎖の原則)](#-the-open-closed-principle-開放閉鎖の原則)
* [The Liskov Substitution Principle (リスコフの置換原則)](#-the-liskov-substitution-principle-リスコフの置換原則)
* [The Interface Segregation Principle (インターフェース分離の原則)](#-the-interface-segregation-principle-インターフェース分離の原則)
* [The Dependency Inversion Principle (依存性逆転の原則)](#-the-dependency-inversion-principle-依存性逆転の原則)

*/

import Foundation

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
/*:
# ✋ The Open Closed Principle (開放閉鎖の原則)

クラスの振る舞いを変更せずに拡張できるべきです。

ソフトウェアエンティティ（クラス、モジュール、関数）は拡張に対して開いており、
修正に対して閉じているべきです。重要な洞察は、単一の変更が依存モジュールに連鎖的
に波及する場合、その設計は脆弱であるということです。抽象（プロトコル）に依存する
ことで、既存の動作するコードを変更せずに、新しいコードを書くことで新しい振る舞い
を追加できます。

例：
 */

protocol Shooting {
    func shoot() -> String
}

// 私はレーザービームです。射撃できます。
final class LaserBeam: Shooting {
    func shoot() -> String {
        return "Ziiiiiip!"
    }
}

// 私は武器を持っていて、全部一斉に発射できます。ドカン！ドカン！ドカン！
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

// 私はロケットランチャーです。ロケットを発射できます。
// ⚠️ ロケットランチャーのサポートを追加するために、既存のクラスを変更する必要はありません。
final class RocketLauncher: Shooting {
    func shoot() -> String {
        return "Whoosh!"
    }
}

let rocket = RocketLauncher()

weapons = WeaponsComposite(weapons: [laser, rocket])
weapons.shoot()
/*:
# 👥 The Liskov Substitution Principle (リスコフの置換原則)

派生クラスは基底クラスと置換可能でなければなりません。

サブタイプはスーパータイプの振る舞いの契約を尊重しなければなりません：事前条件を
強化したり、事後条件を弱めたり、不変条件に違反してはなりません。基底型を使う
呼び出し元は、それと知らずに任意のサブタイプを使用でき、プログラムは正しく
動作し続けるべきです。この原則の違反は、クライアントコードに `if/else` 型チェック
が忍び込む脆弱な階層構造を生みます。

例：
*/

let requestKey: String = "NSURLRequestKey"

// 私は NSError のサブクラスです。追加機能を提供しますが、元の機能は壊しません。
class RequestError: NSError {

    var request: NSURLRequest? {
        return self.userInfo[requestKey] as? NSURLRequest
    }
}

// データの取得に失敗し、RequestError を返します。
func fetchData(request: NSURLRequest) -> (data: NSData?, error: RequestError?) {

    let userInfo: [String:Any] = [requestKey : request]

    return (nil, RequestError(domain:"DOMAIN", code:0, userInfo: userInfo))
}

// RequestError が何か知らず、失敗して NSError を返します。
func willReturnObjectOrError() -> (object: AnyObject?, error: NSError?) {

    let request = NSURLRequest()
    let result = fetchData(request: request)

    return (result.data, result.error)
}

let result = willReturnObjectOrError()

// 問題ありません。私の観点からは、これは完璧な NSError インスタンスです。
let error: Int? = result.error?.code

// ⚠️ でもちょっと待って！これは何？RequestError でもあるんです！素晴らしい！
if let requestError = result.error as? RequestError {
    requestError.request
}
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
/*:
# 🔝 The Dependency Inversion Principle (依存性逆転の原則)

具象ではなく、抽象に依存せよ。

この原則を定義する二つの公式ルール：(1) 高レベルモジュールは低レベルモジュールに
依存すべきではない——両方とも抽象に依存すべきです。(2) 抽象は詳細に依存すべき
ではない——詳細が抽象に依存すべきです。ソースコードの依存関係を逆転させ、
メカニズムではなくポリシーに向けることで、高レベルのビジネスロジックは
インフラストラクチャや実装の詳細の変更から守られます。

例：
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

    // ⚠️ Emmett Brown が受け取るのは `TimeTraveling` デバイスであり、具象クラス `DeLorean` ではありません！
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
