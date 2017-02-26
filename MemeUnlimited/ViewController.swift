//
//  ViewController.swift
//  MemeUnlimited
//
//  Created by Nandwate, Rohit on 2/23/17.
//  Copyright © 2017 Nandwate, Rohit. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    // MARK: Outlets
    
    @IBOutlet var memeImageView: UIImageView!
    @IBOutlet var topToolbar: UIToolbar!
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var shareButton: UIBarButtonItem!
    @IBOutlet var cameraButton: UIBarButtonItem!
    @IBOutlet var topTextField: UITextField!
    @IBOutlet var bottomTextField: UITextField!    
    @IBOutlet var bottomToolbar: UIToolbar!
    
    let TOOLBAR_ALPHA: CGFloat = 0.75
    
    // MARK: Viewcontroller functions
    
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
        controller.completionWithItemsHandler = {
             type, ok, items, err in
            _ = Meme(orignalImage: self.memeImageView.image!, memedImage: memedImage, topText: self.topTextField.text!, bottomText: self.bottomTextField.text!)
            self.dismiss(animated: true, completion: nil)
        }
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

    
    // MARK: Textfield delegate functions

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
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification:Notification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
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
    
    
    // MARK: Manage views
    
    func showHideToolbars(alpha: CGFloat) {
        bottomToolbar.alpha = alpha
        topToolbar.alpha = alpha
    }
    
    func resetTextFields () {
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
    }
    
    func setShareButtonState() {
        shareButton.isEnabled = memeImageView.image != nil
    }
}

