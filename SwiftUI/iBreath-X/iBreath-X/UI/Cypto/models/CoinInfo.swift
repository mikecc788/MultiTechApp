//
//  CoinInfo.swift
//  iBreath-X
//
//  Created by app on 2024/8/24.
//

import Foundation

class CoinInfo: Codable,Identifiable {
    let id, symbol, name: String
    let image: String
    let currentPrice: Double
    let marketCap: Double?
    let marketCapRank: Int?
    let fullyDilutedValuation: Double?
    let totalVolume: Double?
    let high24H, low24H: Double?
    let priceChange24H, priceChangePercentage24H: Double?
    let marketCapChange24H: Double?
    let marketCapChangePercentage24H: Double?
    let circulatingSupply, totalSupply, maxSupply, ath: Double?
    let athChangePercentage: Double?
    let athDate: String?
    let atl, atlChangePercentage: Double?
    let atlDate: String?
    let lastUpdated: String
    let priceChangePercentage24HInCurrency: Double?
    let sparklineIn7D: SparklineIn7D?
    let currentHolding: Double?
    
    init(id: String, symbol: String, name: String, image: String, currentPrice: Double, marketCap: Double?, marketCapRank: Int?, fullyDilutedValuation: Double?, totalVolume: Double?, high24H: Double?, low24H: Double?, priceChange24H: Double?, priceChangePercentage24H: Double?, marketCapChange24H: Double?, marketCapChangePercentage24H: Double?, circulatingSupply: Double?, totalSupply: Double?, maxSupply: Double?, ath: Double?, athChangePercentage: Double?, athDate: String?, atl: Double?, atlChangePercentage: Double?, atlDate: String?, lastUpdated: String, priceChangePercentage24HInCurrency: Double?, sparklineIn7D: SparklineIn7D?, currentHolding: Double?) {
        self.id = id
        self.symbol = symbol
        self.name = name
        self.image = image
        self.currentPrice = currentPrice
        self.marketCap = marketCap
        self.marketCapRank = marketCapRank
        self.fullyDilutedValuation = fullyDilutedValuation
        self.totalVolume = totalVolume
        self.high24H = high24H
        self.low24H = low24H
        self.priceChange24H = priceChange24H
        self.priceChangePercentage24H = priceChangePercentage24H
        self.marketCapChange24H = marketCapChange24H
        self.marketCapChangePercentage24H = marketCapChangePercentage24H
        self.circulatingSupply = circulatingSupply
        self.totalSupply = totalSupply
        self.maxSupply = maxSupply
        self.ath = ath
        self.athChangePercentage = athChangePercentage
        self.athDate = athDate
        self.atl = atl
        self.atlChangePercentage = atlChangePercentage
        self.atlDate = atlDate
        self.lastUpdated = lastUpdated
        self.priceChangePercentage24HInCurrency = priceChangePercentage24HInCurrency
        self.sparklineIn7D = sparklineIn7D
        self.currentHolding = currentHolding
    }
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case fullyDilutedValuation = "fully_diluted_valuation"
        case totalVolume = "total_volume"
        case high24H = "high_24h"
        case low24H = "low_24h"
        case priceChange24H = "price_change_24h"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case marketCapChange24H = "market_cap_change_24h"
        case marketCapChangePercentage24H = "market_cap_change_percentage_24h"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case ath
        case athChangePercentage = "ath_change_percentage"
        case athDate = "ath_date"
        case atl
        case atlChangePercentage = "atl_change_percentage"
        case atlDate = "atl_date"
        case lastUpdated = "last_updated"
        case priceChangePercentage24HInCurrency = "price_change_percentage_24h_in_currency"
        case sparklineIn7D = "sparkline_in_7d"
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        symbol = try container.decode(String.self, forKey: .symbol)
        name = try container.decode(String.self, forKey: .name)
        image = try container.decode(String.self, forKey: .image)
        currentPrice = try container.decode(Double.self, forKey: .currentPrice)
        marketCap = try container.decodeIfPresent(Double.self, forKey: .marketCap)
        marketCapRank = try container.decodeIfPresent(Int.self, forKey: .marketCapRank)
        fullyDilutedValuation = try container.decodeIfPresent(Double.self, forKey: .fullyDilutedValuation)
        totalVolume = try container.decodeIfPresent(Double.self, forKey: .totalVolume)
        high24H = try container.decodeIfPresent(Double.self, forKey: .high24H)
        low24H = try container.decodeIfPresent(Double.self, forKey: .low24H)
        priceChange24H = try container.decodeIfPresent(Double.self, forKey: .priceChange24H)
        priceChangePercentage24H = try container.decodeIfPresent(Double.self, forKey: .priceChangePercentage24H)
        marketCapChange24H = try container.decodeIfPresent(Double.self, forKey: .marketCapChange24H)
        marketCapChangePercentage24H = try container.decodeIfPresent(Double.self, forKey: .marketCapChangePercentage24H)
        circulatingSupply = try container.decodeIfPresent(Double.self, forKey: .circulatingSupply)
        totalSupply = try container.decodeIfPresent(Double.self, forKey: .totalSupply)
        maxSupply = try container.decodeIfPresent(Double.self, forKey: .maxSupply)
        ath = try container.decodeIfPresent(Double.self, forKey: .ath)
        athChangePercentage = try container.decodeIfPresent(Double.self, forKey: .athChangePercentage)
        athDate = try container.decodeIfPresent(String.self, forKey: .athDate)
        atl = try container.decodeIfPresent(Double.self, forKey: .atl)
        atlChangePercentage = try container.decodeIfPresent(Double.self, forKey: .atlChangePercentage)
        atlDate = try container.decodeIfPresent(String.self, forKey: .atlDate)
        lastUpdated = try container.decode(String.self, forKey: .lastUpdated)
        priceChangePercentage24HInCurrency = try container.decodeIfPresent(Double.self, forKey: .priceChangePercentage24HInCurrency)
        sparklineIn7D = try container.decodeIfPresent(SparklineIn7D.self, forKey: .sparklineIn7D)
        currentHolding = nil
    }
    
    
    static func fetchCoin(by id:String,completion: @escaping (Result<CoinInfo, Error>)->Void) {
        let urlString = "https://api.coingecko.com/api/v3/coins/\(id)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let coin = try JSONDecoder().decode(CoinInfo.self, from: data)
                completion(.success(coin))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // Hacer un refresh facilmente
    func refresh(completion: @escaping (Result<CoinInfo, Error>) -> Void) {
        CoinInfo.fetchCoin(by: self.id) { result in
            switch result {
            case .success(let updatedCoin):
                completion(.success(updatedCoin))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    var currentHoldingsValue: Double {
           return (currentHolding ?? 0) * self.currentPrice
    }
       
    var rank: Int {
           return Int(marketCapRank ?? 0)
    }
    
    
}

// MARK: - SparklineIn7D
class SparklineIn7D: Codable {
    let price: [Double]

    init(price: [Double]) {
        self.price = price
    }
}
