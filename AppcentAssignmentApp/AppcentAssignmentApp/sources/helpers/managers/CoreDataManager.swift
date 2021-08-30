//
//  CoreDataManager.swift
//  AppcentAssignmentApp
//
//  Created by Saffet Emin Reisoğlu on 30.08.2021.
//

import Foundation
import CoreData
import NewsAPI

typealias NewsCDModels = [NewsCDModel]

final class CoreDataManager {
    private init() {}
    static let shared = CoreDataManager()
    
    private var datas = NewsCDModels()
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "AAACDModels")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    func saveContext () {
        guard context.hasChanges else {
            return
        }
        
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    // MARK: - CRUD
    
    // Create
    
    func createNews(data: NewsModel) {
        let news = NewsCDModel(context: context)
        news.id = data.id
        news.sourceName = data.sourceName
        news.author = data.author
        news.title = data.title
        news.description_ = data.description
        news.url = data.url
        news.imageUrl = data.imageUrl
        news.publishedAt = data.publishedAt
        news.content = data.content
        
        saveContext()
        
        datas.append(news)
        
        NotificationCenter.default.post(
            name: .updateFavoriteNews,
            object: nil
        )
    }
    
    // Read
    
    func fetchData() {
        let fetchRequest: NSFetchRequest<NewsCDModel> = NewsCDModel.fetchRequest()
        
        do {
            datas = try context.fetch(fetchRequest)
        } catch let fetchErr {
            print("Failed to fetch:", fetchErr)
        }
    }
    
    func hasNews(id: String) -> Bool {
        return datas.contains(where: { $0.id == id })
    }
    
    // Delete
    
    func deleteNews(id: String) {
        guard let index = datas.firstIndex(where: { $0.id == id }) else {
            return
        }
        
        let data = datas[index]
        
        datas.remove(at: index)
        
        context.delete(data)
        
        saveContext()
        
        NotificationCenter.default.post(
            name: .updateFavoriteNews,
            object: nil
        )
    }
    
    // MARK: -
    
    func getDatas() -> NewsModels {
        return coreDataToModel(datas: datas)
    }
    
    private func coreDataToModel(datas: [NewsCDModel]) -> NewsModels {
        var convertedDatas = NewsModels()
        
        for data in datas {
            convertedDatas.append(.init(
                id: data.id ?? "",
                sourceName: data.sourceName,
                author: data.author,
                title: data.title,
                description: data.description_,
                url: data.url,
                imageUrl: data.imageUrl,
                publishedAt: data.publishedAt,
                content: data.content
            ))
        }
        
        return convertedDatas
    }
}
