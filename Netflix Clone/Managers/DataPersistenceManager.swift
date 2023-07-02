//
//  DataPersistenceManager.swift
//  Netflix Clone
//
//  Created by Dimas Wisodewo on 02/07/23.
//

import UIKit
import CoreData

class DataPersistenceManager {
    
    enum DatabaseError: Error {
        case failedToSave
        case failedToFetch
        case failedToDelete
    }
    
    static let shared = DataPersistenceManager()
    
    func downloadTitleWith(model: Title, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let titleItem = TitleItem(context: context)
        titleItem.id = Int64(model.id)
        titleItem.original_title = model.original_title ?? ""
        titleItem.overview = model.overview ?? ""
        titleItem.media_type = model.media_type ?? ""
        titleItem.poster_path = model.poster_path ?? ""
        titleItem.release_date = model.release_date ?? ""
        titleItem.vote_count = Int64(model.vote_count)
        titleItem.vote_average = model.vote_average

        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToSave))
        }
    }
    
    func fetchDownloadedTitles(completion: @escaping (Result<[TitleItem], Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<TitleItem>
        request = TitleItem.fetchRequest()
        
        do {
            let titles = try context.fetch(request)
            completion(.success(titles))
        } catch {
            completion(.failure(DatabaseError.failedToFetch))
        }
    }
    
    func deleteTitleWith(model: TitleItem, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            context.delete(model)
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToDelete))
        }
    }
}
