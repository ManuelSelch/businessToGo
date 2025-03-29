import Dependencies
import OfflineSyncCore
import OfflineSyncServices
import Moya

import KimaiCore

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    func removeDuplicates() -> Self {
        return self.removingDuplicates()
    }
}

public struct KimaiCustomerService {
    var customerRepository: DatabaseRepository<KimaiCustomer>
    var teamRepository: DatabaseRepository<KimaiTeam>
    
    var requestService: any RequestServiceProtocol<KimaiCustomerDTO>
    var customerSyncService: SyncService<KimaiCustomer>
    
    public init(
        customerRepository: DatabaseRepository<KimaiCustomer>,
        teamRepository: DatabaseRepository<KimaiTeam>,
        requestService: any RequestServiceProtocol<KimaiCustomerDTO>
    ) {
        self.customerRepository = customerRepository
        self.teamRepository = teamRepository
        self.requestService = requestService
        
        self.customerSyncService = .init(
            repository: customerRepository,
            remoteInsert: { try await requestService.insert( KimaiCustomerDTO(from: $0) ).toModel() },
            remoteUpdate: { try await requestService.update( KimaiCustomerDTO(from: $0) ).toModel() },
            remoteDelete: nil
            // keyMapping: KeyMappingTable.shared
        )
    }
    
    public func getCustomers() -> [KimaiCustomer] {
        return customerRepository.get()
    }
    public func getTeams() -> [KimaiTeam] {
        return teamRepository.get()
    }
    
    public func createCustomer(_ model: KimaiCustomer) {
        var model = model
        model.id = customerRepository.getLastId() + 1
        customerRepository.insert(model, isTrack: true)
    }
    
    public func updateCustomer(_ model: KimaiCustomer) {
        customerRepository.update(model, isTrack: true)
    }
    
    public func deleteCustomer(_ id: Int) {
        customerRepository.delete(id, isTrack: true)
    }
    
    public func fetch() async throws -> ([KimaiCustomer], [KimaiTeam]) {
        let records = try await requestService.fetch()
        
        let customers = records.map { $0.toModel() }
        let teams = records.flatMap {$0.teams}.removeDuplicates()
        
        return (customers, teams)
    }
    
    public func sync() async throws -> ([KimaiCustomer], [KimaiTeam]) {
        let localCustomers = customerRepository.get()
        
        let (remoteCustomers, remoteTeams) = try await fetch()
        
        let syncedCustomers = try await customerSyncService.sync(localRecords: localCustomers, remoteRecords: remoteCustomers)
        return (syncedCustomers, remoteTeams)
    }
    
    public func getCustomerChanges() -> [DatabaseChange] {
        return customerRepository.getChanges()
    }
    
    public func setPlugins(_ plugins: [PluginType]) {
        requestService.setPlugins(plugins)
    }
    
    
}

public extension KimaiCustomerService {
    static var live: Self {
        return .init(
            customerRepository: .init("kimai_customers"),
            teamRepository: .init("kimai_teams"),
            requestService: RequestService.live(
                fetchMethod: {KimaiAPI.getCustomers},
                insertMethod: KimaiAPI.insertCustomer,
                updateMethod: KimaiAPI.updateCustomer
            )
        )
    }
    
    static var mock: Self {
        return .init(
            customerRepository: .init("kimai_customers"),
            teamRepository: .init("kimai_teams"),
            requestService: RequestService.mock(
                fetchMethod: {KimaiAPI.getCustomers},
                insertMethod: KimaiAPI.insertCustomer,
                updateMethod: KimaiAPI.updateCustomer
            )
        )
    }
}
