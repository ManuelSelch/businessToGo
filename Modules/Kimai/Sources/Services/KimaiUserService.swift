import Dependencies
import OfflineSyncServices

import KimaiCore

struct UsersKey: DependencyKey {
    static var liveValue: RecordService<KimaiUser> = .init(
        repository: .init("kimai_users"),
        requestService: RequestService.live(
            fetchMethod: {KimaiAPI.getUsers}
        )
    )
    static var mockValue: RecordService<KimaiUser> = .init(
        repository: .init("kimai_users"),
        requestService: RequestService.mock(
            fetchMethod: {KimaiAPI.getUsers}
        )
    )
}


extension DependencyValues {
    var users: RecordService<KimaiUser> {
        get { Self[UsersKey.self] }
        set { Self[UsersKey.self] = newValue }
    }
}
