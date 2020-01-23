//
//  FacebookProfileViewController.swift
//  FacebookIntegraionMain
//
//  Created by R Shantha Kumar on 1/21/20.
//  Copyright © 2020 R Shantha Kumar. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import FacebookShare

class FacebookProfileViewController: UIViewController,SharingDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
  let imagePicker = UIImagePickerController()
    
    func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
        print("sharing succes ")
    }
    
    func sharer(_ sharer: Sharing, didFailWithError error: Error) {
        print("sharing fail")
    }
    
    func sharerDidCancel(_ sharer: Sharing) {
        print("sharing cancel")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var imageview: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        
        let graphRequest = GraphRequest(graphPath: "/me", parameters: ["fields": "id, name, first_name, last_name, email, birthday, age_range, picture.width(400), gender"], tokenString: AccessToken.current?.tokenString, version: Settings.defaultGraphAPIVersion, httpMethod: .get)
        
       let connction = GraphRequestConnection()
        
        connction.add(graphRequest) { (connction, value, error) in
            
            if let reaponse = value as? [String:Any]{
                
             let fullName = reaponse["name"] as! String
               
                let profilepic = reaponse["picture"] as! [String:Any]
                let profileData = profilepic["data"] as! [String:Any]
                let profileURL = profileData["url"] as! String
                do{
                   
                let image = URL(string: profileURL)
                    
                   
                    
                    self.imageview.image = UIImage(data: try Data(contentsOf: image!))
                    
                    self.nameLabel.text = fullName
                }catch{
                    
                    print("image not getting")
                }
                
                print(fullName)
                
            }
            
            
        }
        
        connction.start()
        
        
        
    }
 
    
    @IBAction func linkShare(_ sender: Any) {
         let content = ShareLinkContent()
        content.contentURL = URL(string: "https://shanth923.fb.com/")!
        content.quote = "good content"
       
        let sharedialog = ShareDialog(fromViewController: self, content: content, delegate: self)
        
        sharedialog.mode = .automatic
        sharedialog.show()
    }
    
    @IBAction func photoShare(_ sender: Any) {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = ["public.image"]
        
        present(imagePicker, animated: true, completion: nil)
        
        
        
    }
    
    @IBAction func videoShare(_ sender: Any) {
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        
       if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            
        }
        if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            
        let url = URL(string: "fb://")!
            
            if UIApplication.shared.canOpenURL(url){
                
                let photo = SharePhoto(image: originalImage, userGenerated: true)
           let content = SharePhotoContent()
                
                content.photos = [photo]
                let shareDialogs = ShareDialog(fromViewController: self, content: content, delegate: self)
                
                shareDialogs.mode = .automatic
                shareDialogs.show()
         dismiss(animated: true, completion: nil)
                
            }else{
                
                print("app not inastalled")
                
            }
            
            
        
        
        
        }else if let videoURL = info[UIImagePickerController.InfoKey.referenceURL] as? URL{
            
        
        
        let url2 = URL(string: "fb://")!
        
        if UIApplication.shared.canOpenURL(url2){
            
            
         let video = ShareVideo(videoURL: videoURL)
            
            
            let myContent = ShareVideoContent()
            myContent.video = video
            let sharingDialog = ShareDialog(fromViewController: self, content: myContent, delegate: self)
            sharingDialog.mode = .automatic
            sharingDialog.show()
            
            
            }else
        {
            print("app not installed")
            }
            
        }
        
       dismiss(animated: true, completion: nil)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
