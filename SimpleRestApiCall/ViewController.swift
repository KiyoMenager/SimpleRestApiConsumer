//
//  ViewController.swift
//  SimpleRestApiCall
//
//  Created by Kiyoaki Menager on 09/06/2016.
//  Copyright © 2016 OptiCargo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        TodoApiAlamofire.get()
//        TodoApiAlamofire.post()
//        TodoApiAlamofire.delete()
        
        // MARK: GET
        // Get first todo
        Todo.todoByID(1) { result in
            guard result.error == nil else {
                // got an error in getting the data, need to handle it
                print("error calling POST on /todos/")
                print(result.error)
                return
            }
            guard let todo = result.value else {
                print("error calling POST on /todos/: result is nil")
                return
            }
            // success
            print(todo.description())
            print(todo.title)
        }
        
        
        // MARK: POST
        // Create new todo
        guard let newTodo = Todo(aTitle: "Frist todo", anId: nil, anUserId: 1, aCompletedStatus: 0) else {
            print("error: newTodo isn't a Todo")
            return
        }
        newTodo.save { result in
            guard result.error == nil else {
                // got an error in getting the data, need to handle it
                print("error calling POST on /todos/")
                print(result.error)
                return
            }
            guard let todo = result.value else {
                print("error calling POST on /todos/: result is nil")
                return
            }
            // success!
            print(todo.description())
            print(todo.title)
        }

    }


}

