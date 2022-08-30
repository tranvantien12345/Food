//
//  FoodEntity.swift
//  OrderFood
//
//  Created by ThanhThuy on 13/08/2022.
//

import Foundation
import SQLite


class entityFood {
    
    static var totalAll = 0

    static var table = Table("tableFood")
    
    static var id = Expression<Int>("id")
    static let nameFood = Expression<String>("nameFood")
    static let price = Expression<Int>("price")
    static let describe = Expression<String>("describe")
    static let imageFood = Expression<String>("imageFood")
    static let amount = Expression<Int>("amount")
     
    static func createTable () {
        guard let database = SQLDataBase.sharedInstance.database
        else
        {
            print("Connection erro")
            return
        }
        do {
            try  database.run(table.create(ifNotExists: true) {table in
                table.column(self.id, primaryKey: true)
                table.column(self.nameFood)
                table.column(self.price)
                table.column(self.describe)
                table.column(self.imageFood)
                table.column(amount)
            })
        }catch {
            print("create table error")
        }
    }
    
    
    // insert table
    static func insertRow (_ foodValues: listFood) {
        guard let database = SQLDataBase.sharedInstance.database
        else
        {
            print("Connection error")
            return
        }
        do {
            try database.run(table.insert(self.id <- foodValues.id,
                                          self.nameFood <- foodValues.nameFood,
                                          self.price <- foodValues.price,
                                          self.describe <- foodValues.describe,
                                          self.imageFood <- foodValues.imageFood,
                                          self.amount <- foodValues.amount))
            print("insert success")
        } catch {
            let err = error as NSError
            print("insert table error \(err)")
        }
        
    }
    
    // get list food
    static func getListRow () -> [listFood]? {
        guard let database = SQLDataBase.sharedInstance.database
        else
        {
            print("get list erre")
            return nil
        }
        var foodArray = [listFood]()
        table = table.order(id.desc)
        do {
            for food in try database.prepare(table) {
                let idValue = food[id]
                let nameFoodValue = food[nameFood]
                let priceValue = food[price]
                let describeValue = food[describe]
                let imageFoodValue = food[imageFood]
                let amountValue = food[amount]
                
                let foodObject = listFood(id: idValue, nameFood: nameFoodValue, price: priceValue, describe: describeValue, imageFood: imageFoodValue, amount: amountValue)
                
                foodArray.append(foodObject)
                
                print("id : \(idValue), nameFood: \(nameFoodValue), mô tả \(describeValue), aomount \(amountValue), prince \(priceValue)")
                
                
            }
            print("get list success")
        }catch {
            print("get list erro \(error)")
        }
        return foodArray
    }
    
    
    // check food
    
    static func checkFood (idFood: Int)  -> [listFood]?{
        guard let database = SQLDataBase.sharedInstance.database
        else
        {
            print("check list erre")
            return nil
        }
        var foodArrayCheck = [listFood]()
//        table = table.order(id.desc)
        

        
        do {
            for checkFood in try database.prepare(table.filter(self.id == idFood)) {
                let idValue = checkFood[id]
                let nameFoodValue = checkFood[nameFood]
                let priceValue = checkFood[price]
                let describeValue = checkFood[describe]
                let imageFoodValue = checkFood[imageFood]
                let amountValue = checkFood[amount]
                
                let foodObject = listFood(id: idValue, nameFood: nameFoodValue, price: priceValue, describe: describeValue, imageFood: imageFoodValue, amount: amountValue)
                
                foodArrayCheck.append(foodObject)
                
                print("id : \(idValue), nameFood: \(nameFoodValue)")
                
               
            }
            print("check list success")

        }catch {
            print("check list erro \(error)")
        }
        return foodArrayCheck
        

    }
    // update food
    
    static func updateFoodAmount(amountUpdate: Int!, idUpdate: Int!) {
        guard let database = SQLDataBase.sharedInstance.database
        else
        {
            print("Uodate data error")
            return
        }
        let foodUpdateAomount = self.table.filter(self.id == idUpdate).limit(1)
        do {
            if ((try  database.run(foodUpdateAomount.update(self.amount <- amountUpdate))) != 0) {
                print("update success")
                
            }
        } catch {
            print("update error \(error)")
        }
    }
    
    
    // delete food
    static func deleteFood (idFood : Int!) {
        guard let database =  SQLDataBase.sharedInstance.database
        else
        {
            print("delete error")
            return
        }
        
        let delete = self.table.filter(self.id == idFood).limit(1)
        do {
            try database.run(delete.delete())
            print("delete succsess")
            
        } catch {
            print("delete error \(error)")
        }
    }

    
}

