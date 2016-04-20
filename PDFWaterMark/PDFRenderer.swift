//
//  PDFRenderer.swift
//  PDFWaterMark
//
//  Created by Partha Gudivada on 4/19/16.
//  Copyright © 2016 Partha. All rights reserved.
//

import Foundation
import UIKit
import CoreText

public class PDFRenderer {
    
    private let fileName: String
    
    private let pdfExtension = "pdf"
    
    private var watermarkedFileName: String {
        get {
            return "watermarked_\(self.fileName).pdf"
        }
    }
    
    
    init(fileName: String) {
        self.fileName = fileName
    }
    
    //convenience function to create an URL for the given file name
    private func fileURL(fileName: String, fileExtension: String) -> NSURL? {
        return NSBundle.mainBundle().URLForResource(fileName, withExtension: fileExtension)
    }
    
    
    
    //This function is used to create CGPDFDocument for the given pdf file name
    private func createCGPDFDocument(fileName: String, fileExtension: String) -> CGPDFDocument? {
        
        guard fileExtension == pdfExtension else { return nil }
        
        guard let fileURL = self.fileURL(fileName, fileExtension: fileExtension) else { return nil }
        
        guard let data = NSData(contentsOfURL: fileURL) else { return nil }
        
        let cfData = CFDataCreate(kCFAllocatorDefault, UnsafePointer<UInt8>(data.bytes), data.length)
        
        guard let cgDataProvider =  CGDataProviderCreateWithCFData(cfData) else { return nil }
        
        guard let cgPDFDocument  =  CGPDFDocumentCreateWithProvider(cgDataProvider) else { return nil }
        
        return cgPDFDocument
        
    }
    
    
    public func pathToTheFileForAddedWatermark(watermarkMessage: String = "Watermark for long name so long that it cannot fit the page", watermarkFont: UIFont = UIFont(name: "Verdana", size: 16.0)!)  -> String? {
        
        
        guard let cgPDFDocument = self.createCGPDFDocument(self.fileName, fileExtension: pdfExtension)  else { return nil }
   
        let path = NSTemporaryDirectory()
        // provision for creating the watermarked file in the temporary location
        let temporaryPDFFilePath = path.stringByAppendingString(self.watermarkedFileName)
      
        autoreleasepool {
            
            // get the number of pages of the document
            let numberOfPages = CGPDFDocumentGetNumberOfPages(cgPDFDocument)
        
            UIGraphicsBeginPDFContextToFile(temporaryPDFFilePath, .zero, nil)
            
            let currentContext = UIGraphicsGetCurrentContext()
            
            for pageNo in 1 ... numberOfPages {
                
                // get a reference to the page
                let page: CGPDFPage =  CGPDFDocumentGetPage(cgPDFDocument, pageNo)!
                
                // set the proper size
                let pageRect = CGPDFPageGetBoxRect(page, .MediaBox)
                
                UIGraphicsBeginPDFPageWithInfo(pageRect, nil)
                
                CGContextSaveGState(currentContext)
              
                // set the context for rendering the page correctly in iOS
                CGContextTranslateCTM(currentContext, 0, pageRect.size.height)
                CGContextScaleCTM(currentContext, 1.0, -1.0)
                
                // draw(copy) the current page to the context
                CGContextDrawPDFPage(currentContext, page)
                
                // create a rectangle of the desired size
                let rectText = CGRectMake(0, 0, 160, 40)
                
                CGContextTranslateCTM(currentContext, 0, pageRect.size.height)
                CGContextScaleCTM(currentContext, 1.0, -1.0)
                
                // set the context so that it appears towards the centre
                CGContextTranslateCTM(currentContext,  (pageRect.size.width - rectText.size.width)/2.0, (pageRect.size.height)/2.0)
                
                // rotate the context by the desired number of radians - the next line is to roate the context by 45 degress anticlockwise
                CGContextConcatCTM(currentContext, CGAffineTransformMakeRotation(CGFloat(M_PI * -0.25)))
                CGContextSetAlpha(currentContext, 0.50)
                
                let textStyle = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
                let textColor = UIColor.redColor()
                let textFontAttributes = [NSFontAttributeName: watermarkFont, NSForegroundColorAttributeName: textColor, NSParagraphStyleAttributeName: textStyle]
                
                // write the watermark on to the current context
                watermarkMessage.drawInRect(rectText, withAttributes: textFontAttributes)
                
                CGContextRestoreGState(currentContext)
            }
        
            UIGraphicsEndPDFContext()
        }
    
        return temporaryPDFFilePath
        
        
        
    }
    

}
    