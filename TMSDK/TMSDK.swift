import Foundation

extension String {
    public var md5: String {
        return SwiftMD5().encodeMD5(digest: md5Digest)
    }

    public var md5Digest: [UInt8] {
        let bytes = [UInt8](self.utf8)
        let digest = SwiftMD5().md5(bytes)
        return digest.digest
    }
}

@objcMembers public class TMSDK:NSObject {
    private(set) var version = "1.0.0"
    private(set) var programId = ""
    private(set) var appid = ""
    private(set) var channel = ""
    
    
    @objc public func config(programId:String,appid:String,channel:String){
        self.programId = programId
        self.appid = appid
        self.channel = channel
    }
    
    @objc func md5(data:String) ->String!{
        return data.md5
    }
    
    @objc func getDictionaryFromJSONString(jsonString:String) ->NSDictionary{
        let jsonData:Data = jsonString.data(using: .utf8)!
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }
        return NSDictionary()
    }
   
//    func get(callback:((String)->())?){
//        let url:URL = URL(string:"https://catwechat.61week.com/api")!
//        let session = URLSession.shared
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        let task:URLSessionDataTask = session.dataTask(with: request as URLRequest) {(
//            data, response, error) in
//
//            guard let data = data, let _:URLResponse = response, error == nil else {
//                print("error")
//                return
//            }
//            let dataString = String(data: data, encoding: String.Encoding.utf8)
//            callback?(dataString!)
//            let dict = self.getDictionaryFromJSONString(jsonString: dataString!)
//    //        print(dict)
//        }
//        task.resume()
//    }
    @objc public func sign(data:NSDictionary)->String{
        let sortData = data.sorted(by: {"\($0.key)" < "\($1.key)"})
        let list = sortData.map{"\($0.key)=\($0.value)"}
        return "\(list.joined(separator: "&"))\(self.programId)".md5
    }
    @objc public func online(open_id:String,ofp:String)->String{
        let jsonData:NSMutableDictionary = ["appid":self.appid,"openid":open_id,"uidfp":ofp]
        var json = NSData()
        do {
            json = try JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted) as NSData
        } catch {
            print(error.localizedDescription)
        }
        
        let url:URL = URL(string: "https://h5game-log.kuaiyugo.com/ping")!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("\(json.length)", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = json as Data
        var returnData = ""
        // ????????????
        let timeout = DispatchSemaphore(value:0)
        let task = session.dataTask(with: request as URLRequest) {(
            data, response, error) in

            guard let data = data, let _:URLResponse = response, error == nil else {
                print("error")
                return
            }
            let dataString = String(data: data, encoding: String.Encoding.utf8)
            returnData = dataString!
            timeout.signal()
        }
        task.resume()
        _ = timeout.wait(timeout: DispatchTime.distantFuture)
        return returnData
    }
    @objc public func createOrder(
        open_id:String,
        coin:String,
        program_param:String,
        goods_name:String,
        zone:String,
        game_uid:String,
        game_nickname:String,
        pay_type:String
    )->String{
        let timestamp = Int(Date().timeIntervalSince1970)
        let jsonData:NSMutableDictionary = ["open_id":open_id,"coin":coin,"program_param":program_param,"goods_name":goods_name,"zone":zone,"game_uid":game_uid,"game_nickname":game_nickname,"pay_type":pay_type,"timestamp":timestamp]
        let signId = self.sign(data: jsonData)
        jsonData["sign"] = signId
        var json = NSData()
        do {
            json = try JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted) as NSData
        } catch {
            print(error.localizedDescription)
        }
        
        let url:URL = URL(string: "https://api.kuaiyugo.com/api/payment/v1/programs/\(self.programId)/h5_orders")!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("\(json.length)", forHTTPHeaderField: "Content-Length")
        request.setValue("IOS_SDK", forHTTPHeaderField: "from_sdk")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = json as Data
        var returnData = ""
        // ????????????
        let timeout = DispatchSemaphore(value:0)
        let task = session.dataTask(with: request as URLRequest) {(
            data, response, error) in

            guard let data = data, let _:URLResponse = response, error == nil else {
                print("error")
                return
            }
            let dataString = String(data: data, encoding: String.Encoding.utf8)
            returnData = dataString!
            timeout.signal()
        }
        task.resume()
        _ = timeout.wait(timeout: DispatchTime.distantFuture)
        return returnData
    }
    @objc public func createRole(
        open_id:String,
        trackingId:String,
        gameUserId:String,
        nickname:String,
        zone:String,
        level:String,
        vip_level:String
    )->String{
        let timestamp = Int(Date().timeIntervalSince1970)
        let jsonData:NSMutableDictionary = ["open_id":open_id,"player_info":[
            "trackingId": trackingId,
                        "g_uid": gameUserId,
                        "g_nickname": nickname,
                        "g_zone": zone,
                        "g_level": level,
                        "g_vip_level": vip_level
        ],"timestamp":timestamp]
        
        let signId = "open_id=\(open_id)&player_info=[object Object]&timestamp=\(timestamp)\(self.programId)".md5
        
        jsonData["sign"] = signId
        var json = NSData()
        do {
            json = try JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted) as NSData
        } catch {
            print(error.localizedDescription)
        }
        
        let url:URL = URL(string: "https://api.kuaiyugo.com/api/platuser/v1/programs/\(self.programId)/player_info")!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("\(json.length)", forHTTPHeaderField: "Content-Length")
        request.setValue("IOS_SDK", forHTTPHeaderField: "from_sdk")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = json as Data
        var returnData = ""
        // ????????????
        let timeout = DispatchSemaphore(value:0)
        let task = session.dataTask(with: request as URLRequest) {(
            data, response, error) in

            guard let data = data, let _:URLResponse = response, error == nil else {
                print("error")
                return
            }
            let dataString = String(data: data, encoding: String.Encoding.utf8)
            returnData = dataString!
            timeout.signal()
        }
        task.resume()
        _ = timeout.wait(timeout: DispatchTime.distantFuture)
        return returnData
    }
    @objc public func reportIdentify(open_id:String)->String{
        let timestamp = Int(Date().timeIntervalSince1970)
        let jsonData:NSMutableDictionary = ["open_id":open_id,"behavior":1,"timestamp":timestamp]
        let signId = self.sign(data: jsonData)
        jsonData["sign"] = signId
        let url:URL = URL(string: "https://api.kuaiyugo.com/api/oauth/v1/programs/\(self.programId)/h5_report_user_behavior?open_id=\(open_id)&behavior=1&timestamp=\(timestamp)&sign=\(signId)")!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        var returnData = ""
        // ????????????
        let timeout = DispatchSemaphore(value:0)
        let task = session.dataTask(with: request as URLRequest) {(
            data, response, error) in

            guard let data = data, let _:URLResponse = response, error == nil else {
                print("error")
                return
            }
            let dataString = String(data: data, encoding: String.Encoding.utf8)
            returnData = dataString!
            timeout.signal()
        }
        task.resume()
        _ = timeout.wait(timeout: DispatchTime.distantFuture)
        return returnData
    }
    @objc public func queryIdentify(open_id:String)->String{
        let timestamp = Int(Date().timeIntervalSince1970)
        let jsonData:NSMutableDictionary = ["open_id":open_id,"timestamp":timestamp]
        let signId = self.sign(data: jsonData)
        jsonData["sign"] = signId
        
        let url:URL = URL(string: "https://api.kuaiyugo.com/api/oauth/v1/programs/\(self.programId)/h5_query_id_card?open_id=\(open_id)&timestamp=\(timestamp)&sign=\(signId)")!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        var returnData = ""
        // ????????????
        let timeout = DispatchSemaphore(value:0)
        let task = session.dataTask(with: request as URLRequest) {(
            data, response, error) in

            guard let data = data, let _:URLResponse = response, error == nil else {
                print("error")
                return
            }
            let dataString = String(data: data, encoding: String.Encoding.utf8)
            returnData = dataString!
            timeout.signal()
        }
        task.resume()
        _ = timeout.wait(timeout: DispatchTime.distantFuture)
        return returnData
    }
    @objc public func identify(open_id:String,name:String,id_card:String)->String{
        let timestamp = Int(Date().timeIntervalSince1970)
        let jsonData:NSMutableDictionary = ["open_id":open_id,"name":name,"id_card":id_card,"timestamp":timestamp]
        let signId = self.sign(data: jsonData)
        jsonData["sign"] = signId
        var json = NSData()
        do {
            json = try JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted) as NSData
        } catch {
            print(error.localizedDescription)
        }
        
        let url:URL = URL(string: "https://api.kuaiyugo.com/api/oauth/v1/programs/\(self.programId)/h5_check_id_card")!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("\(json.length)", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = json as Data
        var returnData = ""
        // ????????????
        let timeout = DispatchSemaphore(value:0)
        let task = session.dataTask(with: request as URLRequest) {(
            data, response, error) in

            guard let data = data, let _:URLResponse = response, error == nil else {
                print("error")
                return
            }
            let dataString = String(data: data, encoding: String.Encoding.utf8)
            returnData = dataString!
            timeout.signal()
        }
        task.resume()
        _ = timeout.wait(timeout: DispatchTime.distantFuture)
        return returnData
    }
    @objc public func login(phone:String,verify_code:String)->String{
        let timestamp = Int(Date().timeIntervalSince1970)
        let jsonData:NSMutableDictionary = ["phone":phone,"verify_code":verify_code,"timestamp":timestamp]
        let signId = self.sign(data: jsonData)
        jsonData["sign"] = signId
        var json = NSData()
        do {
            json = try JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted) as NSData
        } catch {
            print(error.localizedDescription)
        }
        
        let url:URL = URL(string: "https://api.kuaiyugo.com/api/platuser/v1/programs/\(self.programId)/account_sessions")!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("\(json.length)", forHTTPHeaderField: "Content-Length")
        request.setValue("ios", forHTTPHeaderField: "device")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = json as Data
        var returnData = ""
        // ????????????
        let timeout = DispatchSemaphore(value:0)
        let task = session.dataTask(with: request as URLRequest) {(
            data, response, error) in

            guard let data = data, let _:URLResponse = response, error == nil else {
                print("error")
                return
            }
            let dataString = String(data: data, encoding: String.Encoding.utf8)
            returnData = dataString!
            timeout.signal()
        }
        task.resume()
        _ = timeout.wait(timeout: DispatchTime.distantFuture)
        return returnData
    }
    @objc public func captcha(phone:String)->String{
        let timestamp = Int(Date().timeIntervalSince1970)
        let jsonData:NSMutableDictionary = ["phone":phone,"type":"LOGIN","timestamp":timestamp]
        let signId = self.sign(data: jsonData)
        jsonData["sign"] = signId//(signId, forKey: "sign")
        var json = NSData()
        do {
            json = try JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted) as NSData
        } catch {
            print(error.localizedDescription)
        }
        
        let url:URL = URL(string: "https://api.kuaiyugo.com/api/platuser/v1/programs/\(self.programId)/captcha")!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("\(json.length)", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = json as Data
        var returnData = ""
        // ????????????
        let timeout = DispatchSemaphore(value:0)
        let task = session.dataTask(with: request as URLRequest) {(
            data, response, error) in

            guard let data = data, let _:URLResponse = response, error == nil else {
                print("error")
                return
            }
            let dataString = String(data: data, encoding: String.Encoding.utf8)
            // ??? jsonString ????????????
//            let dict = self.getDictionaryFromJSONString(jsonString: dataString!)
//            print(dict)
            returnData = dataString!
            timeout.signal()
        }
        task.resume()
        _ = timeout.wait(timeout: DispatchTime.distantFuture)
        return returnData
    }
    @objc public func stringToDictionary(data:String)->NSDictionary{
        return self.getDictionaryFromJSONString(jsonString: data)
    }
