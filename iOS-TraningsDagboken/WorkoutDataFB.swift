



import UIKit
import Firebase

protocol DataDelegate {
    func laddaTabell()
}

protocol WorkoutDelegate {
    func setRestData()
    //    func setRestData(description:[String:Any])
    //    func setRestImg(img:UIImage)
}



class WorkoutDataFB {
    
    var dataDel: DataDelegate?
    var restDel: WorkoutDelegate?
    
    struct Workout {
        var id = ""
        var name = ""
        var date = ""
        var address = ""
        var description = ""
        var imgUrl = ""
        var img:UIImage?
        var thumbUrl = ""
        var thumb:UIImage?
        
        
        
        
    }
    
    var workoutArray:[Workout] = []
    var oneWorkout = Workout()
    
    init() {
    }
    
    func loadDB() {
        let db = Firestore.firestore()
        db.collection("").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                guard let qSnapshot = querySnapshot else {return}
                for document in qSnapshot.documents {
                    var newRest = Workout()
                    newRest.id = document.documentID
                    newRest.name = document.data()["name"] as? String ?? ""
                    newRest.thumbUrl = document.data()["thumb"] as? String ?? ""
                    self.workoutArray.append(newRest)
                }
                
                self.dataDel?.laddaTabell()
                self.loadThumbs()
            }
        }
    }
    
    func loadThumbs() {
        let storageRef = Storage.storage().reference()
        for (index,var newRest) in workoutArray.enumerated() {
            let imgRef = storageRef.child(newRest.thumbUrl )
            imgRef.getData(maxSize: 1024*1024) { data, error in
                if let error = error {
                    print(error)
                } else {
                    if let thumbData = data {
                        newRest.thumb = UIImage(data: thumbData)
                        self.workoutArray[index] = newRest
                    }
                }
                self.dataDel?.laddaTabell()
            }
        }
    }
    
    
    func loadOne(restId:String) {
        let db = Firestore.firestore()
        let docRef = db.collection("Restaurants").document(restId)
        
        docRef.getDocument { (document, error) in
            if let error = error {
                print(error)
            }
            if let document = document, document.exists {
                if let dataDescription = document.data() {
                    
                    self.oneWorkout.name = dataDescription["name"] as? String ?? ""
                    self.oneWorkout.address = dataDescription["address"] as? String ?? ""
                    self.oneWorkout.imgUrl = dataDescription["img"] as? String ?? ""
                    self.oneWorkout.description = dataDescription["description"] as? String ?? ""
                    self.oneWorkout.date = dataDescription["date"] as? String ?? ""
                    self.oneWorkout.thumbUrl = dataDescription["thumb"] as? String ?? ""
                    
                    self.loadImage(imgUrl: self.oneWorkout.imgUrl )
                    
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func loadImage(imgUrl:String) {
        let storageRef = Storage.storage().reference()
        let imgRef = storageRef.child(imgUrl)
        imgRef.getData(maxSize: 1024*1024) { data, error in
            if let error = error {
                print(error)
            } else {
                if let imgData = data {
                    if let restImg = UIImage(data: imgData) {
                        self.oneWorkout.img = restImg
                        self.restDel?.setRestData()
                    }
                }
            }
        }
    }
    
    
    func uploadData() {
        var imgName = oneWorkout.name.replacingOccurrences(of: " ", with: "_")
        imgName = imgName.replacingOccurrences(of: "&", with: "")
        imgName = imgName.lowercased()
        
        let db = Firestore.firestore()
        var dataDict = [
            "name": oneWorkout.name,
            "address": oneWorkout.address,
            "date": oneWorkout.date,
            "description": oneWorkout.description,
            "image": oneWorkout.imgUrl
            ] as [String : Any]
        
        if oneWorkout.img != nil {
            dataDict["img"] = imgName + ".jpg"
            dataDict["thumb"] = imgName + "_thumb.jpg"
        }
        
        db.collection("Restaurants").document().setData(dataDict) { err in
            if let err = err {
                print("Error: \(err)")
            } else {
                print("Dokument sparat")
                if self.oneWorkout.img != nil { self.uploadImage(imgName: imgName) }
            }
        }
    }
    
    
    func uploadImage(imgName:String) {
        if let image = oneWorkout.img {
            
            UIGraphicsBeginImageContext(CGSize(width: 800, height: 475))
            let ratio = Double(image.size.width/image.size.height)
            let scaleWidth = 800.0
            let scaleHeight = 800.0/ratio
            let offsetX = 0.0
            let offsetY = (scaleHeight-475)/2.0
            image.draw(in: CGRect(x: -offsetX, y: -offsetY, width: scaleWidth, height: scaleHeight))
            let largeImg = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            if let largeImg = largeImg, let jpegData = UIImageJPEGRepresentation(largeImg, 0.7) {
                let storageRef = Storage.storage().reference()
                let imgRef = storageRef.child(imgName+".jpg")
                
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpeg"
                
                imgRef.putData(jpegData, metadata: metadata) { (metadata, error) in
                    guard metadata != nil else {
                        print(error!)
                        return
                    }
                    print("image uploaded")
                    self.uploadThumb(imgName: imgName)
                }
            }
        }
    }
    
    func uploadThumb(imgName:String) {
        if let image = oneWorkout.img {
            UIGraphicsBeginImageContext(CGSize(width: 80, height: 80))
            let ratio = Double(image.size.width/image.size.height)
            let scaleWidth = ratio*80.0
            let scaleHeight = 80.0
            let offsetX = (scaleWidth-80)/2.0
            let offsetY = 0.0
            image.draw(in: CGRect(x: -offsetX, y: -offsetY, width: scaleWidth, height: scaleHeight))
            
            let thumb = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            if let thumb = thumb, let jpegData = UIImageJPEGRepresentation(thumb, 0.7) {
                let storageRef = Storage.storage().reference()
                let imgRef = storageRef.child(imgName+"_thumb.jpg")
                
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpeg"
                
                imgRef.putData(jpegData, metadata: metadata) { (metadata, error) in
                    guard metadata != nil else {
                        print(error!)
                        return
                    }
                    print("thumb uploaded")
                }
            }
        }
    }
    
}
