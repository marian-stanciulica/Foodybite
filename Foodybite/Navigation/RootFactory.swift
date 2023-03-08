//
//  RootFactory.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 08.03.2023.
//

import CoreData
import FoodybitePlaces
import FoodybiteNetworking
import FoodybitePersistence

class RootFactory {
    let apiService: FoodybiteNetworking.APIService = {
        let httpClient = FoodybiteNetworking.URLSessionHTTPClient()
        let tokenStore = KeychainTokenStore()
        
        let remoteResourceLoader = RemoteResourceLoader(client: httpClient)
        return APIService(loader: remoteResourceLoader,
                          sender: remoteResourceLoader,
                          tokenStore: tokenStore)
    }()
        
    let userStore: LocalStoreReader & LocalStoreWriter = {
        do {
            return try CoreDataLocalStore(
                storeURL: NSPersistentContainer
                    .defaultDirectoryURL()
                    .appendingPathComponent("foodybite-store.sqlite"))
            
        } catch {
            return NullUserStore()
        }
    }()
}
