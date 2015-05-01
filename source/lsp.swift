/*:
# 👥 The Liskov Substitution Principle

Derived classes must be substitutable for their base classes.

*/

let requestKey:NSString = "NSURLRequestKey"

// I'm a NSError subclass. I provide additional functionality but don't mess with original ones.
class RequestError : NSError {

    var request : NSURLRequest? {
        return self.userInfo?[requestKey] as? NSURLRequest
    }
}

// I fail to fetch data and will return RequestError.
func fetchData(request:NSURLRequest) -> (data:NSData?, error:RequestError?) {

    let userInfo:[NSObject:AnyObject] = [ requestKey : request ]

    return (nil, RequestError(domain:"DOMAIN", code: 1, userInfo: userInfo))
}

// I don't know what RequestError is and will fail and return a NSError.
func willReturnObjectOrError() -> (object:AnyObject?, error:NSError?) {

    let request = NSURLRequest()
    let result = fetchData(request)

    return (result.data , result.error)
}

let result = willReturnObjectOrError()

// Ok. This is a perfect NSError instance from my perspective.
let error:Int? = result.error?.code

// But hey! What's that? It's also a RequestError! Nice!
if let requestError = result.error as? RequestError {
    requestError.request;
}
