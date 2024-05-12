import Foundation
import SwiftUI
import OfflineSync

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
    
    var projectTracks: [DatabaseChange]
    var statusTracks: [DatabaseChange]
    var storyTracks: [DatabaseChange]
    var taskTracks: [DatabaseChange]
    var milestoneTracks: [DatabaseChange]
    
}


extension TaigaState {
    init(){
        projects = []
        taskStoryStatus = []
        taskStories = []
        tasks = []
        milestones = []
        projectImages = [:]
        
        projectTracks = []
        statusTracks = []
        storyTracks = []
        taskTracks = []
        milestoneTracks = []
    }
}
