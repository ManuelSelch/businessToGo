public enum KimaiModel: Codable, Equatable {
    case customer(KimaiCustomer)
    case project(KimaiProject)
    case activity(KimaiActivity)
    case timesheet(KimaiTimesheet)
}
