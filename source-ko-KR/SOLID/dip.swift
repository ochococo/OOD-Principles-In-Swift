/*:
# 🔝 The Dependency Inversion Principle (의존관계 역전 원칙)

구체화에 의존하지 말고 추상화에 의존하라.

이 원칙을 정의하는 두 가지 규칙: (1) 고수준 모듈은 저수준 모듈에 의존해서는
안 된다 — 둘 다 추상화에 의존해야 한다. (2) 추상화는 세부 사항에 의존해서는
안 된다 — 세부 사항이 추상화에 의존해야 한다. 소스 코드 의존성을 메커니즘이 아닌
정책 방향으로 역전시킴으로써, 고수준 비즈니스 로직은 인프라와 구현 세부 사항의
변경으로부터 보호된다.

예시:
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


    // ⚠️ Emmet Brown은 `DeLorean`을 구체적인 클래스인 `DeLorean`이 아닌, `TimeTraveling` 장치로 받는다.
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
