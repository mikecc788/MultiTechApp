//
//  INN+UIImage.swift
//  AudioLatencyTester
//
//  Created by chenliao on 2021/10/29.
//

import UIKit

public extension UIImage{
    // MARK: - 生成一张指定大小和颜色的图片（IOS 10 以上）
    @available(iOS 10.0, *)
    convenience init(color: UIColor, size: CGSize) {
        let image = UIGraphicsImageRenderer(size: size).image { context in
            context.cgContext.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
        if let cgImage = image.cgImage {
            self.init(cgImage: cgImage)
        } else {
            self.init()
        }
    }
    
    // MARK: - 为图片设置主题色（IOS 10 以上）
    @available(iOS 10.0, *)
    func inn_Image(withTint color: UIColor) -> UIImage {
        guard let cgImage = cgImage else { return self }
        let rect = CGRect(origin: .zero, size: size)
        return UIGraphicsImageRenderer(size: size).image { context in
            context.cgContext.scaleBy(x: 1, y: -1)
            context.cgContext.translateBy(x: 0, y: -self.size.height)
            context.cgContext.clip(to: rect, mask: cgImage)
            context.cgContext.setFillColor(color.cgColor)
            context.fill(rect)
        }
    }
    
    // MARK: - 裁剪图片
    func inn_Cropped(to rect: CGRect) -> UIImage {
        guard let cgImage = cgImage,
            let imageRef = cgImage.cropping(to: rect) else { return UIImage() }
        return UIImage(cgImage: imageRef, scale: scale, orientation: imageOrientation)
    }
    
    // MARK: - 调整图片size（IOS 10 以上）
    @available(iOS 10.0, *)
    func inn_Resized(to newSize: CGSize) -> UIImage {
        let scaledSize = newSize.applying(.init(scaleX: 1 / scale, y: 1 / scale))
        return UIGraphicsImageRenderer(size: scaledSize).image { context in
            draw(in: .init(origin: .zero, size: scaledSize))
        }
    }
    
    // MARK: - 调整图片size（IOS 10 以上）
    @available(iOS 10.0, *)
    func inn_Resized(to newSize: CGSize, scalingMode: inn_ScalingMode) -> UIImage {
        let scaledNewSize = newSize.applying(.init(scaleX: 1 / scale, y: 1 / scale))
        let aspectRatio = scalingMode.aspectRatio(between: scaledNewSize, and: size)
        let aspectRect = CGRect(x: (scaledNewSize.width - size.width * aspectRatio) / 2.0,
                                y: (scaledNewSize.height - size.height * aspectRatio) / 2.0,
                                width: size.width * aspectRatio,
                                height: size.height * aspectRatio)
        return UIGraphicsImageRenderer(size: scaledNewSize).image { context in
            draw(in: aspectRect)
        }
    }
    
    // MARK: - 图片转JPEG
    /// - Parameter quarity: 转换率
    func inn_ToJPEG(quarity: CGFloat = 1.0) -> Data? {
        return self.jpegData(compressionQuality: quarity)
    }
    
    // MARK: - 图片转PNG
    func inn_ToPNG() -> Data? {
        return self.pngData()
    }
    
    // MARK: - 图片圆角/边配置（高性能）
    @available(iOS 10.0, *)
    func inn_Rounded(cornerRadius: CGFloat? = nil, borderWidth: CGFloat = 0, borderColor: UIColor = .white) -> UIImage {
        let diameter = min(size.width, size.height)
        let isLandscape = size.width > size.height
        let xOffset = isLandscape ? (size.width - diameter) / 2 : 0
        let yOffset = isLandscape ? 0 : (size.height - diameter) / 2
        let imageSize = CGSize(width: diameter, height: diameter)
        return UIGraphicsImageRenderer(size: imageSize).image { _ in
            let roundedPath = UIBezierPath(roundedRect: CGRect(origin: .zero, size: imageSize),
                                           cornerRadius: cornerRadius ?? diameter / 2)
            roundedPath.addClip()
            draw(at: CGPoint(x: -xOffset, y: -yOffset))
            if borderWidth > 0 {
                borderColor.setStroke()
                roundedPath.lineWidth = borderWidth
                roundedPath.stroke()
            }
        }
    }
    
    // MARK: - 获取图片上某个点的像素颜色(用于便捷取颜色)
    func inn_PixelColor(at point: CGPoint) -> UIColor? {
        let size = cgImage.map { CGSize(width: $0.width, height: $0.height) } ?? self.size
        guard point.x >= 0, point.x < size.width, point.y >= 0, point.y < size.height,
            let data = cgImage?.dataProvider?.data,
            let pointer = CFDataGetBytePtr(data) else { return nil }
        let numberOfComponents = 4
        let pixelData = Int((size.width * point.y) + point.x) * numberOfComponents
        let r = CGFloat(pointer[pixelData]) / 255.0
        let g = CGFloat(pointer[pixelData + 1]) / 255.0
        let b = CGFloat(pointer[pixelData + 2]) / 255.0
        let a = CGFloat(pointer[pixelData + 3]) / 255.0
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    // MARK: - 规范化图片
    var canonicalized: UIImage {
        guard let cgImage = cgImage else { return self }
        let bytesPerPixel = 4
        var data = [UInt8](repeating: 0, count: cgImage.width * cgImage.height * bytesPerPixel)
        let bytesPerRow = bytesPerPixel * cgImage.width
        
        guard let context = CGContext(data: &data,
                                      width: cgImage.width,
                                      height: cgImage.height,
                                      bitsPerComponent: 8,
                                      bytesPerRow: bytesPerRow,
                                      space: CGColorSpaceCreateDeviceRGB(),
                                      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else { return self }
        
        context.draw(cgImage, in: CGRect(origin: .zero, size: CGSize(width: cgImage.width, height: cgImage.height)))
        guard let image = context.makeImage() else { return self }
        return UIImage(cgImage: image, scale: 1, orientation: .up)
    }
    
    // MARK: - 压缩上传图片到指定字节
    func inn_CompressImage(_ image: UIImage, maxLength: Int) -> Data? {
        let newSize = self.inn_ScaleImage(image, imageLength: 300)
        let newImage = self.inn_ResizeImage(image, newSize: newSize)
        var compress: CGFloat = 0.9
        var data = newImage.jpegData(compressionQuality: compress)
        while (data?.count)! > maxLength && compress > 0.01 {
            compress -= 0.02
            data = newImage.jpegData(compressionQuality: compress)
        }
        return data as Data?
    }
    
    // MARK: - 通过指定图片最长边，获得等比例的图片size
    func inn_ScaleImage(_ image: UIImage, imageLength: CGFloat) -> CGSize {
        var newWidth:CGFloat = 0.0
        var newHeight:CGFloat = 0.0
        let width = image.size.width
        let height = image.size.height
        if (width > imageLength || height > imageLength) {
            if (width > height) {
                newWidth = imageLength
                newHeight = newWidth * height / width
            } else if(height > width) {
                newHeight = imageLength
                newWidth = newHeight * width / height
            } else {
                newWidth = imageLength
                newHeight = imageLength
            }
        } else {
            newWidth = width
            newHeight = height
        }
        return CGSize(width: newWidth, height: newHeight)
    }
    
    // MARK: - 获得指定size的图片
    func inn_ResizeImage(_ image: UIImage, newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    // MARK: - 根据原始图片生成压缩后的图片(最大宽或高为1280)
    func inn_ResizeOriginImage() -> UIImage {
        //prepare constants
        let width = self.size.width
        let height = self.size.height
        let scale = width/height
        
        var sizeChange = CGSize()
        
        if width <= 1280 && height <= 1280{ //图片宽或者高均小于或等于1280时图片尺寸保持不变，不改变图片大小
            return self
        }else if width > 1280 || height > 1280 {//宽或者高大于1280，但是图片宽度高度比小于或等于2，则将图片宽或者高取大的等比压缩至1280
            
            if scale <= 2 && scale >= 1 {
                let changedWidth:CGFloat = 1280
                let changedheight:CGFloat = changedWidth / scale
                sizeChange = CGSize(width: changedWidth, height: changedheight)
                
            }else if scale >= 0.5 && scale <= 1 {
                
                let changedheight:CGFloat = 1280
                let changedWidth:CGFloat = changedheight * scale
                sizeChange = CGSize(width: changedWidth, height: changedheight)
                
            }else if width > 1280 && height > 1280 {//宽以及高均大于1280，但是图片宽高比大于2时，则宽或者高取小的等比压缩至1280
                
                if scale > 2 {//高的值比较小
                    
                    let changedheight:CGFloat = 1280
                    let changedWidth:CGFloat = changedheight * scale
                    sizeChange = CGSize(width: changedWidth, height: changedheight)
                    
                }else if scale < 0.5{//宽的值比较小
                    
                    let changedWidth:CGFloat = 1280
                    let changedheight:CGFloat = changedWidth / scale
                    sizeChange = CGSize(width: changedWidth, height: changedheight)
                    
                }
            }else {//宽或者高，只有一个大于1280，并且宽高比超过2，不改变图片大小
                return self
            }
        }
        
        UIGraphicsBeginImageContext(sizeChange)
        
        //draw resized image on Context
        self.draw(in: CGRect.init(x: 0.0, y: 0.0, width: sizeChange.width, height: sizeChange.height))
        
        //create UIImage
        let resizedImg = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return resizedImg!
        
    }
}

extension UIImage {
    // 缩放枚举
    public enum inn_ScalingMode {
        case aspectFill
        case aspectFit
        
        func aspectRatio(between size: CGSize, and otherSize: CGSize) -> CGFloat {
            let aspectWidth  = size.width / otherSize.width
            let aspectHeight = size.height / otherSize.height
            
            switch self {
            case .aspectFill: return max(aspectWidth, aspectHeight)
            case .aspectFit: return min(aspectWidth, aspectHeight)
            }
        }
    }
}
