/*:
# 👥 The Liskov Substitution Principle (리스코프 치환 원칙)

파생된 클래스는 기본 클래스를 대체할 수 있어야 한다.

하위 타입은 상위 타입의 행위적 계약을 준수해야 한다: 사전 조건을 강화하거나,
사후 조건을 약화하거나, 불변 조건을 위반해서는 안 된다. 기본 타입으로 작업하는
호출자는 하위 타입을 알지 못한 채 사용할 수 있어야 하며, 프로그램은 여전히
올바르게 동작해야 한다. 이 원칙을 위반하면 클라이언트 코드에 `if/else` 타입
검사가 스며드는 취약한 계층 구조가 생긴다.

예시:
*/

let requestKey: String = "NSURLRequestKey"

// NSError 서브클래스. 추가적인 기능을 제공하지만 원래 기능을 엉망으로 만들진 않는다.
class RequestError: NSError {

    var request: NSURLRequest? {
        return self.userInfo[requestKey] as? NSURLRequest
    }
}

// 데이터를 가져오지 못하면 RequestError를 반환한다.
func fetchData(request: NSURLRequest) -> (data: NSData?, error: RequestError?) {

    let userInfo: [String:Any] = [requestKey : request]

    return (nil, RequestError(domain:"DOMAIN", code:0, userInfo: userInfo))
}

// RequestError가 무엇인지 모르고 실패할 것이며, NSError를 반환한다.
func willReturnObjectOrError() -> (object: AnyObject?, error: NSError?) {

    let request = NSURLRequest()
    let result = fetchData(request: request)

    return (result.data, result.error)
}

let result = willReturnObjectOrError()

// ⚠️ 확인. 이것은 내 관점에서 완벽한 NSError 인스턴스이다.
let error: Int? = result.error?.code

// ⚠️ 하지만 이봐! 이게 무슨 일이죠? RequestError이기도 하다! 대단해!
if let requestError = result.error as? RequestError {
    requestError.request
}

