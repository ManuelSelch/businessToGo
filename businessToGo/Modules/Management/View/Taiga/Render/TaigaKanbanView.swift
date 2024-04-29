import SwiftUI

struct TaigaKanbanView: View {
    let project: TaigaProject
    let statusList: [TaigaTaskStoryStatus]
    let storyList: [TaigaTaskStory]
    let tasks: [TaigaTask]
    
    let onSetStatus: (TaigaTaskStory, TaigaTaskStoryStatus) -> Void
    
    
    @State private var currentlyDragging: TaigaTaskStory?
    @State private var folded: [Bool] = []
    
    
    var body: some View {
        VStack {
            ScrollView(.horizontal){
                HStack(spacing: 2){
                    ForEach(statusList) { status in
                        Column(status)
                            .frame(width: 150)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func TasksView(_ tasks: [TaigaTaskStory]) -> some View {
        VStack(alignment: .leading, spacing: 10, content: {
            ForEach(tasks){ task in
                TaskRow(task)
            }
        })
        .frame(maxWidth: .infinity)
        .padding()
    }
    
    @ViewBuilder
    func TaskView(_ taskStory: TaigaTaskStory) -> some View {
        VStack {
            // todo: show local changes
            /*
            if(change != nil){
                Image(systemName: "icloud.and.arrow.up")
            }else {
                Text("")
            }
            */
            
            Text(taskStory.subject)
            Divider()
            ForEach(tasks.filter { $0.user_story == taskStory.id }){ task in
                Text(task.subject)
            }
        }
        .font(.callout)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .cornerRadius(10)
        .padding()
    }
    
    @ViewBuilder
    func TaskRow(_ task: TaigaTaskStory) -> some View {
        TaskView(task)
        
            .draggable("\(task.id)"){
                TaskView(task)
                    .onAppear(perform: {
                        currentlyDragging = task
                    })
            }
            .dropDestination(for: String.self){ items, location in
                currentlyDragging = nil
                return false
            } isTargeted: { status in
                if let currentlyDragging, status, currentlyDragging.id != task.id {
                    withAnimation(.spring()){
                        
                        //appendTask(task.status)
                        
                        /*switch task.status {
                        case .todo:
                            replaceItem(tasks: &todo, droppingTask: task, status: .todo)
                        case .working:
                            replaceItem(tasks: &working, droppingTask: task, status: .working)
                        case .completed:
                            replaceItem(tasks: &completed, droppingTask: task, status: .completed)
                        }*/
                    }
                }
            }
    }
    
    // appending and removing task from one list to another list
    func appendTask(_ status: TaigaTaskStoryStatus){
        if let currentTask = currentlyDragging {
            onSetStatus(currentTask, status)
        }
    }
    
    // replace item within the list
    func replaceItem(tasks: inout [TaigaTaskStory], droppingTask: TaigaTaskStory, status: TaigaTaskStoryStatus){
        if let currentlyDragging {
            if let sourceIndex = tasks.firstIndex(where: {$0.id == currentlyDragging.id}),
               let destinationIndex = tasks.firstIndex(where: { $0.id == droppingTask.id}){
                //swapping items on the list
                var sourceItem = tasks.remove(at: sourceIndex)
                sourceItem.status = status.id
                tasks.insert(sourceItem, at: destinationIndex)
            }
        }
    }
    
    @ViewBuilder
    func Column(_ status: TaigaTaskStoryStatus) -> some View {
        VStack {
            ScrollView(.vertical){
                TasksView(
                    storyList.filter{
                        $0.status == status.id
                    }
                )
            }
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .principal) { 
                    VStack {
                        Text(status.name).font(.subheadline)
                    }
                }
            }
            
            
    
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
            .dropDestination(for: String.self){ items, location in
                withAnimation(.spring()){
                    appendTask(status)
                }
                return true
            } isTargeted: { status in
                
            }
        }
    }

    
   
}

