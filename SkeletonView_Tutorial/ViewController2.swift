//
//  ViewController2.swift
//  SkeletonView_Tutorial
//
//  Created by yc on 2023/02/18.
//

import UIKit
import SnapKit
import Then
import SkeletonView

final class ViewController2: UIViewController {
    
    private lazy var imageView = UIImageView().then {
        $0.isSkeletonable = true
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12.0
    }
    private lazy var titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16.0, weight: .semibold)
        $0.numberOfLines = 1
        $0.isSkeletonable = true
    }
    private lazy var contentLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14.0, weight: .semibold)
        $0.textColor = .secondaryLabel
        $0.numberOfLines = 0
        $0.isSkeletonable = true
    }
    private lazy var button = MyButton().then {
        $0.style = .fill(backgroundColor: .systemPink)
        $0.setTitle("Fetch", for: .normal)
        $0.addTarget(self, action: #selector(didTapFetchButton), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "스켈레톤2"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Next",
            style: .plain,
            target: self,
            action: #selector(didTapRightBarButton)
        )
        view.isSkeletonable = true
        setupUI()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetch()
    }
    
    private func setupUI() {
        [imageView, titleLabel, contentLabel, button].forEach { view.addSubview($0) }
        imageView.snp.makeConstraints {
            $0.size.equalTo(150.0)
            $0.leading.top.equalTo(view.safeAreaLayoutGuide).inset(16.0)
        }
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).offset(16.0)
            $0.top.equalTo(imageView.snp.top).inset(4.0)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(16.0)
        }
        contentLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(16.0)
            $0.bottom.equalTo(imageView.snp.bottom).inset(4.0)
        }
        button.snp.makeConstraints {
            $0.height.equalTo(48.0)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(16.0)
        }
    }
    
    private func fetch() {
        view.showAnimatedGradientSkeleton()
        let urlString = "https://picsum.photos/2560/1440/?random"
        let url = URL(string: urlString)!
        Task {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let image = UIImage(data: data) {
                view.hideSkeleton()
                imageView.image = image
                titleLabel.text = "Lorem ipsum dolor sit amet"
                contentLabel.text = "Praesent id augue scelerisque, malesuada lectus id, accumsan neque. Nunc dignissim eget tortor nec tincidunt. Vivamus tincidunt ex eu eleifend sagittis. Duis in leo lacus. Maecenas nisi ex, congue ut nulla at, cursus eleifend purus. Nulla maximus aliquam justo tempor auctor. Nulla feugiat risus a orci porttitor maximus. Cras dignissim a felis eu vestibulum. Nullam ac rhoncus velit, vel posuere arcu. Morbi urna est, lacinia quis finibus a, pretium convallis sapien. Morbi facilisis neque quam, eget hendrerit arcu iaculis sed. Phasellus posuere erat a nibh tincidunt, eu tincidunt leo cursus. Suspendisse non orci quis nibh aliquam dignissim. Donec faucibus mauris aliquam sodales ullamcorper. Vivamus pretium libero quis leo pretium, ut euismod metus fermentum. Praesent facilisis nec lorem interdum aliquam."
            }
        }
    }
    
    @objc func didTapFetchButton() {
        print(#function)
        fetch()
    }
    @objc func didTapRightBarButton() {
        print(#function)
        navigationController?.pushViewController(ViewController3(), animated: true)
    }
}
