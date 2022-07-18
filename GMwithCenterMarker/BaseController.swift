//
//  BaseController.swift
//  Reilu
//
//  Created by Hamza on 21/01/2022.
//

import UIKit

class BaseController: UIViewController {
    
    
    lazy var headerotop : UIView = {
        let view = UIView()
        view.backgroundColor = headerTop()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var headerView : UIView = {
        let view = UIView()
        view.backgroundColor = primaryColor()
        view.clipsToBounds = true
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var baseBackBtn : CustomButton = {
        let btn = CustomButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = UIColor.clear
        btn.setImage(UIImage(named: "backIcon"), for: .normal)
        btn.layer.shadowColor = UIColor.clear.cgColor
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(baseBackBtn_press), for: .touchUpInside)
        return btn
    }()
    
    lazy var baseHeadingeadingLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = semiBold(size: 14)
        lbl.textColor = UIColor.white
        lbl.text = ""
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        return lbl
    }()

    lazy var childview : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI(){
        let margin = view.layoutMarginsGuide
        view.addSubview(headerotop)
        view.addSubview(childview)
        childview.addSubview(headerView)
        headerView.addSubview(baseBackBtn)
        headerView.addSubview(baseHeadingeadingLbl)
        
        NSLayoutConstraint.activate([
            headerotop.bottomAnchor.constraint(equalTo: margin.topAnchor, constant: 0 * appConstant.heightRatio),
            headerotop.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0  * appConstant.heightRatio),
            headerotop.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0  * appConstant.heightRatio),
            headerotop.topAnchor.constraint(equalTo: view.topAnchor),
            
            childview.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0 * appConstant.heightRatio),
            childview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0  * appConstant.heightRatio),
            childview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0  * appConstant.heightRatio),
            childview.topAnchor.constraint(equalTo: margin.topAnchor),
            
            headerView.topAnchor.constraint(equalTo: childview.topAnchor, constant: 0 * appConstant.heightRatio),
            headerView.leadingAnchor.constraint(equalTo: childview.leadingAnchor, constant: 0  * appConstant.heightRatio),
            headerView.trailingAnchor.constraint(equalTo: childview.trailingAnchor, constant: 0  * appConstant.heightRatio),
            headerView.heightAnchor.constraint(equalToConstant: 44 * appConstant.heightRatio),
            
            baseBackBtn.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: 0 * appConstant.heightRatio),
            baseBackBtn.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 0 * appConstant.heightRatio),
            baseBackBtn.heightAnchor.constraint(equalToConstant: 30 * appConstant.heightRatio),
            baseBackBtn.widthAnchor.constraint(equalToConstant: 50 * appConstant.widthRatio),
            
            baseHeadingeadingLbl.centerXAnchor.constraint(equalTo: headerView.centerXAnchor, constant: 0 * appConstant.widthRatio),
            baseHeadingeadingLbl.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
        ])
    }
    
    @objc func baseBackBtn_press(){
        self.navigationController?.popViewController(animated: true)
    }
    

}
