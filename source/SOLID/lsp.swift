/*:
# 👥 The Liskov Substitution Principle

Derived classes must be substitutable for their base classes.

Subtypes must honor the behavioral contract of their supertypes: they must not
strengthen preconditions, weaken postconditions, or violate invariants. A caller
that works with a base type must be able to use any subtype without knowing it,
and the program should still behave correctly. Violations of this principle lead
to fragile hierarchies where `if/else` type-checks creep into client code.

Example:
*/

let requestKey: String = "NSURLRequestKey"

// I'm a NSError subclass. I provide additional functionality but don't mess with original ones.
class RequestError: NSError {

    var request: NSURLRequest? {
        return self.userInfo[requestKey] as? NSURLRequest
    }
}

// I fail to fetch data and will return RequestError.
func fetchData(request: NSURLRequest) -> (data: NSData?, error: RequestError?) {

    let userInfo: [String:Any] = [requestKey : request]

    return (nil, RequestError(domain:"DOMAIN", code:0, userInfo: userInfo))
}

// I don't know what RequestError is and will fail and return a NSError.
func willReturnObjectOrError() -> (object: AnyObject?, error: NSError?) {

    let request = NSURLRequest()
    let result = fetchData(request: request)

    return (result.data, result.error)
}

let result = willReturnObjectOrError()

// Ok. This is a perfect NSError instance from my perspective.
let error: Int? = result.error?.code

// ⚠️ But hey! What's that? It's also a RequestError! Nice!
if let requestError = result.error as? RequestError {
    requestError.request
}

