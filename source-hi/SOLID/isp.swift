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
