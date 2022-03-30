//
//  TextRotation.swift
//  Wussup
//
//  Created by Serik on 5/3/19.
//  Copyright © 2019 MAC26. All rights reserved.
//

import UIKit

class TextRotation: NSObject {
    
    //MARK: - Canvas Drawings
    
    class func drawArtboard(text theText: String,
                            frame targetFrame: CGRect,
                            resizing: ResizingBehavior = .aspectFit) // w 375 - h 302
    {
        /// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        /// Resize to Target Frame
        context.saveGState()
        let resizedFrame = resizing.apply(rect: targetFrame,
                                          target: targetFrame)
        
        context.translateBy(x: resizedFrame.minX,
                            y: resizedFrame.minY)

        context.scaleBy(x: 0.8, // width
                        y: 1)
        
        let width = targetFrame.width
        let height = targetFrame.height

        /// Group
        do {
            context.saveGState()
            //context.translateBy(x: 260, y: 220)
            //context.translateBy(x: -192, y: -32.5)

            context.translateBy(x: width * 0.69, y: height * 0.73)         // coordinates of a image with two squares
            context.rotate(by: 351 * CGFloat.pi / 180)  // + clockwise
            context.translateBy(x: -width * 0.51, y: -height * 0.107)

            /// Rectangle down
            let rectangle = UIBezierPath()
            rectangle.move(to: CGPoint.zero)
            
//            rectangle.addLine(to: CGPoint(x: 350, y: 0))  // top right
//            rectangle.addLine(to: CGPoint(x: 342, y: 46)) // down right
//            rectangle.addLine(to: CGPoint(x: -8, y: 46))  // down left
            
            rectangle.addLine(to: CGPoint(x: width * 0.93, y: 0))  // top right
            rectangle.addLine(to: CGPoint(x: width * 0.91, y: height * 0.15)) // down right
            rectangle.addLine(to: CGPoint(x: -width * 0.02, y: height * 0.15))  // down left
            rectangle.addLine(to: CGPoint.zero)           // top left
            
            rectangle.close()
            context.saveGState()
            context.translateBy(x: 6, y: 6)     // shadow
            rectangle.usesEvenOddFillRule = true
            
            UIColor.white.setFill()             // background
            rectangle.fill()
            context.saveGState()
            rectangle.lineWidth = 20            // line
            
            context.beginPath()
            context.addPath(rectangle.cgPath)
            context.clip(using: .evenOdd)
            
            UIColor.black.setStroke()           // line
            rectangle.stroke()
            context.restoreGState()
            context.restoreGState()
            
            
            /// Rectangle top witch name city
            let rectangle2 = UIBezierPath()
            rectangle2.move(to: CGPoint.zero)
            rectangle2.addLine(to: CGPoint(x: width * 0.93, y: 0))  // top right
            rectangle2.addLine(to: CGPoint(x: width * 0.91, y: height * 0.15)) // down right
            rectangle2.addLine(to: CGPoint(x: -width * 0.02, y: height * 0.15))  // down left
            rectangle2.addLine(to: CGPoint.zero)
            
            rectangle2.close()
            context.saveGState()
            
            rectangle2.usesEvenOddFillRule = true
            
            UIColor.white.setFill() // color background
            rectangle2.fill()
            context.saveGState()
            rectangle2.lineWidth = 11
            context.beginPath()
            context.addPath(rectangle2.cgPath)
            context.clip(using: .evenOdd)
            
            UIColor.black.setStroke() // color Width
            rectangle2.stroke()
            context.restoreGState()
            context.restoreGState()
            
            //let nameCityAtr = NSMutableAttributedString(string: "RANCHO SANTA MARGARITA")
            let nameCityAtr = NSMutableAttributedString(string: theText)
            
            nameCityAtr.addAttribute(.font,
                                     value: UIFont.MyriadProBold(23.0)!,
                                     range: NSRange(location: 0, length: nameCityAtr.length))
            
            nameCityAtr.addAttribute(.kern, // character spacing
                value: 0.5,
                range: NSRange(location: 0, length: nameCityAtr.length))
            
            nameCityAtr.addAttribute(.foregroundColor,
                                     value: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.9),
                                     range: NSRange(location: 0, length: nameCityAtr.length))
            
            nameCityAtr.addAttribute(.obliqueness, // text angle
                value: 0.35,
                range: NSRange(location: 0, length: nameCityAtr.length))
            
            context.saveGState()
            
            let nameCity = nameCityAtr.string
            let fontAttributes = [NSAttributedString.Key.font: UIFont.MyriadProBold(23.0)!]
            let textWidth = Int(nameCity.size(withAttributes: fontAttributes).width)
            let textHeight = Int(nameCity.size(withAttributes: fontAttributes).height)
            //let coordinateX = (330 - textWidth) / 2
            let coordinateX = (Int(width * 0.88) - textWidth) / 2
            let coordinateY = (Int(height * 0.16) - textHeight) / 2
            
            nameCityAtr.draw(in: CGRect(x: coordinateX,
                                        y: coordinateY, //Int(height * 0.045),//16,
                                        width: textWidth + 20,
                                        height: 24))
            context.restoreGState()
        }
        context.restoreGState()
    }
    
    //MARK: - Canvas Images
    
    class func imageOfArtboard(text: String, frame: CGRect) -> UIImage
    {
        var image = UIImage.init(named: "overlay")
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: frame.size.width, //375
            height: frame.size.height), // 302
            false, 0)
        
        TextRotation.drawArtboard(text:text, frame: frame)
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    //MARK: - Resizing Behavior
    
    enum ResizingBehavior {
        case aspectFit /// The content is proportionally resized to fit into the target rectangle.
        case aspectFill /// The content is proportionally resized to completely fill the target rectangle.
        case stretch /// The content is stretched to match the entire target rectangle.
        case center /// The content is centered in the target rectangle, but it is NOT resized.
        
        func apply(rect: CGRect, target: CGRect) -> CGRect {
            if rect == target || target == CGRect.zero {
                return rect
            }
            
            var scales = CGSize.zero
            scales.width = abs(target.width / rect.width)
            scales.height = abs(target.height / rect.height)
            
            switch self {
            case .aspectFit:
                scales.width = min(scales.width, scales.height)
                scales.height = scales.width
            case .aspectFill:
                scales.width = max(scales.width, scales.height)
                scales.height = scales.width
            case .stretch:
                break
            case .center:
                scales.width = 1
                scales.height = 1
            }
            
            var result = rect.standardized
            result.size.width *= scales.width
            result.size.height *= scales.height
            result.origin.x = target.minX + (target.width - result.width) / 2
            result.origin.y = target.minY + (target.height - result.height) / 2
            
            return result
        }
    }
}
