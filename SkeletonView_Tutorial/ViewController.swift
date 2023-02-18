//
//  ViewController.swift
//  SkeletonView_Tutorial
//
//  Created by yc on 2023/02/18.
//

import UIKit
import SnapKit
import Then
import SkeletonView

final class ViewController: UIViewController {
    private lazy var imageView = UIImageView().then {
        $0.isSkeletonable = true
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12.0
    }
    private lazy var button = MyButton().then {
        $0.style = .fill(backgroundColor: .systemPink)
        $0.setTitle("Fetch", for: .normal)
        $0.addTarget(self, action: #selector(didTapFetchButton), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        view.addSubview(imageView)
        view.addSubview(button)
        imageView.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(view.safeAreaLayoutGuide).inset(16.0)
        }
        button.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(16.0)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(16.0)
            $0.height.equalTo(48.0)
        }
        
        navigationItem.title = "스켈레톤1"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(didTapRightBarButton))
    }
    
    @objc func didTapRightBarButton() {
        print(#function)
        navigationController?.pushViewController(ViewController2(), animated: true)
    }
    
    @objc func didTapFetchButton() {
        print(#function)
        imageView.showAnimatedGradientSkeleton()
        let urlString = "https://picsum.photos/2560/1440/?random"
        let url = URL(string: urlString)!
        Task {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let image = UIImage(data: data) {
                imageView.hideSkeleton()
                imageView.image = image
            }
        }
    }
}
