//
//  NewsController.swift
//  AppcentAssignmentApp
//
//  Created by Saffet Emin Reisoğlu on 29.08.2021.
//

import UIKit
import NewsAPI

final class NewsController: UITableViewController {
    private let cellId = "cellId"
    private let informingCellId = "informingCellId"
    private let footerCellId = "footerCellId"
    
    private let viewModel: NewsViewModel
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchController())
        controller.searchBar.placeholder = "Search for news"
//        controller.obscuresBackgroundDuringPresentation = false
        return controller
    }()
    
    init() {
        viewModel = NewsViewModel()
        
        super.init(style: .grouped)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "News"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.backgroundColor = Color.backgroundDefault.value
        tableView.backgroundColor = Color.backgroundDefault.value
        
        tableView.register(NewsCell.self, forCellReuseIdentifier: cellId)
        tableView.register(InformingCell.self, forCellReuseIdentifier: informingCellId)
        tableView.register(FooterCell.self, forHeaderFooterViewReuseIdentifier: footerCellId)
        
//        tableView.contentInset = .init(top: Sizing.space20pt, left: Sizing.space16pt, bottom: Sizing.space20pt, right: Sizing.space16pt)
        tableView.alwaysBounceVertical = true
//        tableView.alwaysBounceHorizontal = false
        tableView.keyboardDismissMode = .interactive
        
        searchController.searchBar.delegate = self
        
        viewModel.delegate = self
        
        tableView.separatorStyle = .none
        
        viewModel.fetchData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension NewsController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.state {
        case .data:
            return viewModel.data?.items.count ?? 0
            
        case .emptyOrError,
             .loading:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.state {
        case .data:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! NewsCell
            
            if let item = viewModel.data?.items[safe: indexPath.item] {
                cell.setData(
                    imageUrl: item.urlToImage,
                    titleText: item.title ?? "No title",
                    descriptionText: item.description,
                    sourceAndDateText: "\(item.source?.name ?? "") • \(item.publishedAt ?? "")"
                )
            }
            
            return cell
            
        case .emptyOrError,
             .loading:
            let cell = tableView.dequeueReusableCell(withIdentifier: informingCellId, for: indexPath) as! InformingCell
            
            cell.setState(viewModel.state)
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let item = viewModel.data?.items[safe: indexPath.item] else {
//            return
//        }
        
        navigationController?.hidesBottomBarPushViewController(
            NewsDetailController(),
            animated: true
        )
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch viewModel.state {
        case .data:
//            let estimatedSize = EstimatedSizeUtility<NewsCell>.height(
//                width: view.frame.width
//            ) { [self] (cell) in
//                if let item = viewModel.data?.items[safe: indexPath.item] {
//                    cell.setData(
//                        imageUrl: nil,
//                        titleText: item.title ?? "No title",
//                        descriptionText: item.description,
//                        sourceAndDateText: "\(item.source?.name ?? "") • \(item.publishedAt ?? "")"
//                    )
//                }
//            }
//
//            return estimatedSize.height
            
            return UITableView.automaticDimension
        
            return FontType.body1.value.lineHeight + (2 * FontType.body3.value.lineHeight) + FontType.body4.value.lineHeight + 11 + 11
            
        case .emptyOrError,
             .loading:
            return 300
        }
        
//        return 200 //FontType.body1.value.lineHeight + (2 * FontType.body3.value.lineHeight) + FontType.body4.value.lineHeight
    }
}

// MARK: - Pagination

extension NewsController {
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: footerCellId) as! FooterCell
        
        footer.setData(animating: !(viewModel.data?.isDonePaginating ?? true))
        
        return footer
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard viewModel.state == .data,
              viewModel.data?.items.isNotEmpty ?? false,
              !(viewModel.data?.isDonePaginating ?? true) else {
            return .zero
        }
        
        return 200
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let count = viewModel.data?.items.count ?? 0
        
        guard viewModel.state == .data,
              count > 0,
              !(viewModel.data?.isPaginating ?? true),
              !(viewModel.data?.isDonePaginating ?? true),
              indexPath.item >= count - 1 else {
            return
        }
        
        viewModel.fetchDataForPagination()
    }
}

// MARK: - NewsViewModelModelDelegate

extension NewsController: NewsViewModelModelDelegate {
    func getData(error: ErrorModel?) {
        guard error == nil else {
            print(error?.message ?? "")
            
//            AlertUtility.present(
//                title: error?.title ?? "API Error",
//                message: error?.message ?? "An error has occurred.",
//                delegate: self
//            )
            
            tableView.reloadData()
            
            return
        }
        
        tableView.separatorStyle = .singleLine
        
        tableView.reloadData()
    }
}

// MARK: - UISearchBarDelegate

extension NewsController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {
            return
        }
        
//        viewModel.fetchData(query: text)
        
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        viewModel.reset()
        
        tableView.reloadData()
    }
}
