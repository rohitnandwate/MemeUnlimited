//
//  ViewController.swift
//  MemeUnlimited
//
//  Created by Nandwate, Rohit on 2/23/17.
//  Copyright © 2017 Nandwate, Rohit. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet var memeImageView: UIImageView!
    
    @IBOutlet var topToolbar: UIToolbar!
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var shareButton: UIBarButtonItem!
    @IBOutlet var cameraButton: UIBarButtonItem!
    @IBOutlet var topTextField: UITextField!
    @IBOutlet var bottomTextField: UITextField!    
    @IBOutlet var bottomToolbar: UIToolbar!
    
    let TOOLBAR_ALPHA: Float = 0.75
    
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        setShareButtonState()
        subscribeToKeyboardEvents()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeFromKeyboardEvents()
    }
    
    override func viewDidLoad() {
        topTextField.delegate = self
        bottomTextField.delegate = self
        showHideToolbars(alpha: TOOLBAR_ALPHA)
        setupTextFields()
    }
    
    // MARK: Image picker
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info[UIImagePickerControllerEditedImage] {
            memeImageView.image = editedImage as? UIImage
            print("Edited")
        } else if let orignalImage = info[UIImagePickerControllerOriginalImage] {
            memeImageView.image = orignalImage as? UIImage
            print("original")
        }
        setShareButtonState()
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Top toolbar buttons
    
    func generateMemedImage() -> UIImage {
        showHideToolbars(alpha: 0.0)
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        showHideToolbars(alpha: TOOLBAR_ALPHA)
        return memedImage
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        let memedImage: UIImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func cancelMeme(_ sender: Any) {
        let controller = UIAlertController(title: "Clear Current Meme", message: "Clear the meme editor", preferredStyle: .alert)
        controller.message = "This will clear all the current changes"
        
        let okAction = UIAlertAction(title: "Clear", style: UIAlertActionStyle.destructive) {
            action in
                self.memeImageView.image = nil
                self.resetTextFields()
                self.setShareButtonState()
                self.dismiss(animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            action in self.dismiss(animated: true, completion: nil)
        }
        
        controller.addAction(okAction)
        controller.addAction(cancelAction)
        self.present(controller, animated: true, completion: nil)
    }
    
    func setShareButtonState() {
        shareButton.isEnabled = memeImageView.image != nil
    }
    
    // MARK: Bottom toolbar button actions
    
    @IBAction func pickImageFromCamera(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true, completion: nil)
    }

    @IBAction func pickImageFromAlbum(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }

    // MARK: Manage views
    
    func showHideToolbars(alpha :Float) {
        bottomToolbar.alpha = 0.75
        topToolbar.alpha = 0.75
    }
    
    func resetTextFields () {
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
    }
    
    func setupTextFields() {
//        let memeTextAttributes:[String:Any] = [
//            NSStrokeColorAttributeName: UIColor.black,
//
//            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!]
//        
//        topTextField.defaultTextAttributes = memeTextAttributes
//        topTextField.textAlignment = .center
//        topTextField.text = "TOP"
//        
//        bottomTextField.defaultTextAttributes = memeTextAttributes
//        bottomTextField.textAlignment = .center
//        bottomTextField.text = "BOTTOM"
    }
    
    // MARK: Textfield delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
        return true
    }
    
    //MARK: keyboard events
    func keyboardWillShow(_ notification:Notification) {
        print("Origin X,Y BEFORE keyboard shows: \(view.frame.origin.x), \(view.frame.origin.y)")
        
        view.frame.origin.y -= getKeyboardHeight(notification)
        print("Origin X,Y AFTER keyboard shows: \(view.frame.origin.x), \(view.frame.origin.y)")
    }
    
    func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y += getKeyboardHeight(notification)
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardEvents() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
}

