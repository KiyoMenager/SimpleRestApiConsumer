//
//  Todo.swift
//  SimpleRestApiCall
//
//  Created by Kiyoaki Menager on 09/06/2016.
//  Copyright © 2016 OptiCargo. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public protocol ResponseJSONObjectSerializable {
    init?(json: SwiftyJSON.JSON)
}

class Todo: ResponseJSONObjectSerializable {
    var title: String?
    var id: Int?
    var userId: Int?
    var completed: Int?
    
    required init?(aTitle: String?, anId: Int?, anUserId: Int?, aCompletedStatus: Int?) {
        self.title = aTitle
        self.id = anId
        self.userId = anUserId
        self.completed = aCompletedStatus
    }
    
    required init?(json: SwiftyJSON.JSON) {
        self.title = json["title"].string
        self.id = json["id"].int
        self.userId = json["userId"].int
        self.completed = json["completed"].int
    }
    
    func description() -> String {
        return "ID: \(self.id)" +
            "User ID: \(self.userId)" +
            "Title: \(self.title)\n" +
            "Completed: \(self.completed)\n"
    }
    
    func toJSON() -> [String: AnyObject] {
        var json = [String: AnyObject]()
        if let title = title {
            json["title"] = title
        }
        if let id = id {
            json["id"] = id
        }
        if let userId = userId {
            json["userId"] = userId
        }
        if let completed = completed {
            json["completed"] = completed
        }
        
        return json
    }
    
    // MARK: URLs
    
    class func endpointForID(id: Int) -> String {
        return "http://jsonplaceholder.typicode.com/todos/\(id)"
    }
    
    class func endpointForTodos() -> String {
        return "http://jsonplaceholder.typicode.com/todos/"
    }
    
    // MARK: API Calls
    
    class func todoByID(id: Int, completionHandler: (Result<Todo, NSError>) -> Void) {
        Alamofire.request(.GET, Todo.endpointForID(id))
            .responseObject { response in
                completionHandler(response.result)
        }
    }
    
    // POST / Create
    func save(completionHandler: (Result<Todo, NSError>) -> Void) {
        let fields = self.toJSON()
        Alamofire.request(.POST, Todo.endpointForTodos(), parameters: fields, encoding: .JSON)
            .responseObject { (response: Response) in
                completionHandler(response.result)
        }
    }
}

extension Alamofire.Request {
    public func responseObject<T: ResponseJSONObjectSerializable>(completionHandler: (Response<T, NSError>) -> Void) -> Self {
        let responseSerializer = ResponseSerializer<T, NSError> { request, response, data, error in
            guard error == nil else {
                return .Failure(error!)
            }
            
            guard let responseData = data else {
                let failureReason = "Array could not be serialized because input data was nil."
                let userInfo: Dictionary<NSObject, AnyObject> = [NSLocalizedFailureReasonErrorKey: failureReason, Error.UserInfoKeys.StatusCode: response!.statusCode]
                let error = NSError(domain: Error.Domain, code: Error.Code.DataSerializationFailed.rawValue, userInfo: userInfo)
                
                return .Failure(error)
            }
            
            let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, responseData, error)
        
            if result.isSuccess {
                if let value = result.value {
                    let json = SwiftyJSON.JSON(value)
                    if let newObject = T(json: json) {
                        return .Success(newObject)
                    }
                }
            }
            
            let failureReason = "JSON could not be converted to object"
            let userInfo: Dictionary<NSObject, AnyObject> = [NSLocalizedFailureReasonErrorKey: failureReason, Error.UserInfoKeys.StatusCode: response!.statusCode]
            let error = NSError(domain: Error.Domain, code: Error.Code.DataSerializationFailed.rawValue, userInfo: userInfo)
            return .Failure(error)
        }
        
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
    
}