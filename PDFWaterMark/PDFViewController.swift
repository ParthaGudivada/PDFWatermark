//
//  PDFViewController.swift
//  PDFWaterMark
//
//  Created by Partha Gudivada on 4/19/16.
//  Copyright © 2016 Partha. All rights reserved.
//

import UIKit
import WebKit

class PDFViewController: UIViewController {

    private var webView: UIWebView!
    private var processIndicator: UIActivityIndicatorView!
    
    private var printButton: UIBarButtonItem!
    
    private var pdfRenderer: PDFRenderer!
    private let samplePDFDocName = "roarkSwift"
    private let watermarkString = "Swift can't be this easy"
    
    private var printController: UIPrintInteractionController!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.pdfRenderer = PDFRenderer(fileName: self.samplePDFDocName)
        self.navigationItem.title = "PDF Viewer"
        
        self.webView = UIWebView(frame: .zero)
        self.webView.delegate = self
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(webView)
        
        self.processIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        self.processIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.processIndicator.color = .redColor()
        self.processIndicator.hidesWhenStopped = true
        self.view.addSubview(self.processIndicator)
        
        self.printButton = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: #selector(printPDFDocument))
        self.navigationItem.rightBarButtonItem = self.printButton
        
        let viewsDict = ["webView": self.webView, "processIndicator": self.processIndicator]
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[webView]|", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-60-[webView]|", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDict))
        self.view.centerX(self.processIndicator, withinParentView: self.view)
        self.view.centerY(self.processIndicator, withinParentView: self.view)
        
        self.navigationItem.rightBarButtonItem?.enabled = false
        
        self.processIndicator.startAnimating()
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        autoreleasepool {
            
            guard let pathToWatermarkedFile = self.pdfRenderer.pathToTheFileForAddedWatermark(self.watermarkString),
                watermarkedURL = NSURL(string: pathToWatermarkedFile ) else { return }
            let urlRequest =  NSURLRequest(URL: watermarkedURL)
            
            self.webView.scalesPageToFit = true
            self.webView.loadRequest(urlRequest)
        }

    }
    
    
    func printPDFDocument(sender: UIBarButtonItem) {
        
        guard let pathToWatermarkedFile = self.pdfRenderer.pathToTheFileForAddedWatermark(self.watermarkString) else { return }
        let printData = NSData(contentsOfFile: pathToWatermarkedFile)
        
        self.printController = UIPrintInteractionController.sharedPrintController()
        self.printController.delegate = self
        self.printController.showsPageRange = true
        self.printController.printingItem = printData
        self.printController.presentFromBarButtonItem(self.printButton, animated: true, completionHandler: { [strongSelf = self](printInteractionController: UIPrintInteractionController, completed: Bool, error: NSError?) in
            print("completed: \(completed)")
                strongSelf.printController.dismissAnimated(true)
            
        })
    
    }
 
 
}

extension PDFViewController: UIWebViewDelegate {
    
    func webViewDidStartLoad(webView: UIWebView) {
        print("started")
         self.navigationItem.rightBarButtonItem?.enabled = false
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        self.processIndicator.stopAnimating()
        print("finished")
         self.navigationItem.rightBarButtonItem?.enabled = true

    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        self.processIndicator.stopAnimating()
        print("finished with error \(error?.localizedDescription)")
        self.navigationItem.rightBarButtonItem?.enabled = false
    }
}

extension PDFViewController: UIPrintInteractionControllerDelegate {
 
    func printInteractionControllerWillStartJob(printInteractionController: UIPrintInteractionController) {
         print("started")
    }
    
    
    func printInteractionControllerDidFinishJob(printInteractionController: UIPrintInteractionController) {
         print("finished")
    }
    
    
    func printInteractionControllerDidDismissPrinterOptions(printInteractionController: UIPrintInteractionController) {
         print("did dismiss")
    }
    
}

