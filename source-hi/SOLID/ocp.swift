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
