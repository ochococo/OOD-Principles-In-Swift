/*:
# 🔝 The Dependency Inversion Principle (निर्भरता व्युत्क्रम सिद्धांत)

ठोस कार्यान्वयनों पर नहीं, अमूर्तताओं पर निर्भर रहें।

दो औपचारिक नियम इस सिद्धांत को परिभाषित करते हैं: (1) उच्च-स्तरीय मॉड्यूल को
निम्न-स्तरीय मॉड्यूल पर निर्भर नहीं होना चाहिए — दोनों को अमूर्तताओं पर निर्भर
होना चाहिए। (2) अमूर्तताओं को विवरणों पर निर्भर नहीं होना चाहिए — विवरणों को
अमूर्तताओं पर निर्भर होना चाहिए। स्रोत-कोड निर्भरता को उलट कर ताकि वह
तंत्रों के बजाय नीतियों की ओर इंगित करे, उच्च-स्तरीय व्यावसायिक तर्क
बुनियादी ढाँचे और कार्यान्वयन विवरणों में परिवर्तनों से प्रतिरक्षित हो जाता है।

उदाहरण:
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

    // ⚠️ Emmett Brown को एक `TimeTraveling` उपकरण दिया गया है, न कि ठोस क्लास `DeLorean`!
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
