/*:
# 👥 The Liskov Substitution Principle (里氏替换原则)

派生类必须能够替换其基类。

子类型必须遵守其超类型的行为契约：不能加强前置条件、不能削弱后置条件、不能
违反不变量。使用基类型的调用者必须能够使用任何子类型而不自知，程序仍应正确
运行。违反此原则会导致脆弱的继承层次，客户端代码中会出现 `if/else` 类型检查。

示例：
*/

let requestKey: String = "NSURLRequestKey"

// 我是 NSError 的子类。我提供额外的功能，但不破坏原有的功能。
class RequestError: NSError {

    var request: NSURLRequest? {
        return self.userInfo[requestKey] as? NSURLRequest
    }
}

// 我无法获取数据，将返回 RequestError。
func fetchData(request: NSURLRequest) -> (data: NSData?, error: RequestError?) {

    let userInfo: [String:Any] = [requestKey : request]

    return (nil, RequestError(domain:"DOMAIN", code:0, userInfo: userInfo))
}

// 我不知道 RequestError 是什么，将失败并返回 NSError。
func willReturnObjectOrError() -> (object: AnyObject?, error: NSError?) {

    let request = NSURLRequest()
    let result = fetchData(request: request)

    return (result.data, result.error)
}

let result = willReturnObjectOrError()

// 好的。从我的角度来看，这是一个完美的 NSError 实例。
let error: Int? = result.error?.code

// ⚠️ 但等等！这是什么？它同时也是 RequestError！太棒了！
if let requestError = result.error as? RequestError {
    requestError.request
}
