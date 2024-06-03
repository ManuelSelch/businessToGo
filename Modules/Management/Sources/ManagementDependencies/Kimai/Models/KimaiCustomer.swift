import Foundation
import OfflineSync
import SwiftUI

public struct KimaiCustomer: TableProtocol, Hashable {
    public var id: Int
    public var name: String
    public var number: String?
    public var color: String?
    public var teams: [Int]
}

extension KimaiCustomer {
    
    enum CodingKeys: String, CodingKey {
           case id, name, number, color, teams
       }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
       
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.number = try container.decodeIfPresent(String.self, forKey: .number)
        self.color = try container.decodeIfPresent(String.self, forKey: .color)
        
        do {
            // decode from remote server
            let teamContainers = try container.decode([KimaiTeam].self, forKey: .teams)
            self.teams = teamContainers.map { $0.id }
        } catch {
            do {
                // decode from database
                self.teams = try container.decode([Int].self, forKey: .teams)
            } catch {
                print("decode error: \(error)")
                self.teams = []
            }
        }
    }
    
    public init() {
        id = -1
        name = ""
        number = ""
        color = ""
        teams = []
    }
    
    public static let new = KimaiCustomer()
    public static let sample = KimaiCustomer(id: 0, name: "Customer 1", teams: [])
}



