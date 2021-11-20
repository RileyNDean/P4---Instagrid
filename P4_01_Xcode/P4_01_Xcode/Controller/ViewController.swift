//
//  ViewController.swift
//  P4_01_Xcode
//
//  Created by Dhayan Bourguignon on 11/11/2021.
//

import UIKit
import Photos

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    //MARK: IBOulet declaration
    @IBOutlet var formatsStack: UIStackView!
    @IBOutlet var topGridStack: UIStackView!
    @IBOutlet var botGridStack: UIStackView!
    @IBOutlet var finalGridView: UIView!
    
    //MARK: Property declaration
    private let formatOne = FormatButton(tag: 0, imageName: "Layout 1")
    private let formatTwo = FormatButton(tag: 1, imageName: "Layout 2")
    private let formatThree = FormatButton(tag: 3, imageName: "Layout 3")
    private let imageOne = PhotoSelect(tag: 0)
    private let imageTwo = PhotoSelect(tag: 1)
    private let imageThree = PhotoSelect(tag: 2)
    private let imageFour = PhotoSelect(tag: 3)
    private var imagePicker = UIImagePickerController()
    private var imageChoose: ButtonTouch = .one
    private var swipeGestureRecognizer: UISwipeGestureRecognizer?
    
    //view load
    override func viewDidLoad() {
        super.viewDidLoad()
        checkPermissions()
        stackConfiguration()
        addButtonsStack()
        
        //know when the phone rotate
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        //Add swipe gesture to the Grid View
        swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(gridShare))
        guard let swipeGestureRecognizer = swipeGestureRecognizer else { return }
        finalGridView.addGestureRecognizer(swipeGestureRecognizer)
    }
    
    //Check permission for Library access
    private func checkPermissions() {
        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
            PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in ()})
        }
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
        } else {
            PHPhotoLibrary.requestAuthorization(requestAutorizationHandler)
        }
    }
    
    //Request for access to the library
    private func requestAutorizationHandler(status: PHAuthorizationStatus) {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            print("Access granted to use photo Library")
        } else {
            print("Access Denied")
        }
    }
    
    //UIStack configuration, set up the button in the all stack (top grid stack, bot grid stack and format stack)
    private func stackConfiguration() {
        formatsStack.distribution = .fillEqually
        formatsStack.spacing = 10
        topGridStack.distribution = .fillEqually
        topGridStack.spacing = 10
        botGridStack.distribution = .fillEqually
        botGridStack.spacing = 10
    }
    
    //Add button in the stack
    private func addButtonsStack() {
        //Add touch to buttons
        formatOne.addTarget(self, action: #selector(tappedFormatButton(_:)), for: .touchUpInside)
        formatTwo.addTarget(self, action: #selector(tappedFormatButton(_:)), for: .touchUpInside)
        formatThree.addTarget(self, action: #selector(tappedFormatButton(_:)), for: .touchUpInside)
        imageOne.addTarget(self, action: #selector(selectImage(_:)), for: .touchUpInside)
        imageTwo.addTarget(self, action: #selector(selectImage(_:)), for: .touchUpInside)
        imageThree.addTarget(self, action: #selector(selectImage(_:)), for: .touchUpInside)
        imageFour.addTarget(self, action: #selector(selectImage(_:)), for: .touchUpInside)
        
        //Add button in the stack
        formatsStack.addArrangedSubview(formatOne)
        formatsStack.addArrangedSubview(formatTwo)
        formatsStack.addArrangedSubview(formatThree)
        topGridStack.addArrangedSubview(imageOne)
        topGridStack.addArrangedSubview(imageTwo)
        botGridStack.addArrangedSubview(imageThree)
        botGridStack.addArrangedSubview(imageFour)
    }
    
    //When the format button is tapped
    @objc private func tappedFormatButton(_ sender: UIButton?) {
        resetFormat() //Reset all format to the normal state before change the state
        if sender?.tag == formatOne.tag { //when the format one is tapped
            formatOne.isSelected = true //change the format UIImage for the Selected image
            imageTwo.isHidden = true //hide the button 2 of the grid for make the format who selected
        }
        else if sender?.tag == formatTwo.tag {
            formatTwo.isSelected = true
            imageFour.isHidden = true
        }
        else if sender?.tag == formatThree.tag {
            formatThree.isSelected = true
        }
    }
    
    //Reset all format to the normal state
    private func resetFormat() {
        formatOne.isSelected = false
        formatTwo.isSelected = false
        formatThree.isSelected = false
        imageOne.isHidden = false
        imageTwo.isHidden = false
        imageThree.isHidden = false
        imageFour.isHidden = false
        imageOne.isSelected = false
        imageTwo.isSelected = false
        imageThree.isSelected = false
        imageFour.isSelected = false
    }
    
    //When the user touch one of the button in the grid
    @objc private func selectImage(_ sender: UIButton?) {
        if sender?.tag == imageOne.tag { //if user touch the first button
            imageChoose = .one //enum for know which button is tapped and change it to a image
            pickImage()//change the button into the selected image
        }
        else if sender?.tag == imageTwo.tag {
            imageChoose = .two
            pickImage()
        }
        else if sender?.tag == imageThree.tag {
            imageChoose = .three
            pickImage()
        }
        else if sender?.tag == imageFour.tag {
            imageChoose = .four
            pickImage()
        }
    }
    
    //Which button is touch
    enum ButtonTouch {
        case one,two,three,four
    }
    
    //Func for take the image in the library
    private func pickImage() {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary //take the photo in the library
        imagePicker.allowsEditing = false //no edition for the photo
        present(imagePicker, animated: true, completion: nil)
    }
    
    //Change the touch button into the photo
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let PickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        picker.dismiss(animated: true, completion: nil)
        
        if imageChoose == .one {
            imageOne.setImage(PickedImage, for: .selected) //put the photo in button selected mode
            imageOne.isSelected = true //activate selected mode for display the photo
        }
        else if imageChoose == .two {
            imageTwo.setImage(PickedImage, for: .selected)
            imageTwo.isSelected = true
        }
        else if imageChoose == .three {
            imageThree.setImage(PickedImage, for: .selected)
            imageThree.isSelected = true
        }
        else if imageChoose == .four {
            imageFour.setImage(PickedImage, for: .selected)
            imageFour.isSelected = true
        }
    }
    
    //Know when the phone rotate for change the swipe direction
    @objc private func rotated() {
        if UIDevice.current.orientation.isLandscape {
            swipeGestureRecognizer?.direction = .left //left swipe if the phone is in landscape mode
        }
        if UIDevice.current.orientation.isPortrait {
            swipeGestureRecognizer?.direction = .up //up swipe for portait mode
        }
    }
    
    //swipe animation & share the grid
    @objc private func gridShare() {
        if swipeGestureRecognizer?.direction == .left {
            UIView.animate(withDuration: 0.5, animations: {
                self.finalGridView.transform = CGAffineTransform(translationX: -self.view.frame.width, y: 0)}) //make the view animation
            shareGrid()
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.finalGridView.transform = CGAffineTransform(translationX: 0, y: -self.view.frame.height)})
            shareGrid()
        }
    }
    
    //animation when the grid is share or the user cancel
    private func animationsReturn() {
        UIView.animate(withDuration: 0.5) {
            self.finalGridView.transform = .identity
        }
    }
    
    //Transform the grid into a image and share the image and do the return animation
    private func shareGrid() {
        guard let image = finalGridView.viewImage() else { return }
        let imageToShare = image
        let activityController = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
        present(activityController, animated:  true, completion: nil)
        activityController.completionWithItemsHandler = { _, _, _, _ in
            self.animationsReturn()
        }
    }
}

//Extention for transform the grid into a image
extension UIView{
    func viewImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        guard let imgage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return imgage
    }
}
