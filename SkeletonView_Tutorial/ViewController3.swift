//
//  ViewController3.swift
//  SkeletonView_Tutorial
//
//  Created by yc on 2023/02/19.
//


import UIKit
import SnapKit
import Then
import SkeletonView

struct Item {
    let image: UIImage
    let title: String
    let content: String
}

final class ViewController3: UIViewController {
    
    private lazy var tableView = UITableView().then {
        $0.dataSource = self
        $0.delegate = self
        $0.rowHeight = 150.0 + 16.0 * 2
        $0.isSkeletonable = true
        $0.register(
            MyCell.self,
            forCellReuseIdentifier: MyCell.id
        )
    }
    
    private lazy var button = MyButton().then {
        $0.style = .fill(backgroundColor: .systemPink)
        $0.setTitle("Fetch", for: .normal)
        $0.addTarget(
            self,
            action: #selector(didTapFetchButton),
            for: .touchUpInside
        )
    }
    
    var items = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "스켈레톤3"
        view.isSkeletonable = true
        setupUI()
    }
    
    private func fetch() {
        print(#function)
        view.showAnimatedGradientSkeleton()
        let urlString = "https://picsum.photos/2560/1440/?random"
        let url = URL(string: urlString)!
        Task {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let image = UIImage(data: data) {
                view.hideSkeleton()
                items = Array(repeating: Item(image: image, title: "Lorem ipsum dolor sit amet", content: "Praesent id augue scelerisque, malesuada lectus id, accumsan neque."), count: 10)
                tableView.reloadData()
            }
        }
    }
    
    @objc func didTapFetchButton() {
        print(#function)
        fetch()
    }
    
    private func setupUI() {
        [tableView, button].forEach { view.addSubview($0) }
        
        tableView.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        button.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.bottom).offset(16.0)
            $0.height.equalTo(48.0)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(16.0)
        }
    }
}

extension ViewController3: SkeletonTableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count == 0 ? 10 : items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MyCell.id,
            for: indexPath
        ) as? MyCell else {
            return UITableViewCell()
        }
        
        if !items.isEmpty {
            let item = items[indexPath.row]
            
            cell.setupView(item: item)
        }
        
        return cell
    }
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return MyCell.id
    }
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

final class MyCell: UITableViewCell {
    static let id = "CELL"
    
    private lazy var iView = UIImageView().then {
        $0.isSkeletonable = true
    }
    private lazy var tLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16.0, weight: .semibold)
        $0.isSkeletonable = true
    }
    private lazy var cLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14.0, weight: .medium)
        $0.textColor = .secondaryLabel
        $0.isSkeletonable = true
        $0.numberOfLines = 0
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(item: Item) {
        iView.image = item.image
        tLabel.text = item.title
        cLabel.text = item.content
    }
    func setupUI() {
        print("1")
        self.isSkeletonable = true
        [iView, tLabel, cLabel].forEach { contentView.addSubview($0) }
        
        iView.snp.makeConstraints {
            $0.size.equalTo(150.0)
            $0.leading.top.bottom.equalToSuperview().inset(16.0)
        }
        tLabel.snp.makeConstraints {
            $0.leading.equalTo(iView.snp.trailing).offset(16.0)
            $0.top.equalTo(iView.snp.top).inset(8.0)
            $0.trailing.equalToSuperview().inset(16.0)
        }
        cLabel.snp.makeConstraints {
            $0.leading.equalTo(tLabel.snp.leading)
            $0.top.equalTo(tLabel.snp.bottom).offset(8.0)
            $0.trailing.equalTo(tLabel.snp.trailing)
            $0.bottom.equalTo(iView.snp.bottom).inset(8.0)
        }
    }
}
