//
//  Db.swift
//  OrderFood
//
//  Created by ThanhThuy on 13/08/2022.
//

import Foundation
import SQLite

//class Database {
//    static let shared = Database()
//    public let connection : Connection?
//    public let dataBaseFileName = "sqliteFood.sqlite3"
//
//    private init(){
//        let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
//        do {
//            connection = try Connection("\(dbPath)/(dataBaseFileName)")
//        }catch {
//            connection = nil
//            let err = error as NSError
//            print("err connection \(err.userInfo)")
//        }
//
//
//    }
//}

class SQLDataBase {
    static let sharedInstance = SQLDataBase()
    var database : Connection?
    private init() {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("foodList").appendingPathExtension("sqlite3")
            database = try Connection(fileUrl.path)
        }catch {
            print("table already exists \(error)")
        }
    }
    func createTable() {
        entityFood.createTable()
    }
    
   
}
