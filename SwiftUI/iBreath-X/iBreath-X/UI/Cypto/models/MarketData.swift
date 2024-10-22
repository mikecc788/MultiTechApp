//
//  MarketData.swift
//  iBreath-X
//
//  Created by app on 2024/8/24.
//

// URL: https://api.coingecko.com/api/v3/global

import Foundation
// MARK: - Welcome
class GlobalData: Codable {
    let data: MarketData?

    init(data: MarketData?) {
        self.data = data
    }
}

// MARK: - DataClass
class MarketData: Codable {
    let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double

    init(totalMarketCap: [String: Double], totalVolume: [String: Double], marketCapPercentage: [String: Double], marketCapChangePercentage24HUsd: Double) {
        self.totalMarketCap = totalMarketCap
        self.totalVolume = totalVolume
        self.marketCapPercentage = marketCapPercentage
        self.marketCapChangePercentage24HUsd = marketCapChangePercentage24HUsd
    }
    
    enum CodingKeys: String, CodingKey {
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
    }
    
    var marketCap: String {
        if let item = totalMarketCap.first(where: { $0.key == "usd"}) {
            return item.value.formattedInBnOrTrn()
        }
        return ""
    }
    
    var volume: String {
        if let item = totalVolume.first(where: { $0.key == "usd"}) {
            return item.value.formattedInBnOrTrn()
        }
        return ""
    }
    
    var btcDominance: String {
        if let item = marketCapPercentage.first(where: { $0.key == "btc"}) {
            return String(format: "%.2f%%", item.value)
        }
        return ""
    }
}
