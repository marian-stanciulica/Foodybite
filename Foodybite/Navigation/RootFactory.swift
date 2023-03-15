//
//  RootFactory.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 08.03.2023.
//

import Domain
import CoreData
import SharedAPI
import FoodybitePlaces
import FoodybiteNetworking
import FoodybitePersistence

class RootFactory {
    let apiService: FoodybiteNetworking.APIService = {
        let httpClient = SharedAPI.URLSessionHTTPClient()
        let tokenStore = KeychainTokenStore()
        
        let remoteResourceLoader = RemoteStore(client: httpClient)
        return APIService(loader: remoteResourceLoader,
                          sender: remoteResourceLoader,
                          tokenStore: tokenStore)
    }()
        
    static let localStore: LocalStore & GetReviewsService & ReviewsCache = {
        do {
            return try CoreDataLocalStore(
                storeURL: NSPersistentContainer
                    .defaultDirectoryURL()
                    .appendingPathComponent("foodybite-store.sqlite"))
            
        } catch {
            return NullLocalStore()
        }
    }()
    
    let userDAO = UserDAO(store: localStore)
}
