//
//  MainViewController.swift
//  PDFWaterMark
//
//  Created by Partha Gudivada on 4/19/16.
//  Copyright © 2016 Partha. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    private var drawBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Action"
        
        self.drawBtn = UIButton(type: .Custom)
        self.drawBtn.addTarget(self, action: #selector(drawPDF(_:)), forControlEvents: .TouchUpInside)
        self.drawBtn.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.drawBtn)
        self.drawBtn.setTitle("Add Watermark", forState: .Normal)
        let viewsDict = ["drawBtn": self.drawBtn]
        let metricsDict = ["width": 200, "height": 40]
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[drawBtn(width)]", options: NSLayoutFormatOptions(), metrics: metricsDict, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-80-[drawBtn(height)]", options: NSLayoutFormatOptions(), metrics: metricsDict, views: viewsDict))
        self.view.backgroundColor = .lightGrayColor()
    }
    
    
    func drawPDF(btn: UIButton) {
        self.navigationController?.pushViewController(PDFViewController(), animated: true)
    }
}
