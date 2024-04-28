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
    
    case loadImage(TaigaProject)
    case setImage(Int, UIImage)
}
