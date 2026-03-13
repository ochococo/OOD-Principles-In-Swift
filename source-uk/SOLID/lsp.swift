/*:
# 👥 The Liskov Substitution Principle (Принцип підстановки Лісков)

Похідні класи повинні бути підставними замість базових класів.

Підтипи повинні дотримуватися поведінкового контракту своїх надтипів: вони не
повинні посилювати передумови, послаблювати постумови або порушувати інваріанти.
Викликаючий код, який працює з базовим типом, повинен мати можливість
використовувати будь-який підтип, не знаючи про це, і програма повинна
продовжувати працювати правильно. Порушення цього принципу призводять до крихких
ієрархій, де в клієнтському коді з'являються перевірки типу `if/else`.

Приклад:
*/

let requestKey: String = "NSURLRequestKey"

// Я — підклас NSError. Я надаю додаткову функціональність, але не порушую оригінальну.
class RequestError: NSError {

    var request: NSURLRequest? {
        return self.userInfo[requestKey] as? NSURLRequest
    }
}

// Мені не вдається отримати дані, і я поверну RequestError.
func fetchData(request: NSURLRequest) -> (data: NSData?, error: RequestError?) {

    let userInfo: [String:Any] = [requestKey : request]

    return (nil, RequestError(domain:"DOMAIN", code:0, userInfo: userInfo))
}

// Я не знаю що таке RequestError і поверну NSError.
func willReturnObjectOrError() -> (object: AnyObject?, error: NSError?) {

    let request = NSURLRequest()
    let result = fetchData(request: request)

    return (result.data, result.error)
}

let result = willReturnObjectOrError()

// OK. З моєї точки зору це ідеальний екземпляр NSError.
let error: Int? = result.error?.code

// ⚠️ Але зачекайте! Що це? Це також RequestError! Чудово!
if let requestError = result.error as? RequestError {
    requestError.request
}
