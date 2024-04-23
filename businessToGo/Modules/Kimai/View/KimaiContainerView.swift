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
            var isTimesheet: Bool {
                switch(kimaiStore.state.scene){
                    case .timesheet(_): return true
                    default: return false
                }
            }
            
            
            KimaiHeaderView(
                isPresentingPlayView: $isPresentingPlayView,
                isBack: kimaiStore.state.scene != .customers,
                isChart: kimaiStore.state.scene == .customers,
                isSync: !isTimesheet,
                isPlay: !isTimesheet,
                onSync: sync,
                onBack: goBack,
                onChart: showChart
            )
            
            switch(kimaiStore.state.scene){
            case .customers:
                getCustomersView()
            
            case .chart:
                getChartView()
                
            case .customer(let id):
                getCustomerView(id)
                
            case .project(let id):
                getProjectView(id)
                    .onAppear {
                        kimaiCustomerMenuSelection = KimaiCustomerMenu.time
                    }
                
            case .timesheet(let id):
                getTimesheetView(id)
            }
            
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
    
    @ViewBuilder func getChartView() -> some View {
        KimaiChartView(
            projects: Env.kimai.projects.get(),
            timesheets: Env.kimai.timesheets.get()
        )
    }
    
    @ViewBuilder func getCustomerView(_ id: Int) -> some View {
        // todo: reset kimaiCustomerMenuSelection = .time
        if let customer = Env.kimai.customers.get(by: id) {
            KimaiCustomerView(
                customer: customer,
                projects: Env.kimai.projects.get(),
                onProjectClicked: showProject
            )
        }else {
            Text("Error: Customer not found")
        }
    }
    
    
    @ViewBuilder func getProjectView(_ id: Int) -> some View {
        var menus: [KimaiCustomerMenu] {
            var menus: [KimaiCustomerMenu] = [.time]
            
            if let integration = Env.integrations.get(by: id),
               let taigaProject = Env.taiga.projects.get(by: integration.taigaProjectId) 
            {
                menus.append(.kanban)
                if(taigaProject.is_backlog_activated){
                    menus.append(.backlog)
                }
            }
            
            return menus
        }
        
        if let kimaiProject = Env.kimai.projects.get(by: id)
        {
            let integration = Env.integrations.get(by: id)
            
            var taigaProject: TaigaProject? {
                if let integration = integration {
                    return Env.taiga.projects.get(by: integration.taigaProjectId)
                }
                return nil
            }
            
            
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
            let timesheets = Env.kimai.timesheets.get().filter { $0.project == kimaiProject.id }
            
            KimaiTimesheetsView(
                timesheets: timesheets,
                activities: Env.kimai.activities.get(),
                changes: Env.track.getAll(timesheets, "timesheets"),
                
                onTimesheetClicked: showTimesheet,
                onStopClicked: stopTimesheet
            )
        }
    }
    
    @ViewBuilder func getProjectBacklogView(_ taigaProject: TaigaProject?) -> some View {
        if let taigaProject = taigaProject {
            if(taigaProject.is_backlog_activated){
                TaigaBacklogView(
                    project: taigaProject,
                    milestones: Env.taiga.milestones.get().filter { $0.project == taigaProject.id }
                )
            }
        }
    }
    
    @ViewBuilder func getProjectKanbanView(_ taigaProject: TaigaProject?) -> some View {
        if let taigaProject = taigaProject {
            TaigaKanbanView(
                project: taigaProject,
                statusList: Env.taiga.taskStoryStatus.get().filter { $0.project == taigaProject.id },
                storyList: Env.taiga.taskStories.get(),
                tasks: Env.taiga.tasks.get(),
                
                onSetStatus: setStatus
            )
        }
    }
    
    
    @ViewBuilder func getTimesheetView(_ id: Int? = nil) -> some View {
        let timesheet = Env.kimai.timesheets.get().first { $0.id == id }
        
        KimaiPlayView(
            timesheet: timesheet,
            
            isPresentingPlayView: $isPresentingPlayView,
            
            customers: Env.kimai.customers.get(),
            projects: Env.kimai.projects.get(),
            activities: Env.kimai.activities.get(),
            
            onSave: saveTimesheet
        )
        
        
    }
}

extension KimaiContainerView {
    func sync(){
        kimaiStore.send(.sync)
        taigaStore.send(.sync)
    }
    
    func goBack(){
        switch(kimaiStore.state.scene){
        case .customers:
            break
        case .chart:
            kimaiStore.send(.navigate(.customers))
        case .customer(_):
            kimaiStore.send(.navigate(.customers))
        case .project(let id):
            if let project = Env.kimai.projects.get(by: id) {
                kimaiStore.send(.navigate(.customer(project.customer)))
            }
        case .timesheet(let id):
            if let timesheet = Env.kimai.timesheets.get(by: id) {
                kimaiStore.send(.navigate(.project(timesheet.project)))
            }
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
    
    func stopTimesheet(_ id: Int){
        if var timesheet = Env.kimai.timesheets.get(by: id) {
            timesheet.end = "\(Date.now)"
            kimaiStore.send(.timesheets(.update(timesheet)))
        }
    }
    
    func setStatus(_ task: TaigaTaskStory, _ status: TaigaTaskStoryStatus){
        var task = task
        task.status = status.id
        taigaStore.send(.taskStories(.update(task)))
    }
    
    func saveTimesheet(_ timesheeet: KimaiTimesheet){
        if(timesheeet.id == -1){ // create
            kimaiStore.send(.timesheets(.create(timesheeet)))
        }else { // update
            kimaiStore.send(.timesheets(.update(timesheeet)))
            goBack()
        }
        
    }
    
    func showChart() {
        kimaiStore.send(.navigate(.chart))
    }
    
    
    
    
}
