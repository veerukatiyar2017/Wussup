//
//  amazoneImageManager.swift
//  MagicoMoney
//
//  Created by mac190 on 03/07/17.
//  Copyright © 2017 MagicMoney. All rights reserved.
//

import UIKit
import AWSS3
import AWSDynamoDB
import AWSSQS
import AWSSNS
import AWSCognito

let amazonImageManager = AmazonImageManager.sharedInstance

class AmazonImageManager {
    
    static let sharedInstance = AmazonImageManager()
    let instance = AWSS3TransferManager.default()
    
    
    func uploadImageonS3(image:UIImage, index: Int = -1, isHudRequired: Bool = true, url onCompletion: @escaping (_ success: Bool, _ uploadURL: String) -> Void) {
        
        let strImageName = self.getUniqueImageNameWith(index: index)
        saveImageForUploadOnAmazonS3(image: image, imageName: strImageName)
        
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        uploadRequest?.bucket = AMAZON_S3_BUCKET_NAME
        uploadRequest?.key = strImageName
        
        let imagePathURL =  amazonImageManager.getImagePathFromDocumentDirectoryForDefaultAmazonS3(imageName: strImageName)
        
        uploadRequest?.body = imagePathURL
        uploadRequest?.contentType = "image/png"
        //uploadRequest.contentLength = [NSNumber numberWithInteger:imageData.length];
         Utill.printInTOConsole(printData:"Image Path : \(imagePathURL)")
        
        if isHudRequired {
            Utill.showProgressHud()
        }
        instance.upload(uploadRequest!).continueWith(executor: AWSExecutor.mainThread(), block: { (task:AWSTask<AnyObject>) -> Any? in
            if isHudRequired {
                Utill.hideProgressHud()
            }
            if let error = task.error as NSError? {
                
                if error.domain == AWSS3TransferManagerErrorDomain, let code = AWSS3TransferManagerErrorType(rawValue: error.code) {
                    switch code {
                    case .cancelled, .paused:
                        break
                    default:
                         Utill.printInTOConsole(printData:"Error uploading: \(String(describing: uploadRequest?.key)) Error: \(error.localizedDescription)")
                    }
                } else {
                      Utill.printInTOConsole(printData:"Error uploading: \(String(describing: uploadRequest?.key)) Error: \(error.localizedDescription)")
                }
                onCompletion(false, error.localizedDescription)
            }else{
                if (task.result != nil) {
                    
                    // The file uploaded successfully.
                    let finalURL = "\(AMAZON_URL)\(strImageName)"
                      Utill.printInTOConsole(printData:"Uploaded URL: \(finalURL)")
                    
                    self.removeFile(strImageName: strImageName)
                    onCompletion(true, finalURL)
                    
                }
                if ((task.error) != nil) {
                    Utill.printInTOConsole(printData:"error: \(task.error.debugDescription )")
                    onCompletion(false, task.error.debugDescription)
                }
                
            }
            return nil
        })
    }
    
    func removeImage() {
        /*
        let removeRequest = AWSS3()
        let deleteObjectRequest = AWSS3DeleteObjectRequest()
        removeRequest.bucket = "yourBucketName"
        removeRequest.key = "yourFileName"
        removeRequest.deleteObject(removeRequest).continueWithBlock { (task:AWSTask) -> AnyObject? in
            if let error = task.error {
                  Utill.printInTOConsole(printData:"Error occurred: \(error)")
                return nil
            }
              Utill.printInTOConsole(printData:"Deleted successfully.")
            return nil
        }
 */
    }
    
    func cancelAllTasks() {
        instance.cancelAll()
    }
    
    func getUniqueImageName() -> String{
        
        //ProfilePic__03072017_71128.png
        
        let dateString =  "\(Date().timeIntervalSinceNow)"
        let string = "ProfilePic_\(dateString).\(Key.pngKey)"
          Utill.printInTOConsole(printData:"string ========== \(string)")
        
        return string
    }
    
    func getUniqueImageNameWith(index: Int) -> String{
        
        var dateString =  "\(Date().timeIntervalSince1970)"
        dateString = dateString.replacingOccurrences(of: ".", with: "_")
        let string = "ProfilePic_\(dateString + index.toString()).\(Key.pngKey)"
          Utill.printInTOConsole(printData:"string ========== \(string)")
        
        return string
    }
    
    
    func saveImageForUploadOnAmazonS3(image:UIImage, imageName:String) {
        
        if let dataFullSize = UIImageJPEGRepresentation(image, 0.5) {
            
            let fullSizeFileName = getDocumentsDirectory().appendingPathComponent(imageName)
            try? dataFullSize.write(to: fullSizeFileName)
        }
    }
    
    func getImagePathFromDocumentDirectoryForDefaultAmazonS3(imageName: String) -> URL {
        
        let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent(imageName)
        if FileManager.default.fileExists(atPath: imagePAth){
            let fileURL = URL.init(fileURLWithPath: imagePAth, isDirectory: false)
            return fileURL
        }
        return URL(fileURLWithPath: "")
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func getDirectoryPath() -> String {
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func removeFile(strImageName:String){
        
        let urlImage =  self.getImagePathFromDocumentDirectoryForDefaultAmazonS3(imageName: strImageName)
        try? FileManager.default.removeItem(at: urlImage)
        
    }
    
}
