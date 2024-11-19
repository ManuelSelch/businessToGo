import Dependencies
import OfflineSyncServices

import KimaiCore

struct ProjectsKey: DependencyKey {
    static var liveValue: RecordService<KimaiProject> = .init(
        repository: .init("kimai_projects"),
        requestService: RequestService.live(
            fetchMethod: {KimaiAPI.getProjects},
            insertMethod: KimaiAPI.insertProject,
            updateMethod: KimaiAPI.updateProject,
            deleteMethod: nil
        )
    )
    static var mockValue: RecordService<KimaiProject> = .init(
        repository: .init("kimai_projects"),
        requestService: RequestService.mock(
            fetchMethod: {KimaiAPI.getProjects},
            insertMethod: KimaiAPI.insertProject,
            updateMethod: KimaiAPI.updateProject,
            deleteMethod: nil
        )
    )
}


extension DependencyValues {
    var projects: RecordService<KimaiProject> {
        get { Self[ProjectsKey.self] }
        set { Self[ProjectsKey.self] = newValue }
    }
}
