//
//  SearchFooter.swift
//  CandySearch
//
//  Created by Amit Chaudhary on 7/24/21.
//

import UIKit

class SearchFooter: UIView {
    
    let sfLabel: UILabel = {
        let aLabel = UILabel()
        return aLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureView()
    }
    
    override func draw(_ rect: CGRect) {
        sfLabel.bounds = self.bounds
    }
    
    
    func setIsFilteringToShow(filteredItemCount: Int, of totalItemCount: Int) {
        if filteredItemCount == totalItemCount {
            sfLabel.text = ""
            hideFooter()
        } else if (filteredItemCount == 0) {
            sfLabel.text = "No candy found"
            showFooter()
        } else {
            sfLabel.text = "\(filteredItemCount) out of \(totalItemCount) candies found"
            showFooter()
        }
    }
    
    func hideFooter() {
        UIView.animate(withDuration: 0.5) {
            self.alpha = 0.0
        }
    }
    
    func showFooter() {
        UIView.animate(withDuration: 0.7) {
            self.alpha = 1.0
        }
    }
    
    func configureView() {
        self.backgroundColor = UIColor.candyGreen
        self.alpha = 0.0
        self.sfLabel.textAlignment = .center
        self.sfLabel.textColor = .white
        self.addSubview(sfLabel)
    }
    
}









