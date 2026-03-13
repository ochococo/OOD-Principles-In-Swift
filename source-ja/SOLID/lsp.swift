/*:
# 👥 The Liskov Substitution Principle (リスコフの置換原則)

派生クラスは基底クラスと置換可能でなければなりません。

サブタイプはスーパータイプの振る舞いの契約を尊重しなければなりません：事前条件を
強化したり、事後条件を弱めたり、不変条件に違反してはなりません。基底型を使う
呼び出し元は、それと知らずに任意のサブタイプを使用でき、プログラムは正しく
動作し続けるべきです。この原則の違反は、クライアントコードに `if/else` 型チェック
が忍び込む脆弱な階層構造を生みます。

例：
*/

let requestKey: String = "NSURLRequestKey"

// 私は NSError のサブクラスです。追加機能を提供しますが、元の機能は壊しません。
class RequestError: NSError {

    var request: NSURLRequest? {
        return self.userInfo[requestKey] as? NSURLRequest
    }
}

// データの取得に失敗し、RequestError を返します。
func fetchData(request: NSURLRequest) -> (data: NSData?, error: RequestError?) {

    let userInfo: [String:Any] = [requestKey : request]

    return (nil, RequestError(domain:"DOMAIN", code:0, userInfo: userInfo))
}

// RequestError が何か知らず、失敗して NSError を返します。
func willReturnObjectOrError() -> (object: AnyObject?, error: NSError?) {

    let request = NSURLRequest()
    let result = fetchData(request: request)

    return (result.data, result.error)
}

let result = willReturnObjectOrError()

// 問題ありません。私の観点からは、これは完璧な NSError インスタンスです。
let error: Int? = result.error?.code

// ⚠️ でもちょっと待って！これは何？RequestError でもあるんです！素晴らしい！
if let requestError = result.error as? RequestError {
    requestError.request
}
