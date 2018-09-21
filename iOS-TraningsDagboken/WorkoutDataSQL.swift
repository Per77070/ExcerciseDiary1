
//
//  RestaurantDataSQL.swift
//  RestaurangGuiden
//
//  Created by Sten R Kaiser on 2018-09-07.
//  Copyright © 2018 Kaiser&Kaiser. All rights reserved.
//

import UIKit
//import Firebase

class WorkoutDataSQL {
    
    struct Workout {
        var id = ""
        var name = ""
        var address = ""
        var date = ""
        var description = ""
        var image = ""
        var thumb = ""
    }
    
    var workoutArray:[Workout] = []
    var oneWorkout = Workout()
    var dbPath = ""
    
    init() {
        let docPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        dbPath = docPath[0].appendingPathComponent("WorkoutDB.db").path
        
        if !FileManager.default.fileExists(atPath: dbPath) {
            if let bundlePath = Bundle.main.resourceURL?.appendingPathComponent("WorkoutDB.db").path {
                do {
                    try FileManager.default.copyItem(atPath: bundlePath, toPath: dbPath)
                    print("Databas kopierad till : \(dbPath)")
                } catch {
                    print("Kan inte kopiera, Error:",error)
                }
            }
        } else {
            print("Databas finns: \(dbPath)")
        }
    }
    
    func loadDB() {
        let database = FMDatabase(path: dbPath)
        if database.open() {
            do {
                let resSet = try database.executeQuery("SELECT * from workoutDBtable", values: nil)
                while resSet.next() {
                    var newRest = Workout()
                    newRest.id = resSet.string(forColumn:"id") ?? ""
                    newRest.name = resSet.string(forColumn:"name") ?? ""
                     
                        
                    self.workoutArray.append(newRest)
                }
            }catch{
                print(error)
            }
            database.close()
            
        }
    }
    
    func loadOne(restId:String) {
        let database = FMDatabase(path: dbPath)
        if database.open() {
            do {
                let resSet = try database.executeQuery("SELECT * from workoutDBtable WHERE id=?", values: [restId])
                while resSet.next() {
                    self.oneWorkout.name = resSet.string(forColumn:"name") ?? ""
                    self.oneWorkout.adress = resSet.string(forColumn:"address") ?? ""
                    self.oneWorkout.date = resSet.string(forColumn:"date") ?? ""
                    self.oneWorkout.description = resSet.string(forColumn:"description") ?? ""
                    
                    
                    if let imgData = resSet.data(forColumn:"img") {
                        self.oneWorkout.img = UIImage(data:imgData)
                    }
                }
            }catch{
                print(error)
            }
            database.close()
        }
    }
    
    func uploadData() {
        var imgJpeg:Data?
        var thumbJpeg:Data?
         {
            UIGraphicsBeginImageContext(CGSize(width: 800, height: 475))
            var ratio = Double(image.size.width/image.size.height)
            var scaleWidth = 800.0
            var scaleHeight = 800.0/ratio
            var offsetX = 0.0
            var offsetY = (scaleHeight-475)/2.0
            image.draw(in: CGRect(x: -offsetX, y: -offsetY, width: scaleWidth, height: scaleHeight))
            if let largeImg = UIGraphicsGetImageFromCurrentImageContext(),  let jpegData = UIImageJPEGRepresentation(largeImg, 0.7) {
                imgJpeg = jpegData
            }
            UIGraphicsEndImageContext()
            
            UIGraphicsBeginImageContext(CGSize(width: 80, height: 80))
            ratio = Double(image.size.width/image.size.height)
            scaleWidth = ratio*80.0
            scaleHeight = 80.0
            offsetX = (scaleWidth-80)/2.0
            offsetY = 0.0
            image.draw(in: CGRect(x: -offsetX, y: -offsetY, width: scaleWidth, height: scaleHeight))
            if let thumb = UIGraphicsGetImageFromCurrentImageContext(),  let jpegData = UIImageJPEGRepresentation(thumb, 0.7) {
                thumbJpeg = jpegData
            }
            UIGraphicsEndImageContext()
        }
        
        let database = FMDatabase(path: dbPath)
        if database.open() {
            do {
                if let imgJpeg = imgJpeg, let thumbJpeg = thumbJpeg {
                    try database.executeUpdate("INSERT INTO workoutDBtable(name, address, date, description, img, thumb) VALUES(?,?,?,?,?,?)", values: [oneWorkout.name, oneWorkout.adress, oneWorkout.date, oneWorkout.description,oneWorkout.image,oneWorkout.thumb])
                }
            }catch{
                print(error)
            }
            database.close()
        }
    }
    
}

