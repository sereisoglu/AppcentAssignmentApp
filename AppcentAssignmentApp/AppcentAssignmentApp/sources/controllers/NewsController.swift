//
//  NewsController.swift
//  AppcentAssignmentApp
//
//  Created by Saffet Emin Reisoğlu on 29.08.2021.
//

import UIKit
import NewsAPI

final class NewsController: UITableViewController {
    enum State {
        case `default`
        case search
    }
    
    private let headerCellId = "headerCellId"
    private let cellId = "cellId"
    private let informingCellId = "informingCellId"
    private let footerCellId = "footerCellId"
    
    private var state: State = .default
    
    private let newsViewModel: NewsViewModel
    
    private let searchResultsViewModel: SearchResultsViewModel
    
    private var viewModelState: InformingState {
        get {
            switch state {
            case .default:
                return newsViewModel.state
            case .search:
                return searchResultsViewModel.state
            }
        }
    }
    
    private var viewModelData: PaginationModel<NewsModel>? {
        get {
            switch state {
            case .default:
                return newsViewModel.data
            case .search:
                return searchResultsViewModel.data
            }
        }
    }
    
    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchBar.placeholder = "Search for news"
        controller.obscuresBackgroundDuringPresentation = false
        return controller
    }()
    
    init() {
        newsViewModel = NewsViewModel()
        searchResultsViewModel = SearchResultsViewModel()
        
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
        
        newsViewModel.delegate = self
        searchResultsViewModel.delegate = self
        
        newsViewModel.fetchData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension NewsController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModelState {
        case .data:
            return viewModelData?.items.count ?? 0
            
        case .emptyOrError,
             .loading:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModelState {
        case .data:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! NewsCell
            
            if let item = viewModelData?.items[safe: indexPath.item] {
                cell.setData(
                    imageUrl: item.imageUrl,
                    titleText: item.title ?? "No title",
                    descriptionText: item.description,
                    sourceAndDateText: "\(item.sourceName ?? "") • \(DateUtility.stringFormat(convertType: .monthAndDayAndYearAndDayNameAndTime, dateString: item.publishedAt) ?? "")"
                )
            }
            
            return cell
            
        case .emptyOrError,
             .loading:
            let cell = tableView.dequeueReusableCell(withIdentifier: informingCellId, for: indexPath) as! InformingCell
            
            cell.setState(viewModelState)
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = viewModelData?.items[safe: indexPath.item] else {
            return
        }
        
        navigationController?.hidesBottomBarPushViewController(
            NewsDetailController(data: data),
            animated: true
        )
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch viewModelState {
        case .data:
            return UITableView.automaticDimension
            
        case .emptyOrError,
             .loading:
            return 300
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerCellId) as! NewsHeaderCell
        
        switch state {
        case .default:
            header.setData(text: "Top Headlines (\(LocalizationUtility.getRegionCode().uppercased()))")
        case .search:
            if let itemCount = viewModelData?.itemCount {
                header.setData(text: "Search (\(itemCount))")
            } else {
                header.setData(text: "Search")
            }
        }
        
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
        
        footer.setData(animating: !(viewModelData?.isDonePaginating ?? true))
        
        return footer
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard viewModelState == .data,
              viewModelData?.items.isNotEmpty ?? false,
              !(viewModelData?.isDonePaginating ?? true) else {
            return .zero
        }
        
        return 200
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let count = viewModelData?.items.count ?? 0
        
        guard viewModelState == .data,
              count > 0,
              !(viewModelData?.isPaginating ?? true),
              !(viewModelData?.isDonePaginating ?? true),
              indexPath.item >= count - 1 else {
            return
        }
        
        switch state {
        case .default:
            newsViewModel.fetchDataForPagination()
        case .search:
            searchResultsViewModel.fetchDataForPagination()
        }
    }
}

// MARK: - NewsViewModelDelegate

extension NewsController: NewsViewModelDelegate {
    func getDataForNewsViewModel(error: ErrorModel?) {
        guard state == .default else {
            return
        }
        
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
        
        if viewModelState == .data {
            tableView.separatorStyle = .singleLine
        } else {
            tableView.separatorStyle = .none
        }
        
        tableView.reloadData()
    }
}

// MARK: - SearchResultsViewModelDelegate

extension NewsController: SearchResultsViewModelDelegate {
    func getDataForSearchResultsViewModel(error: ErrorModel?) {
        guard state == .search else {
            return
        }
        
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

        if viewModelState == .data {
            tableView.separatorStyle = .singleLine
        } else {
            tableView.separatorStyle = .none
        }

        tableView.reloadData()
    }
}

// MARK: - UISearchBarDelegate

extension NewsController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {
            return
        }
        
        state = .search
        
        tableView.separatorStyle = .none
        
        searchResultsViewModel.fetchData(query: text)
        
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        state = .default
        
        searchResultsViewModel.reset()
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchBarCancelButtonClicked(searchBar)
        }
    }
}
