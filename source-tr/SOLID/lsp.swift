/*:
# 👥 The Liskov Substitution Principle (Liskov Yerine Gecme Ilkesi)

Turetilmis siniflar, temel siniflarin yerine gecilebilir olmalidir.

Alt tipler, ust tiplerinin davranissal sozlesmesine uymalidirlar: on kosullari
guclendirmemeli, son kosullari zayiflatmamali veya degismezleri ihlal
etmemelidirler. Temel bir tiple calisan bir cagiran, herhangi bir alt tipi
bilmeden kullanabilmeli ve program dogru sekilde calismaya devam etmelidir.
Bu ilkenin ihlalleri, istemci kodunda `if/else` tip kontrollerinin belirdigi
kirilgan hiyerarsiler olusturur.

Ornek:
*/

let requestKey: String = "NSURLRequestKey"

// Ben bir NSError alt sinifiyim. Ek islevsellik sagliyorum ama orijinallerini bozmuyorum.
class RequestError: NSError {

    var request: NSURLRequest? {
        return self.userInfo[requestKey] as? NSURLRequest
    }
}

// Veri cekmekte basarisiz oldum ve RequestError dondurecegim.
func fetchData(request: NSURLRequest) -> (data: NSData?, error: RequestError?) {

    let userInfo: [String:Any] = [requestKey : request]

    return (nil, RequestError(domain:"DOMAIN", code:0, userInfo: userInfo))
}

// RequestError'in ne oldugunu bilmiyorum ve basarisiz olup NSError dondurecegim.
func willReturnObjectOrError() -> (object: AnyObject?, error: NSError?) {

    let request = NSURLRequest()
    let result = fetchData(request: request)

    return (result.data, result.error)
}

let result = willReturnObjectOrError()

// Tamam. Benim bakis acimdan bu mukemmel bir NSError ornegi.
let error: Int? = result.error?.code

// ⚠️ Ama durun! Bu da ne? Bu ayni zamanda bir RequestError! Harika!
if let requestError = result.error as? RequestError {
    requestError.request
}
