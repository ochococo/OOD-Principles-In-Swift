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
