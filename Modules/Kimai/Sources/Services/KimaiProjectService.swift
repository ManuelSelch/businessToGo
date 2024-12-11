import Dependencies
import OfflineSyncServices

import KimaiCore

struct KimaiProjectService {
    static var live: RecordService<KimaiProject> = .init(
        repository: .init("kimai_projects"),
        requestService: RequestService.live(
            fetchMethod: {KimaiAPI.getProjects},
            insertMethod: KimaiAPI.insertProject,
            updateMethod: KimaiAPI.updateProject,
            deleteMethod: nil
        ),
        keyMapping: KeyMappingTable.shared
    )
    static var  mock: RecordService<KimaiProject> = .init(
        repository: .init("kimai_projects"),
        requestService: RequestService.mock(
            fetchMethod: {KimaiAPI.getProjects},
            insertMethod: KimaiAPI.insertProject,
            updateMethod: KimaiAPI.updateProject,
            deleteMethod: nil
        ),
        keyMapping: KeyMappingTable.shared
    )
}

