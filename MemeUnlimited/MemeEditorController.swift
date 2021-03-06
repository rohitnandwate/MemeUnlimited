//
//  ViewController.swift
//  MemeUnlimited
//
//  Created by Nandwate, Rohit on 2/23/17.
//  Copyright © 2017 Nandwate, Rohit. All rights reserved.
//

import UIKit

class MemeEditorController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    // MARK: Outlets
    
    @IBOutlet var memeImageView: UIImageView!
    @IBOutlet var topToolbar: UIToolbar!
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var shareButton: UIBarButtonItem!
    @IBOutlet var cameraButton: UIBarButtonItem!
    @IBOutlet var topTextField: UITextField!
    @IBOutlet var bottomTextField: UITextField!    
    @IBOutlet var bottomToolbar: UIToolbar!
    
    var memes: [Meme] = []
    var currentMeme: Meme?
    
    
    
    // MARK: Viewcontroller functions
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        updateShareButtonState()
        subscribeToKeyboardEvents()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeFromKeyboardEvents()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let meme = currentMeme {
            setupTextFields(top:meme.topText, bottom:meme.bottomText)
            memeImageView.image = meme.orignalImage
        } else {
            setupTextFields(top: nil, bottom: nil)
        }
        showHideToolbars(alpha: Constants.TOOLBAR_ALPHA)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    // MARK: Image picker
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info[UIImagePickerControllerEditedImage] {
            memeImageView.image = editedImage as? UIImage
        } else if let orignalImage = info[UIImagePickerControllerOriginalImage] {
            memeImageView.image = orignalImage as? UIImage
        }
        updateShareButtonState()
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Top toolbar buttons
    
    func generateMemedImage() -> UIImage {
        showHideToolbars(alpha: Constants.HIDE_TOOLBAR_ALPHA)
        // Render view to an image
        UIGraphicsBeginImageContext(self.memeImageView.frame.size)
        view.drawHierarchy(in: self.memeImageView.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        showHideToolbars(alpha: Constants.TOOLBAR_ALPHA)
        return memedImage
    }
    @IBAction func saveMeme(_ sender: Any) {
        view.endEditing(true)
        let controller = UIAlertController(title: StringConstants.ALERT_SAVE_MEME_TITLE,
                                           message: StringConstants.ALERT_SAVE_MEME_MSG,
                                           preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: StringConstants.ALERT_SAVE_BUTTON, style: UIAlertActionStyle.default) {
            action in
            let memedImage: UIImage = self.generateMemedImage()
            self.memes.append(Meme(orignalImage: self.memeImageView.image,
                                   memedImage: memedImage,
                                   topText: self.topTextField.text!,
                                   bottomText: self.bottomTextField.text!))
            self.dismiss(animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: StringConstants.ALERT_CANCEL_BUTTON, style: UIAlertActionStyle.cancel) {
            action in self.dismiss(animated: true, completion: nil)
        }
        
        controller.addAction(saveAction)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        let memedImage: UIImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        controller.completionWithItemsHandler = {
            (_, successful, _, _) in
            if successful{
                self.memes.append(Meme(orignalImage: self.memeImageView.image,
                                       memedImage: memedImage,
                                       topText: self.topTextField.text!,
                                       bottomText: self.bottomTextField.text!))
                self.dismiss(animated: true, completion: nil)
            }
        }
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func cancelMeme(_ sender: Any) {
        view.endEditing(true)
        let controller = UIAlertController(title: StringConstants.ALERT_CLEAR_MEME_TITLE,
                                           message: StringConstants.ALERT_CLEAR_MEME_MSG,
                                           preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: StringConstants.ALERT_CLEAR_BUTTON, style: UIAlertActionStyle.destructive) {
            action in
            self.setupTextFields(top:nil, bottom:nil)
            self.memeImageView.image = nil
            self.updateShareButtonState()
            self.dismiss(animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: StringConstants.ALERT_CANCEL_BUTTON, style: UIAlertActionStyle.cancel) {
            action in self.dismiss(animated: true, completion: nil)
        }
        
        controller.addAction(okAction)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
    

    
    // MARK: Bottom toolbar button actions
    
    @IBAction func pickImageFromCamera(_ sender: Any) {
        loadImagePicker(sourceType: .camera)    }
    
    @IBAction func pickImageFromAlbum(_ sender: Any) {
            loadImagePicker(sourceType: .photoLibrary)
    }

    func loadImagePicker(sourceType: UIImagePickerControllerSourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: Textfield delegate functions

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.text == StringConstants.MEME_EDITOR_TOP_TEXT
            || textField.text == StringConstants.MEME_EDITOR_BOTTOM_TEXT {
            textField.text = StringConstants.EMPTY_TEXT
        }
        return true
    }

    //MARK: keyboard events
    func keyboardWillShow(_ notification:Notification) {
        if self.bottomTextField.isEditing && self.view.frame.origin.y == 0 {
            self.view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification:Notification) {
        self.view.frame.origin.y = Constants.FRAME_ORIGIN
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
    
    // MARK: Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        let savedMemeTableController = segue.destination as! SavedMemeViewController
        
        if segue.identifier == SegueIds.SAVED_MEME {
            savedMemeTableController.savedMemes = self.memes
            savedMemeTableController.datasource = SavedMemeDataSoure(savedMemes: self.memes)
        }
    }
    
    // MARK: Manage views
    
    func showHideToolbars(alpha: CGFloat) {
        bottomToolbar.alpha = alpha
        topToolbar.alpha = alpha
    }
    
    func setupTextFields (top:String?, bottom:String?) {
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        topTextField.defaultTextAttributes = Attributes.memeTextAttributes
        topTextField.textAlignment = .center
        
        bottomTextField.defaultTextAttributes = Attributes.memeTextAttributes
        bottomTextField.textAlignment = .center
        
        if let topText = top, let bottomText = bottom {
            topTextField.text = topText
            bottomTextField.text = bottomText
        } else {
            topTextField.text = StringConstants.MEME_EDITOR_TOP_TEXT
            bottomTextField.text = StringConstants.MEME_EDITOR_BOTTOM_TEXT
        }
    }
    
    func updateShareButtonState() {
        shareButton.isEnabled = memeImageView.image != nil
    }
}

