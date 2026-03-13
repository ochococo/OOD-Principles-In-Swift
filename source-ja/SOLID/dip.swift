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
