//
//  TodoApiAlamofire.swift
//  SimpleRestApiCall
//
//  Created by Kiyoaki Menager on 09/06/2016.
//  Copyright © 2016 OptiCargo. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class TodoApiAlamofire {
    static let todoEndpoint: String = "http://jsonplaceholder.typicode.com/todos"
    static let todoEndpointWithId: String = "http://jsonplaceholder.typicode.com/todos/1"
    
    static func get() {
        Alamofire.request(.GET, todoEndpointWithId)
            .responseJSON { response in
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling GET on /todos/1")
                    print(response.result.error!)
                    return
                }
                
                if let value = response.result.value {
                    // handle the results as JSON, without a bunch of nested if loops
                    let todo = JSON(value)
                    // now we have the results, let's just print them though a tableview would definitely be better UI:
                    print("The todo is: " + todo.description)
                    if let title = todo["title"].string {
                        print("The title is: " + title)
                    } else {
                        print("error parsing /todos/1")
                    }
                }
            }
    }
    
    static func post() {
        let newTodo = ["title": "Frist Psot", "completed": 0, "userId": 1]
        
        Alamofire.request(.POST, todoEndpoint, parameters: newTodo, encoding: .JSON)
            .responseJSON { response in
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling POST on /todos/1")
                    print(response.result.error!)
                    return
                }
                
                if let value = response.result.value {
                    // handle the results as JSON, without a bunch of nested if loops
                    let todo = JSON(value)
                    // now we have the results, let's just print them though a tableview would definitely be better UI:
                    print("The todo is: " + todo.description)
                    if let title = todo["title"].string {
                        print("The title is: " + title)
                    } else {
                        print("error parsing /todos/1")
                    }
                }
        }
    }
    
    static func delete() {
        Alamofire.request(.DELETE, todoEndpointWithId)
            .responseJSON { response in
                if let error = response.result.error {
                    // got an error while deleting, need to handle it
                    print("error calling DELETE on /todos/1")
                    print(error)
                } else {
                    print("delete ok")
                }
        }
    }
}