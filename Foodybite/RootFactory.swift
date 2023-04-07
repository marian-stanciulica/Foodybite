//
//  RootFactory.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 08.03.2023.
//

import Domain
import CoreData
import API_Infra
import FoodybitePlaces
import FoodybiteNetworking
import FoodybitePersistence

final class RootFactory {
    let apiService: APIService = {
        let session = URLSession(configuration: .ephemeral)
        let httpClient = URLSessionHTTPClient(session: session)
        let tokenStore = KeychainTokenStore()

        let remoteResourceLoader = RemoteStore(client: httpClient)
        return APIService(loader: remoteResourceLoader,
                          sender: remoteResourceLoader,
                          tokenStore: tokenStore)
    }()

    static let localStore: LocalStore = {
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
