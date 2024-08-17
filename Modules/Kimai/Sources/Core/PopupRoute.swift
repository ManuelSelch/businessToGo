public enum KimaiPopupRoute: Codable, Equatable, Hashable {
    case customerDeleteNotAllowed(KimaiCustomer)
    case customerDeleteConfirmation(KimaiCustomer)
    
    case projectDeleteNotAllowed(KimaiProject)
    case projectDeleteConfirmation(KimaiProject)
    
    case activityDeleteConfirmation(KimaiActivity)
    
    case timesheetDeleteConfirmation(KimaiTimesheet)
}
