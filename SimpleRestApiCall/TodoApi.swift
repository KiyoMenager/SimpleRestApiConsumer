//
//  TodoApi.swift
//  SimpleRestApiCall
//
//  Created by Kiyoaki Menager on 09/06/2016.
//  Copyright © 2016 OptiCargo. All rights reserved.
//

import Foundation

class TodoApiDirty {
    
    static func get() {
        let todoEndpoint: String = "http://jsonplaceholder.typicode.com/todos/1"
        
        guard let url = NSURL(string: todoEndpoint) else {
            print("Error: cannnot create URL")
            return
        }
        
        let urlRequest = NSURLRequest(URL: url)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        let task = session.dataTaskWithRequest(urlRequest) { data, response, error in
            
            guard error == nil else {
                print("error calling GET on /todos/1")
                print(error)
                return
            }
            
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            do {
                guard let todo = try NSJSONSerialization.JSONObjectWithData(responseData, options: []) as? [String: AnyObject] else {
                    print("error trying to convert data to JSON")
                    return
                }
                
                // now we have the todo, let's just print it to prove we can access it
                print("The todo is: " + todo.description)
                
                // the todo object is a dictionary
                // so we just access the title using the "title" key
                // so check for a title and print it if we have one
                guard let todoTitle = todo["title"] as? String else {
                    print("Could not get todo title from JSON")
                    return
                }
                
                print("The title is: " + todoTitle)
            } catch {
                print("error trying to convert data to JSON")
                return
            }
        }
        
        task.resume()
    }
    
    static func post() {
        let todosEndpoint: String = "http://jsonplaceholder.typicode.com/todos"
        guard let todosURL = NSURL(string: todosEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        let todosUrlRequest = NSMutableURLRequest(URL: todosURL)
        todosUrlRequest.HTTPMethod = "POST"
        
        
        // Create a body
        let newTodo = ["title": "Frist todo", "completed": false, "userId": 1]
        let jsonTodo: NSData
        do {
            jsonTodo = try NSJSONSerialization.dataWithJSONObject(newTodo, options: [])
            todosUrlRequest.HTTPBody = jsonTodo
        } catch {
            print("Error: cannot create JSON from todo")
            return
        }
        
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)

        
        let task = session.dataTaskWithRequest(todosUrlRequest) { data, response, error in
            
            guard error == nil else {
                print("error calling GET on /todos/1")
                print(error)
                return
            }
            
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            do {
                guard let todo = try NSJSONSerialization.JSONObjectWithData(responseData, options: []) as? [String: AnyObject] else {
                    print("error trying to convert data to JSON")
                    return
                }
                
                // now we have the todo, let's just print it to prove we can access it
                print("The todo is: " + todo.description)
                
                // the todo object is a dictionary
                // so we just access the title using the "title" key
                // so check for a title and print it if we have one
                guard let todoTitle = todo["title"] as? String else {
                    print("Could not get todo title from JSON")
                    return
                }
                
                print("The title is: " + todoTitle)
            } catch {
                print("error trying to convert data to JSON")
                return
            }
        }
        
        task.resume()

    }
    
    static func delete() {
        let firstTodoEndpoint: String = "http://jsonplaceholder.typicode.com/todos/1"
        let firstTodoUrlRequest = NSMutableURLRequest(URL: NSURL(string: firstTodoEndpoint)!)
        firstTodoUrlRequest.HTTPMethod = "DELETE"
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        let task = session.dataTaskWithRequest(firstTodoUrlRequest) {
            (data, response, error) in
            guard let _ = data else {
                print("error calling DELETE on /todos/1")
                return
            }
            
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            do {
                guard let todo = try NSJSONSerialization.JSONObjectWithData(responseData, options: []) as? [String: AnyObject] else {
                    print("error trying to convert data to JSON")
                    return
                }
                
                // now we have the todo, let's just print it to prove we can access it
                print("The todo is: " + todo.description)
                
                // the todo object is a dictionary
                // so we just access the title using the "title" key
                // so check for a title and print it if we have one
                guard let todoTitle = todo["title"] as? String else {
                    print("Could not get todo title from JSON")
                    return
                }
                
                print("The title is: " + todoTitle)
            } catch {
                print("error trying to convert data to JSON")
                return
            }

        }
        task.resume()
    }
}