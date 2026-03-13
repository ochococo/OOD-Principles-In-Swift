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
