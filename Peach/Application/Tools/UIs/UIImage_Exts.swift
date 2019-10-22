//
//  UIImage_Exts.swift
//  Peach
//
//  Created by dean on 2019/8/29.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import UIKit

extension UIImage {
    func resizeWith(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    
    func resizeWith(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width / size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    
    func fixOrientation() -> UIImage {
        if imageOrientation == .up {
            return self
        }
        var transform = CGAffineTransform() // CGAffineTransformIdentity
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
            break
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi / 2))
            break
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat(-Double.pi / 2))
            break
        default:
            break
        }
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break
        default:
            break
        }
        let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height),
                            bitsPerComponent: cgImage!.bitsPerComponent, bytesPerRow: 0,
                            space: cgImage!.colorSpace!,
                            bitmapInfo: cgImage!.bitmapInfo.rawValue)
        transform = (ctx?.ctm)!
        // ctx!.concatCTM(transform)
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            
            ctx?.draw(cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
            
            break
        default:
            ctx?.draw(cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            
            break
        }
        // And now we just create a new UIImage from the drawing context
        let cgimg = ctx!.makeImage()
        return UIImage(cgImage: cgimg!) // UIImage(CGImage: cgimg!)
    }
    
    func imageAtRect(_ rect: CGRect) -> UIImage {
        let imageRef: CGImage = cgImage!.cropping(to: rect)!
        let subImage: UIImage = UIImage(cgImage: imageRef)
        return subImage
    }
    
    func encodeImageToBase64(image: UIImage) -> String {
        let imageData: Data = image.pngData()! as Data
        let strBase64 = imageData.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
        return strBase64
    }
    
    func decodeBase64ToImage(base64: String) -> UIImage {
        let dataDecoded: NSData = NSData(base64Encoded: base64, options: NSData.Base64DecodingOptions(rawValue: 0))!
        let decodedimage: UIImage = UIImage(data: dataDecoded as Data)!
        return decodedimage
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio = targetSize.width / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    /**
     *  重设图片大小
     */
    func reSizeImage(reSize:CGSize)->UIImage {
        //UIGraphicsBeginImageContext(reSize);
        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale);
        self.draw(in: CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height));
        let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return reSizeImage;
    }
    
    /**
     *  等比率缩放
     */
    func scaleImage(scaleSize:CGFloat)->UIImage {
        let reSize = CGSize(width: self.size.width * scaleSize, height: self.size.height * scaleSize)
        return reSizeImage(reSize: reSize)
    }
    class func groupIcon(wh: CGFloat, images: [UIImage], bgColor: UIColor?) -> UIImage {
        let finalSize = CGSize(width: wh, height: wh)
        var rect: CGRect = CGRect.zero
        rect.size = finalSize
        
        UIGraphicsBeginImageContextWithOptions(finalSize, false, 0)
        
        if bgColor != nil {
            let context: CGContext = UIGraphicsGetCurrentContext()!
            context.addRect(rect)
            context.setFillColor(bgColor!.cgColor)
            context.drawPath(using: .fill)
        }
        
        if images.count >= 1 {
            let rects = getRectsInGroupIcon(wh: wh, count: images.count)
            var count = 0
            
            for image in images {
                if count > rects.count - 1 {
                    break
                }
                
                let rect = rects[count]
                image.draw(in: rect)
                count = count + 1
            }
        }
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    class func getRectsInGroupIcon(wh: CGFloat, count: Int) -> [CGRect] {
        if count == 1 {
            return [CGRect(x: 0, y: 0, width: wh, height: wh)]
        }
        
        var array = [CGRect]()
        
        if count == 2 {
            let rect1 = CGRect(x: 0 - wh / 4, y: 0, width: wh, height: wh)
            let rect2 = CGRect(x: wh / 2, y: 0, width: wh, height: wh)
            array = [rect1, rect2]
            
        } else if count == 3 {
            let rect1 = CGRect(x: 0 - wh / 4, y: 0, width: wh, height: wh)
            let rect2 = CGRect(x: wh / 2, y: 0, width: wh / 2, height: wh / 2)
            let rect3 = CGRect(x: wh / 2, y: wh / 2, width: wh / 2, height: wh / 2)
            
            array = [rect1, rect2, rect3]
            
        } else if count == 4 {
            let rect1 = CGRect(x: 0, y: 0, width: wh / 2, height: wh / 2)
            let rect2 = CGRect(x: 0, y: wh / 2, width: wh / 2, height: wh / 2)
            let rect3 = CGRect(x: wh / 2, y: 0, width: wh / 2, height: wh / 2)
            let rect4 = CGRect(x: wh / 2, y: wh / 2, width: wh / 2, height: wh / 2)
            array = [rect1, rect2, rect3, rect4]
        }
        
        return array
    }
    
    func cropImage(imageToCrop: UIImage, toRect rect: CGRect) -> UIImage {
        let imageRef: CGImage = imageToCrop.cgImage!.cropping(to: rect)!
        let cropped: UIImage = UIImage(cgImage: imageRef)
        return cropped
    }
    
    func makeImageWithColorAndSize(color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    static func returnImageWithColorAndSize(color: UIColor, size: CGSize) -> UIImage {
        return UIImage().makeImageWithColorAndSize(color: color, size: size);
    }
    
    func kt_drawRectWithRoundedCorner(radius: CGFloat, sizetoFit: CGSize) -> UIImage {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: sizetoFit)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        UIGraphicsGetCurrentContext()!.addPath(UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: [UIRectCorner.bottomLeft, UIRectCorner.topLeft],
            cornerRadii: CGSize(width: radius, height: radius)).cgPath)
        UIGraphicsGetCurrentContext()?.clip()
        
        draw(in: rect)
        UIGraphicsGetCurrentContext()!.drawPath(using: .fillStroke)
        let output = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return output!
    }
    
    static func createQRCodeImage(content: String, size: CGSize) -> UIImage {
        let stringData = content.data(using: String.Encoding.utf8)
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")
        
        qrFilter?.setValue(stringData, forKey: "inputMessage")
        qrFilter?.setValue("H", forKey: "inputCorrectionLevel")
        
        let colorFilter = CIFilter(name: "CIFalseColor")
        colorFilter?.setDefaults()
        
        colorFilter?.setValuesForKeys(["inputImage": (qrFilter?.outputImage)!, "inputColor0": CIColor(cgColor: UIColor.black.cgColor), "inputColor1": CIColor(cgColor: UIColor.white.cgColor)])
        
        let qrImage = colorFilter?.outputImage
        let cgImage = CIContext(options: nil).createCGImage(qrImage!, from: (qrImage?.extent)!)
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        context!.interpolationQuality = .none
        context!.scaleBy(x: 1.0, y: -1.0)
        context?.draw(cgImage!, in: (context?.boundingBoxOfClipPath)!)
        let codeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return codeImage!
    }
    static func addIconImage(image: UIImage, icon: UIImage, iconSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(image.size)
        
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        let iconWidth = iconSize.width
        let iconHeight = iconSize.height
        
        image.draw(in: CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight))
        icon.draw(in: CGRect(x: (imageWidth - iconWidth) / 2.0, y: (imageHeight - iconHeight) / 2.0, width: iconWidth, height: iconHeight))
        let qrImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return qrImage!
    }
    //對image 做裁切
    func cropped(boundingBox: CGRect) -> UIImage? {
        guard let cgImage = self.cgImage?.cropping(to: boundingBox) else {
            return nil
        }
        
        return UIImage(cgImage: cgImage)
    }
    //對螢幕做Screenshot
    static func takeScreenshot(_ shouldSave: Bool = true) -> UIImage? {
        
        var screenshotImage :UIImage?
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        guard let context = UIGraphicsGetCurrentContext() else {return nil}
        layer.render(in:context)
        screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let image = screenshotImage, shouldSave {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        return screenshotImage
    }
    //對某一塊view做快照
    static func snapshot(view:UIView) -> UIImage?
    {
        
        // Begin context
        //self.bounds.size
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, UIScreen.main.scale)
        
        // Draw view in that context
        view.drawHierarchy(in: CGRect(x: 0.0, y: view.bounds.origin.y, width: view.bounds.width, height: view.bounds.height), afterScreenUpdates: true)
        
        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if (image != nil)
        {
            return image!
        }
        return UIImage()
        
    }
    //對某特定vc做Screenshot
    static func takeScreenshot(vc:UIViewController,_ shouldSave: Bool = true) -> UIImage? {
        
        var screenshotImage :UIImage?
        let layer = vc.view.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        guard let context = UIGraphicsGetCurrentContext() else {return nil}
        layer.render(in:context)
        screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        if let image = screenshotImage, shouldSave {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        return screenshotImage
    }
    
    func imageSize() -> UInt {
        let cgImageBytesPerRow = cgImage?.bytesPerRow ?? 0
        let cgImageHeight = cgImage?.height ?? 0
        let size: UInt = UInt(cgImageHeight * cgImageBytesPerRow)
        let kbSize: UInt = size / 1024
        return kbSize
    }
}
