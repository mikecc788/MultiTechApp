//
//  CyptoViewModel.swift
//  iBreath-X
//
//  Created by app on 2024/8/27.
//

import Foundation
import Combine

class CyptoViewModel: ObservableObject,Identifiable {
    @Published var statistics: [StatiticsModel] = []
    @Published var allCoins: [CoinInfo] = []
    @Published var portfolioCoins: [CoinInfo] = []
    private let coinDataService = CoinDataServices()
    private let marketDataService = MarketDataServices()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var searchText: String = ""
    @Published var sortOption: SortOption = .holdings
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        
    }
}
enum SortOption {
    case rank, rankReversed, holdings, holdingsReversed
}
