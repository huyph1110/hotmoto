//
//  Services.swift
//  Hey_Go
//
//  Created by Lê Dũng on 5/19/17.
//  Copyright © 2017 NCSoft. All rights reserved.
//

import UIKit
import Alamofire

class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}


class APIResponse: Mi
{
    
    var error = true;
    var messageStatus = "";
    var message = "";
    var originalReponse : Any!
    var arrayResponse : Array<Any>! = []
    var dictionaryResponse : NSDictionary!  = NSDictionary.init()
    
}


let  services = Services.sharedInstance()
class Services: NSObject {
    static var instance: Services!
    var session : SessionManager = Alamofire.SessionManager.default

    class func sharedInstance() -> Services
    {
        if(self.instance == nil)
        {
            self.instance = (self.instance ?? Services())
        }
        return self.instance
    }
    func request(api : APIFunction, method : HTTPMethod, objects : [Dictionary <String, AnyObject>], success :@escaping ((APIResponse)->Void), failure :@escaping ((String)->Void)){
        if Connectivity.isConnectedToInternet == false {
            DispatchQueue.global(qos: .background).async {
                failure("Xin vui lòng kiểm tra lại đường truyền")
            }
            return
            
        }
        let data = dataRequest(api: api, parameters: objects)
    
        var strURL = ""
        strURL = servicesConfig.url.appending(api.rawValue)
        var mutableURLRequest = URLRequest(url: URL.init(string: strURL)!)
        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Accept")

        mutableURLRequest.httpMethod = method.rawValue
        mutableURLRequest.httpBody = data
        Alamofire.request(mutableURLRequest as URLRequestConvertible).responseJSON { (response) in
            DispatchQueue.global(qos: .background).async {
                let apiResponse = self.processReponse(response: response)
                if (apiResponse.error == false) {
                    success(apiResponse)
                }
                else {
                    failure(apiResponse.message)
                }
            }
        }
        
    }
    
    func request(api : APIFunction, method : HTTPMethod, param : Dictionary <String, AnyObject>, success :@escaping ((APIResponse)->Void), failure :@escaping ((String)->Void))
    {
        
        if Connectivity.isConnectedToInternet == false {
            DispatchQueue.global(qos: .background).async {
                failure("Xin vui lòng kiểm tra lại đường truyền")
            }
            return
        }
        
        weak var weakself = self
        let dataRequest = prepareRequest(api: api, parameter: param)
        
        var headerObject = HTTPHeaders()
        headerObject = ["Content-Type": "application/json", "Accept": "application/json"]
      
        var encoding : ParameterEncoding = JSONEncoding.default
        
        if(method == .get)
        {
            encoding = URLEncoding.default
        }
        

        Alamofire.request(dataRequest.0, method: method, parameters: dataRequest.1, encoding: encoding, headers: headerObject)
            .responseJSON { response in

                DispatchQueue.global(qos: .background).async {
                    let apiResponse = weakself?.processReponse(response: response)
                    if (apiResponse?.error == false) {
                        success(apiResponse!)
                    }
                    else {
                        failure((apiResponse?.message)!)
                    }
                }
        }
    }
   
    func processReponse(response : DataResponse<Any>) -> APIResponse
    {
        let res = APIResponse()
        res.error = !response.result.isSuccess
        if(response.result.isSuccess)
        {
            if response.result.value is Array<Any> {
                res.arrayResponse = response.result.value as! Array<Any>
            }
            if response.result.value is String {
                res.message = response.result.value as! String

            }
            if response.result.value is Dictionary<String, Any> {
                let dic = response.result.value as! Dictionary <String, Any>
                res.error = dic.keys.first == "error"
                res.message = dic[dic.keys.first!] as! String
            }

            return res

        }
        res.message = "Có lỗi service"
        return res

    }
    
    func prepareRequest(api : APIFunction, parameter : Dictionary <String,AnyObject>) -> (String, Parameters)
    {
        var endParameter : Parameters = [:]
        for  (k,v) in  parameter
        {

            endParameter[k] = v
        }
        return (servicesConfig.url.appending(api.rawValue),endParameter)
    }
    

    
    func dataRequest(api : APIFunction, parameters : [Dictionary <String,AnyObject>]) -> Data
    {
        var data = Data()
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters as [NSDictionary], options: JSONSerialization.WritingOptions.prettyPrinted)
            data = jsonData
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                print(JSONString)
            }
        } catch {
            
        }
        return data
        
    }
    
    func requestPostObjects(api : APIFunction, bodyData : Data, success :@escaping ((APIResponse)->Void), failure :@escaping ((String)->Void)) {
        
        var strURL = ""
        strURL = servicesConfig.url.appending(api.rawValue)
        var mutableURLRequest = URLRequest(url: URL.init(string: strURL)!)
        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        mutableURLRequest.httpMethod = "POST"
        mutableURLRequest.httpBody = bodyData
        Alamofire.request(mutableURLRequest as URLRequestConvertible).responseJSON { (response) in
            DispatchQueue.global(qos: .background).async {
                let apiResponse = self.processReponse(response: response)
                if (apiResponse.error == false) {
                    success(apiResponse)
                }
                else {
                    failure(apiResponse.message)
                }
            }
        }
    
    }
    
    
}
