import Combine

protocol IIntegrationService {
    func setIntegration(_ kimaiProjectId: Int, _ taigaProjectId: Int)
    func getTaigaProject(_ kimaiProject: Int) -> AnyPublisher<Integration?, Error>
    func get() -> [Integration]
    func get(by id: Int) -> Integration?
}
