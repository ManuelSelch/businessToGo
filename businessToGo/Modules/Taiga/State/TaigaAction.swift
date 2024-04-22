import Foundation
import SwiftUI

enum TaigaAction {
    case navigate(TaigaScreen)
    
    case sync
    
    case projects(RequestAction<TaigaProject>)
    case milestones(RequestAction<TaigaMilestone>)
    case statusList(RequestAction<TaigaTaskStoryStatus>)
    case taskStories(RequestAction<TaigaTaskStory>)
    case tasks(RequestAction<TaigaTask>)
    
    // todo: action for: var projectImages: [Int: UIImage]
    
    case loadImage(TaigaProject)
    case setImage(Int, UIImage)
    
    case setStatus(TaigaTaskStory, TaigaTaskStoryStatus)
}
