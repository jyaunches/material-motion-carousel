//
//  CarouselExampleViewController.swift
//  CarouselExample
//
//  Created by Julietta Yaunches on 4/24/17.
//  Copyright © 2017 yaunches. All rights reserved.
//

import UIKit
import MaterialMotion

struct Foo {
    var title: String
    var description: String
    var color: UIColor
}

class CarouselExampleViewController: UIViewController, UIScrollViewDelegate {
    
    var runtime: MotionRuntime!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        
        let scrollView = UIScrollView(frame: view.bounds)
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.isPagingEnabled = true
        scrollView.contentSize = .init(width: view.bounds.size.width * 3, height: view.bounds.size.height)
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        pager = UIPageControl()
        let size = pager.sizeThatFits(view.bounds.size)
        pager.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        pager.frame = .init(x: 0, y: view.bounds.height - size.height - 20, width: view.bounds.width, height: size.height)
        pager.numberOfPages = 3
        view.addSubview(pager)
        
        let datas: [Foo] = [
            Foo(title: "Page 1", description: "Page 1 description", color: UIColor.white),
            Foo(title: "Page 2", description: "Page 2 description", color: UIColor.red),
            Foo(title: "Page 3", description: "Page 3 description", color: UIColor.blue),
            ]
        
        runtime = MotionRuntime(containerView: view)
        
        let stream = runtime.get(scrollView)
        for (index, data) in datas.enumerated() {
            let page = CarouselPage(frame: view.bounds)
            page.frame.origin.x = CGFloat(index) * view.bounds.width
            page.titleLabel.text = data.title
            page.descriptionLabel.text = data.description
            page.iconView.backgroundColor = data.color
            scrollView.addSubview(page)
            
            let pageEdge = stream.x().offset(by: -page.frame.origin.x)
            
            runtime.connect(pageEdge.rewriteRange(start: 0, end: 128,
                                                  destinationStart: 1, destinationEnd: 0),
                            to: runtime.get(page).alpha)
            runtime.connect(pageEdge.rewriteRange(start: -view.bounds.width, end: 0,
                                                  destinationStart: 0.5, destinationEnd: 1.0),
                            to: runtime.get(page.layer).scale)
        }
    }
    
    var pager: UIPageControl!
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pager.currentPage = Int((scrollView.contentOffset.x + scrollView.bounds.width / 2) / scrollView.bounds.width)
    }
    
    
}

private class CarouselPage: UIView {
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let iconView = UIView()
    
    override init(frame: CGRect) {
        titleLabel.font = .boldSystemFont(ofSize: 24)
        descriptionLabel.font = .systemFont(ofSize: 14)
        titleLabel.textColor = .white
        descriptionLabel.textColor = .white
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        
        super.init(frame: frame)
        
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(iconView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let descriptionSize = descriptionLabel.sizeThatFits(bounds.size)
        descriptionLabel.frame = .init(x: 16, y: bounds.height - descriptionSize.height - 48, width: bounds.width - 32, height: descriptionSize.height)
        
        let titleSize = titleLabel.sizeThatFits(bounds.size)
        titleLabel.frame = .init(x: 16, y: descriptionLabel.frame.minY - descriptionSize.height - 24, width: bounds.width - 32, height: titleSize.height)
        
        iconView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.width).insetBy(dx: 64, dy: 64)
        iconView.layer.cornerRadius = iconView.bounds.width / 2
    }
}

