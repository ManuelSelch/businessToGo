import Foundation
import SwiftUI
 
enum TaigaScreen: Equatable, Hashable {
    case projects
    case project(Int)
}

struct TaigaState: Equatable {
    var projects: [TaigaProject]
    var taskStoryStatus: [TaigaTaskStoryStatus]
    var taskStories: [TaigaTaskStory]
    var tasks: [TaigaTask]
    var milestones: [TaigaMilestone]
    var projectImages: [Int: CustomImage]
}


extension TaigaState {
    init(){
        projects = []
        taskStoryStatus = []
        taskStories = []
        tasks = []
        milestones = []
        projectImages = [:]
    }
}