//    public func post(){
//        let jsonString = "{\"Data\":{\"xxx\":\"834\",\"xxx\":[{\"xxx\":[{\"xxx\":\"031019\",\"xxx\":\"ADD\",\"xxx\":\"9\"},{\"xxx\":\"5651G-06920ADBAA\",\"xxx\":\"ADD\",\"xxx\":\"6\"}],\"xxx\":\"xxx\",\"Counted\":true,\"xxx\":true,\"LineNum\":\"1\",\"xxx\":\"235\",\"Quantity\":\"15\"}],\"xxx\":\"\",\"Initials\":\"we\",\"xxx\":true},\"xxx\":\"\"}"
//        let dict = self.getDictionaryFromJSONString(jsonString: jsonString)
//        print(dict)
//        var  jsonData = NSData()
//        do {
//             jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted) as NSData
//        } catch {
//            print(error.localizedDescription)
//        }
//        // ??????URL
//        let url:URL = URL(string: "https://catwechat.61week.com/api/hello")!
//        // session
//        let session = URLSession.shared
//        // request
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        // ??????Content-Length????????????
//        request.setValue("\(jsonData.length)", forHTTPHeaderField: "Content-Length")
//        // ?????? Content-Type ??? json ??????
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        // POST    ????????? ?????? ????????? ????????????
//        request.httpBody = jsonData as Data
//        // ????????????
//        let task = session.dataTask(with: request as URLRequest) {(
//            data, response, error) in
//
//            guard let data = data, let _:URLResponse = response, error == nil else {
//                print("error")
//                return
//            }
//            // ????????? utf8 ??????
//            let dataString =  String(data: data, encoding: String.Encoding.utf8)
//            // ??? jsonString ????????????
//            let dict = self.getDictionaryFromJSONString(jsonString: dataString!)
//            print(dict)
//        }
//        task.resume()
//    }
//    public func test(name:String)->String{
//        return "my name is \(name)"
//    }
}
