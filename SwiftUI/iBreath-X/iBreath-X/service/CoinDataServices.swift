//
//  CoinDataServices.swift
//  iBreath-X
//
//  Created by app on 2024/8/24.
//

import Foundation
import Combine

class CoinDataServices {
    @Published var allCoins: [CoinInfo] = []
    var coinSubscription: AnyCancellable?
    init() {
        getAllCoins()
    }
    
    func getAllCoins() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=false") else { return }
        
        coinSubscription = NetworkingManager.download(url: url)
            .decode(type: [CoinInfo].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
                self?.coinSubscription?.cancel()
            })
            
            
    }
}
