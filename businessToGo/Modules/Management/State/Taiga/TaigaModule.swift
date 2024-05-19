import Foundation
import SwiftUI
import OfflineSync

struct TaigaModule {
    
    struct State: Equatable, Codable {
        var projects: [TaigaProject] = []
        var taskStoryStatus: [TaigaTaskStoryStatus] = []
        var taskStories: [TaigaTaskStory] = []
        var tasks: [TaigaTask] = []
        var milestones: [TaigaMilestone] = []
        // var projectImages: [Int: CustomImage] = []
        
        var projectTracks: [DatabaseChange] = []
        var statusTracks: [DatabaseChange] = []
        var storyTracks: [DatabaseChange] = []
        var taskTracks: [DatabaseChange] = []
        var milestoneTracks: [DatabaseChange] = []
        
    }
    
    enum Action {
        case sync
        
        case projects(RequestAction<TaigaProject>)
        case milestones(RequestAction<TaigaMilestone>)
        case statusList(RequestAction<TaigaTaskStoryStatus>)
        case taskStories(RequestAction<TaigaTaskStory>)
        case tasks(RequestAction<TaigaTask>)
        
        case loadImage(TaigaProject)
        case setImage(Int, CustomImage)
    }
    
    struct Dependency {
        var taiga: TaigaService
        var track: TrackTable
    }

}
