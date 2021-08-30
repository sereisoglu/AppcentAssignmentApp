//
//  NewsDetailController.swift
//  AppcentAssignmentApp
//
//  Created by Saffet Emin Reisoğlu on 29.08.2021.
//

import UIKit
import NewsAPI

final class NewsDetailController: UITableViewController {
    private let headerCellId = "headerCellId"
    private let bodyCellId = "bodyCellId"
    private let redirectCellId = "redirectCellId"
    
    private var isFavorite: Bool
    private let data: NewsModel
    
    init(data: NewsModel) {
        self.data = data
        self.isFavorite = CoreDataManager.shared.hasNews(id: data.id)
        
        super.init(style: .grouped)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = data.sourceName ?? ""
        navigationItem.largeTitleDisplayMode = .never
        
        view.backgroundColor = Color.backgroundDefault.value
        tableView.backgroundColor = Color.backgroundDefault.value
        
        tableView.register(NewsDetailHeaderCell.self, forCellReuseIdentifier: headerCellId)
        tableView.register(NewsDetailBodyCell.self, forCellReuseIdentifier: bodyCellId)
        tableView.register(NewsDetailRedirectCell.self, forCellReuseIdentifier: redirectCellId)
        
        tableView.alwaysBounceVertical = true
        tableView.separatorStyle = .none
        
        setUpRightBarButtonItems()
    }
    
    private func setUpRightBarButtonItems() {
        navigationItem.rightBarButtonItems = [
            .init(image: isFavorite ? Icon.heartFill.value : Icon.heart.value, style: .plain, target: self, action: #selector(handleFavoriteButton)),
            .init(image: Icon.squareAndArrowUp.value, style: .plain, target: self, action: #selector(handleShareButton))
        ]
    }
    
    @objc
    private func handleFavoriteButton() {
        isFavorite.toggle()
        
        if isFavorite {
            CoreDataManager.shared.createNews(data: data)
        } else {
            CoreDataManager.shared.deleteNews(id: data.id)
        }
        
        setUpRightBarButtonItems()
    }
    
    @objc
    private func handleShareButton() {
        guard let title = data.title,
              let urlString = data.url,
              let url = NSURL(string: urlString) else {
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: [title, url] , applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceView = view
        present(activityViewController, animated: true, completion: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension NewsDetailController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: headerCellId, for: indexPath) as! NewsDetailHeaderCell
            
            cell.setData(imageUrl: data.imageUrl)
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: bodyCellId, for: indexPath) as! NewsDetailBodyCell
            
            cell.setData(
                titleText: data.title,
                descriptionText: data.description,
                authorText: data.author,
                dateText: DateUtility.stringFormat(convertType: .monthAndDayAndYearAndDayNameAndTime, dateString: data.publishedAt),
                contentText: data.content
            )
            
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: redirectCellId, for: indexPath) as! NewsDetailRedirectCell
            
            cell.setData(
                sourceText: data.sourceName ?? "News Source"
            )
            
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 2:
            guard let urlString = data.url else {
                return
            }
            
            BrowserUtility.openInsideOfApp(urlString: urlString, delegate: self)
            
        default:
            return
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            if let _ = data.imageUrl {
                return Sizing.imageViewDetail.height
            } else {
                return UITableView.automaticDimension
            }
            
        default:
            return UITableView.automaticDimension
        }
    }
}
