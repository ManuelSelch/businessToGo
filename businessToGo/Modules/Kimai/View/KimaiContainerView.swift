import SwiftUI

enum KimaiCustomerMenu: String, Equatable, CaseIterable {
    case time  = "Time"
    case backlog = "Backlog"
    case kanban = "Kanban"

    var localizedName: LocalizedStringKey { LocalizedStringKey(rawValue) }
}


struct KimaiContainerView: View {
    @EnvironmentObject var menuStore: Store<AppScreen, MenuAction>
    @EnvironmentObject var kimaiStore: Store<KimaiState, KimaiAction>
    @EnvironmentObject var taigaStore: Store<TaigaState, TaigaAction>
    
    @State var isPresentingPlayView = false
    @State var selectedCustomer = 0
    @State var selectedProject = 0
    
    @State var kimaiCustomerMenuSelection = KimaiCustomerMenu.time
    
    var body: some View {
        VStack {
            KimaiHeaderView(
                isPresentingPlayView: $isPresentingPlayView,
                isBack: kimaiStore.state.scene != .customers,
                onSync: sync,
                onBack: goBack
            )
            
            switch(kimaiStore.state.scene){
            case .customers:
                getCustomersView()
                
            case .customer(let id):
                getCustomerView(id)
                
            case .project(let id):
                getProjectView(id)
                
            case .timesheet(let id):
                getTimesheetView(id)
            }
        }
        .onAppear {
            kimaiStore.send(.sync)
        }
        .sheet(isPresented: $isPresentingPlayView) {
            getTimesheetView()
        }
    }
    
}

extension KimaiContainerView {
    @ViewBuilder func getCustomersView() -> some View {
        KimaiCustomersView(
            customers: Env.kimai.customers.get(),
            onCustomerSelected: showCustomer
        )
    }
    
    @ViewBuilder func getCustomerView(_ id: Int) -> some View {
        // todo: reset kimaiCustomerMenuSelection = .time
        if let customer = Env.kimai.customers.get().first(where: {$0.id == id}) {
            KimaiCustomerView(
                customer: customer,
                projects: Env.kimai.projects.get(),
                onProjectClicked: showProject
            )
        }
    }
    
    
    @ViewBuilder func getProjectView(_ id: Int) -> some View {
        var menus: [KimaiCustomerMenu] {
            var menus: [KimaiCustomerMenu] = [.time]
            
            let integration = Env.integrations.get().first { $0.id == id }
            let taigaProject = Env.taiga.projects.get().first { $0.id ==  integration?.taigaProjectId}
            
            if let taigaProject = taigaProject {
                menus.append(.kanban)
                if(taigaProject.is_backlog_activated){
                    menus.append(.backlog)
                }
            }
            
            return menus
        }
        
        if let kimaiProject = Env.kimai.projects.get().first(where: { $0.id == id }) {
            let integration = Env.integrations.get().first { $0.id == id }
            let taigaProject = Env.taiga.projects.get().first { $0.id ==  integration?.taigaProjectId}
            
            
            
            Picker("", selection: $kimaiCustomerMenuSelection) {
                ForEach(menus, id: \.self) { value in
                    Text(value.localizedName)
                        .tag(value)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            switch(kimaiCustomerMenuSelection){
            case .time:
                getProjectTimeView(kimaiProject, taigaProject)
            case .backlog:
                getProjectBacklogView(taigaProject)
            case .kanban:
                getProjectKanbanView(taigaProject)
                
            }
            
        }else {
            Text("error loading project")
        }
    }
    
    @ViewBuilder func getProjectTimeView(_ kimaiProject: KimaiProject, _ taigaProject: TaigaProject?) -> some View {
        VStack {
            KimaiProjectView(
                kimaiProject: kimaiProject,
                taigaProject: taigaProject
            )
            let timesheets = Env.kimai.timesheets.get().filter { $0.project == kimaiProject.id }
            
            KimaiTimesheetsView(
                timesheets: timesheets,
                activities: Env.kimai.activities.get(),
                changes: Env.track.getAll(timesheets, "timesheets"),
                
                onTimesheetClicked: showTimesheet
            )
        }
    }
    
    @ViewBuilder func getProjectBacklogView(_ taigaProject: TaigaProject?) -> some View {
        if let taigaProject = taigaProject {
            if(taigaProject.is_backlog_activated){
                TaigaBacklogView(
                    project: taigaProject,
                    milestones: Env.taiga.milestones.get()
                )
                .onAppear{
                    taigaStore.send(.milestones(.fetch))
                }
            }
        }
    }
    
    @ViewBuilder func getProjectKanbanView(_ taigaProject: TaigaProject?) -> some View {
        if let taigaProject = taigaProject {
            TaigaKanbanView(
                project: taigaProject,
                statusList: Env.taiga.taskStoryStatus.get(),
                storyList: Env.taiga.taskStories.get(),
                tasks: Env.taiga.tasks.get(),
                
                onSetStatus: setStatus
            )
            .onAppear {
                taigaStore.send(.sync)
            }
        }
    }
        
    
    @ViewBuilder func getTimesheetView(_ id: Int? = nil) -> some View {
        if let id = id, let timesheet = Env.kimai.timesheets.get().first(where: { $0.id == id }) {
            // edit existing timesheet record
            KimaiPlayView(
                timesheet: timesheet,
                
                isPresentingPlayView: $isPresentingPlayView,
                
                customers: Env.kimai.customers.get(),
                projects: Env.kimai.projects.get(),
                activities: Env.kimai.activities.get(),
                
                onSave: createTimesheet
            )
        }else {
            // create new timesheet record
            KimaiPlayView(
                timesheet: KimaiTimesheet.new,
                
                isPresentingPlayView: $isPresentingPlayView,
                
                customers: Env.kimai.customers.get(),
                projects: Env.kimai.projects.get(),
                activities: Env.kimai.activities.get(),
                
                onSave: createTimesheet
            )
        }
        
        
    }
}

extension KimaiContainerView {
    func sync(){
        kimaiStore.send(.sync)
    }
    
    func goBack(){
        switch(kimaiStore.state.scene){
        case .customers:
            break
            
        case .customer(_):
            kimaiStore.send(.navigate(.customers))
        case .project(let id):
            if let project = Env.kimai.projects.get().first(where: {$0.id == id}) {
                kimaiStore.send(.navigate(.customer(project.customer)))
            }
        case .timesheet(let id):
            kimaiStore.send(.navigate(.customers))
        }
    }
    
    func showCustomers(){
        kimaiStore.send(.navigate(.customers))
    }
    
    func showCustomer(_ customer: Int){
        kimaiStore.send(.navigate(.customer(customer)))
    }
    
    func showProject(_ project: Int){
        kimaiStore.send(.navigate(.project(project)))
    }
    
    func showTimesheet(_ id: Int){
        kimaiStore.send(.navigate(.timesheet(id)))
    }
    
    func setStatus(_ task: TaigaTaskStory, _ status: TaigaTaskStoryStatus){
        taigaStore.send(.setStatus(task, status))
    }
    
    func createTimesheet(_ project: Int, _ activity: Int, _ begin: String, _ description: String){
        kimaiStore.send(.createTimesheet(project, activity, begin, description))
    }
    
    
    
    
}
