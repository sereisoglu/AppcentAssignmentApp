//
//  NewsController.swift
//  AppcentAssignmentApp
//
//  Created by Saffet Emin Reisoğlu on 29.08.2021.
//

import UIKit
import NewsAPI

final class NewsController: UITableViewController {
    private let headerCellId = "headerCellId"
    private let cellId = "cellId"
    private let informingCellId = "informingCellId"
    private let footerCellId = "footerCellId"
    
    private let viewModel: NewsViewModel
    
    private let searchResultsController = SearchResultsController()
    
    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: searchResultsController)
        controller.searchBar.placeholder = "Search for news"
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
        
        tableView.register(NewsHeaderCell.self, forHeaderFooterViewReuseIdentifier: headerCellId)
        tableView.register(NewsCell.self, forCellReuseIdentifier: cellId)
        tableView.register(InformingCell.self, forCellReuseIdentifier: informingCellId)
        tableView.register(FooterCell.self, forHeaderFooterViewReuseIdentifier: footerCellId)
        
        tableView.alwaysBounceVertical = true
        tableView.keyboardDismissMode = .interactive
        tableView.separatorStyle = .none
        
        searchController.searchBar.delegate = self
        
        viewModel.delegate = self
        
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
                    sourceAndDateText: "\(item.source?.name ?? "") • \(DateUtility.stringFormat(convertType: .monthAndDayAndYearAndDayNameAndTime, dateString: item.publishedAt) ?? "")"
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
        guard let data = viewModel.data?.items[safe: indexPath.item] else {
            return
        }
        
        navigationController?.hidesBottomBarPushViewController(
            NewsDetailController(data: data),
            animated: true
        )
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch viewModel.state {
        case .data:
            return UITableView.automaticDimension
            
        case .emptyOrError,
             .loading:
            return 300
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerCellId) as! NewsHeaderCell
        
        header.setData(text: "Top Headlines (\(LocalizationUtility.getRegionCode().uppercased()))")
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Sizing.space10pt + FontType.title3.value.lineHeight + Sizing.space10pt
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

// MARK: - NewsViewModelDelegate

extension NewsController: NewsViewModelDelegate {
    func getData(error: ErrorModel?) {
        guard error == nil else {
            print(error?.message ?? "")
            
            AlertUtility.present(
                title: error?.title ?? "API Error",
                message: error?.message ?? "An error has occurred.",
                delegate: self
            )
            
            tableView.reloadData()
            
            return
        }
        
        if viewModel.state == .data {
            tableView.separatorStyle = .singleLine
        }
        
        tableView.reloadData()
    }
}

// MARK: - UISearchBarDelegate

extension NewsController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchResultsController.searchButtonTapped(searchBar)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchResultsController.cancelButtonTapped(searchBar)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchResultsController.cancelButtonTapped(searchBar)
        }
    }
}
