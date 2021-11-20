//
//  InstagridView.swift
//  P4_01_Xcode
//
//  Created by Dhayan Bourguignon on 12/11/2021.
//

import UIKit

// Button for choose what grid the user want
class FormatButton: UIButton {
    private let image: UIImage
    
    init(tag: Int, imageName: String)
    {
        self.image =  UIImage(named: imageName)!
        super.init(frame: .zero)
        self.tag = tag
        setupFormat()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupFormat() {
        let select = UIImage(named: "Selected")!
        let selected = MergeTwoImage(format: image, model: select)
        imageView?.contentMode = .scaleAspectFill
        setBackgroundImage(selected, for: .selected)
        setBackgroundImage(image, for: .normal)
    }
}

//Buttons in the grid who take the image
class PhotoSelect: UIButton {
    init(tag: Int)
    {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.tag = tag
        setupFormat()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupFormat() {
        let plus = UIImage(named: "Plus")!
        let size = CGSize(width: 40, height: 40)
        let plusImage = plus.resizedImage(Size: size)
        imageView?.contentMode = .scaleAspectFill
        backgroundColor = .white
        setImage(plusImage, for: .normal)
    }
}

//Resize "Plus" image in the grid with the proportions 40 x 40
extension UIImage {
    func resizedImage(Size sizeImage: CGSize) -> UIImage? {
        let frame = CGRect(origin: CGPoint.zero, size: CGSize(width: sizeImage.width, height: sizeImage.height))
                UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
                self.draw(in: frame)
                let resizedImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                self.withRenderingMode(.alwaysOriginal)
                return resizedImage
    }
}

//merge two image for print the selected format imgage
internal func MergeTwoImage(format: UIImage, model: UIImage) -> UIImage {
    let size = CGSize(width: format.size.width, height: format.size.height)
    let selected = model
    UIGraphicsBeginImageContext(size)
    let area = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    format.draw(in: area)
    selected.draw(in: area, blendMode: .normal, alpha: 1)
    let finalSelected = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return finalSelected!
}
