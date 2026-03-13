/*:
Swift 5 में ऑब्जेक्ट-ओरिएंटेड डिज़ाइन सिद्धांत
=========================

Playground के साथ संक्षिप्त सहायिका ([OOD-Principles-In-Swift-hi.playground.zip](https://raw.githubusercontent.com/ochococo/OOD-Principles-In-Swift/master/OOD-Principles-In-Swift-hi.playground.zip)).

👷 Project maintained by: [@oktawian](https://bsky.app/profile/oktawian.bsky.social) (Oktawian Chojnacki)

S.O.L.I.D.
==========

* [The Single Responsibility Principle (एकल उत्तरदायित्व सिद्धांत)](#-the-single-responsibility-principle-एकल-उत्तरदायित्व-सिद्धांत)
* [The Open Closed Principle (खुला/बंद सिद्धांत)](#-the-open-closed-principle-खुलाबंद-सिद्धांत)
* [The Liskov Substitution Principle (लिस्कोव प्रतिस्थापन सिद्धांत)](#-the-liskov-substitution-principle-लिस्कोव-प्रतिस्थापन-सिद्धांत)
* [The Interface Segregation Principle (इंटरफ़ेस पृथक्करण सिद्धांत)](#-the-interface-segregation-principle-इंटरफ़ेस-पृथक्करण-सिद्धांत)
* [The Dependency Inversion Principle (निर्भरता व्युत्क्रम सिद्धांत)](#-the-dependency-inversion-principle-निर्भरता-व्युत्क्रम-सिद्धांत)
*/

import Foundation

/*:
# 🔐 The Single Responsibility Principle (एकल उत्तरदायित्व सिद्धांत)

एक क्लास के पास बदलने का एक, और केवल एक, कारण होना चाहिए।

अधिक सटीक परिभाषा: एक मॉड्यूल केवल एक, और केवल एक, एक्टर (हितधारक) के प्रति
उत्तरदायी होना चाहिए। SRP का अर्थ "एक ही काम करो" नहीं है — यह उन चीजों को
एक साथ समूहित करने के बारे में है जो समान कारणों से बदलती हैं और उन चीजों को
अलग करने के बारे में है जो भिन्न कारणों से बदलती हैं। जब एक क्लास कई एक्टर्स
की सेवा करती है, तो एक एक्टर द्वारा अनुरोधित परिवर्तन दूसरे की अपेक्षाओं को
भंग कर सकते हैं।

उदाहरण:
*/

protocol Openable {
    mutating func open()
}

protocol Closeable {
    mutating func close()
}

// मैं दरवाज़ा हूँ। मेरी एक संकुचित स्थिति है और आप इसे मेथड्स से बदल सकते हैं।
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

// मैं केवल खोलने के लिए ज़िम्मेदार हूँ, मुझे नहीं पता अंदर क्या है या कैसे बंद करना है।
final class DoorOpener {
    private var door: Openable

    init(door: Openable) {
        self.door = door
    }

    func execute() {
        door.open()
    }
}

// मैं केवल बंद करने के लिए ज़िम्मेदार हूँ, मुझे नहीं पता अंदर क्या है या कैसे खोलना है।
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


// ⚠️ केवल `DoorOpener` ही दरवाज़ा खोलने के लिए ज़िम्मेदार है।
let doorOpener = DoorOpener(door: door)
doorOpener.execute()

// ⚠️ यदि दरवाज़ा बंद करते समय कोई अन्य ऑपरेशन करना हो,
// जैसे अलार्म चालू करना, तो `DoorOpener` क्लास को बदलने की ज़रूरत नहीं है।
let doorCloser = DoorCloser(door: door)
doorCloser.execute()
/*:
# ✋ The Open Closed Principle (खुला/बंद सिद्धांत)

आपको किसी क्लास के व्यवहार को बिना उसे संशोधित किए विस्तारित करने में सक्षम होना चाहिए।

सॉफ्टवेयर इकाइयाँ (क्लासेज़, मॉड्यूल, फ़ंक्शन) विस्तार के लिए खुली होनी चाहिए
लेकिन संशोधन के लिए बंद। मुख्य अंतर्दृष्टि यह है कि जब एक अकेला परिवर्तन
निर्भर मॉड्यूल्स में श्रृंखलाबद्ध रूप से फैलता है, तो डिज़ाइन नाज़ुक है।
अमूर्तताओं (प्रोटोकॉल) पर निर्भर रहकर, नया व्यवहार नया कोड लिखकर जोड़ा जा
सकता है — मौजूदा, कार्यशील कोड को बदले बिना।

उदाहरण:
 */

protocol Shooting {
    func shoot() -> String
}

// मैं एक लेज़र बीम हूँ। मैं गोली चला सकती हूँ।
final class LaserBeam: Shooting {
    func shoot() -> String {
        return "Ziiiiiip!"
    }
}

// मेरे पास हथियार हैं और मुझ पर भरोसा करो, मैं उन सबको एक साथ दाग़ सकता हूँ। धमाका! धमाका! धमाका!
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

// मैं एक रॉकेट लॉन्चर हूँ। मैं रॉकेट दाग़ सकता हूँ।
// ⚠️ रॉकेट लॉन्चर का समर्थन जोड़ने के लिए मुझे मौजूदा क्लासेज़ में कुछ भी बदलने की ज़रूरत नहीं है।
final class RocketLauncher: Shooting {
    func shoot() -> String {
        return "Whoosh!"
    }
}

let rocket = RocketLauncher()

