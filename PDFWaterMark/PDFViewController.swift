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
    
    private var pdfRenderer: PDFRenderer!
    private let samplePDFDocName = "roarkSwift"
    
    
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
        
        let viewsDict = ["webView": self.webView, "processIndicator": self.processIndicator]
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[webView]|", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-60-[webView]|", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDict))
        self.view.centerX(self.processIndicator, withinParentView: self.view)
        self.view.centerY(self.processIndicator, withinParentView: self.view)
        
        self.navigationItem.leftBarButtonItem?.enabled = false
        
        self.processIndicator.startAnimating()
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        autoreleasepool {
            
            guard let pathToWatermarkedFile = self.pdfRenderer.pathToTheFileForAddedWatermark("Secret watermark"),
                watermarkedURL = NSURL(string: pathToWatermarkedFile ) else { return }
            let urlRequest =  NSURLRequest(URL: watermarkedURL)
            
            self.webView.scalesPageToFit = true
            self.webView.loadRequest(urlRequest)
        }

    }
    
   

 
}

extension PDFViewController: UIWebViewDelegate {
    
    func webViewDidStartLoad(webView: UIWebView) {
        print("started")
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        self.processIndicator.stopAnimating()
        print("finished")
        self.navigationItem.leftBarButtonItem?.enabled = true
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        self.processIndicator.stopAnimating()
        print("finished with error \(error?.localizedDescription)")
        self.navigationItem.leftBarButtonItem?.enabled = true
        
    }
}

