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