weapons = WeaponsComposite(weapons: [laser, rocket])
weapons.shoot()
/*:
# 👥 The Liskov Substitution Principle (लिस्कोव प्रतिस्थापन सिद्धांत)

व्युत्पन्न क्लासेज़ को अपनी आधार क्लासेज़ के स्थान पर प्रतिस्थापित किया जा सकना चाहिए।

उपप्रकारों को अपने अधिप्रकारों के व्यवहारात्मक अनुबंध का सम्मान करना चाहिए: उन्हें
पूर्व-शर्तों को सख्त नहीं करना चाहिए, उत्तर-शर्तों को कमज़ोर नहीं करना चाहिए, या
अपरिवर्तनीयताओं का उल्लंघन नहीं करना चाहिए। एक कॉलर जो आधार प्रकार के साथ काम करता
है, उसे बिना जाने किसी भी उपप्रकार का उपयोग करने में सक्षम होना चाहिए, और प्रोग्राम
को सही ढंग से कार्य करते रहना चाहिए। इस सिद्धांत के उल्लंघन से नाज़ुक पदानुक्रम
बनते हैं जहाँ क्लाइंट कोड में `if/else` प्रकार-जाँच आ जाती है।

उदाहरण:
*/

let requestKey: String = "NSURLRequestKey"

// मैं NSError की उपक्लास हूँ। मैं अतिरिक्त कार्यक्षमता प्रदान करती हूँ लेकिन मूल को बाधित नहीं करती।
class RequestError: NSError {

    var request: NSURLRequest? {
        return self.userInfo[requestKey] as? NSURLRequest
    }
}

// मैं डेटा प्राप्त करने में विफल रही और RequestError लौटाऊँगी।
func fetchData(request: NSURLRequest) -> (data: NSData?, error: RequestError?) {

    let userInfo: [String:Any] = [requestKey : request]

    return (nil, RequestError(domain:"DOMAIN", code:0, userInfo: userInfo))
}

// मुझे नहीं पता कि RequestError क्या है और मैं विफल होकर NSError लौटाऊँगी।
func willReturnObjectOrError() -> (object: AnyObject?, error: NSError?) {

    let request = NSURLRequest()
    let result = fetchData(request: request)

    return (result.data, result.error)
}

let result = willReturnObjectOrError()

// ठीक है। मेरे दृष्टिकोण से यह NSError का एक उत्तम इंस्टेंस है।
let error: Int? = result.error?.code

// ⚠️ लेकिन रुकिए! यह क्या है? यह एक RequestError भी है! बढ़िया!
if let requestError = result.error as? RequestError {
    requestError.request
}
/*:
# 🍴 The Interface Segregation Principle (इंटरफ़ेस पृथक्करण सिद्धांत)

क्लाइंट-विशिष्ट सूक्ष्म-दानेदार इंटरफ़ेस बनाएँ।

किसी भी क्लाइंट को उन मेथड्स पर निर्भर होने के लिए मजबूर नहीं किया जाना चाहिए
जिनका वह उपयोग नहीं करता। जब कोई इंटरफ़ेस बहुत बड़ा हो जाता है, तो उसके
क्लाइंट उन मेथड्स से जुड़ जाते हैं जिन्हें वे कभी कॉल नहीं करते — और उन
असंबंधित मेथड्स में परिवर्तन क्लाइंट्स को पुनः संकलित या पुनः तैनात करने के लिए
मजबूर कर सकते हैं। बड़े इंटरफ़ेस को छोटे, भूमिका-विशिष्ट प्रोटोकॉल में विभाजित
करने से निर्भरताएँ संकीर्ण और सुसंगत रहती हैं।

उदाहरण:
 */

// मेरे पास एक लैंडिंग साइट है।
protocol LandingSiteHaving {
    var landingSite: String { get }
}

// मैं LandingSiteHaving ऑब्जेक्ट्स पर लैंड कर सकता हूँ।
protocol Landing {
    func land(on: LandingSiteHaving) -> String
}

// मेरे पास पेलोड है।
protocol PayloadHaving {
    var payload: String { get }
}

// मैं वाहन से पेलोड प्राप्त कर सकता हूँ (जैसे कैनेडार्म के माध्यम से)।

protocol PayloadFetching {
    func fetchPayload(vehicle: PayloadHaving) -> String
}

final class InternationalSpaceStation: PayloadFetching {


    // ⚠ अंतरिक्ष स्टेशन को SpaceXCRS8 की लैंडिंग क्षमताओं के बारे में कोई जानकारी नहीं है।
    func fetchPayload(vehicle: PayloadHaving) -> String {
        return "Deployed \(vehicle.payload) at April 10, 2016, 11:23 UTC"
    }
}

// मैं एक बार्ज हूँ — मेरे पास लैंडिंग साइट है (खैर, आप समझ गए होंगे)।
final class OfCourseIStillLoveYouBarge: LandingSiteHaving {
    let landingSite = "a barge on the Atlantic Ocean"
}

// मेरे पास पेलोड है और मैं लैंडिंग साइट वाली चीज़ों पर लैंड कर सकता हूँ।
// मैं एक बहुत सीमित अंतरिक्ष वाहन हूँ, मुझे पता है।
final class SpaceXCRS8: Landing, PayloadHaving {

    let payload = "BEAM and some Cube Sats"

    // ⚠️ CRS8 केवल लैंडिंग साइट की जानकारी जानता है।
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
/*:

Info
====

📖 Descriptions from: [The Principles of OOD by Uncle Bob](http://butunclebob.com/ArticleS.UncleBob.PrinciplesOfOod)

*/
