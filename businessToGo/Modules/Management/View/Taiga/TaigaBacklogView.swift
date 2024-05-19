import SwiftUI
import Charts


struct TaigaBacklogView: View {
    var project: TaigaProject
    let milestones: [TaigaMilestone]
    
    var milestonesFiltered: [TaigaMilestone] {
        var m = milestones
        m.sort { $0.id > $1.id }
        return m
    }
    
    var body: some View {
        VStack {
            Chart {
                // MARK: optimal points
                ForEach(0 ... Int(project.total_milestones ?? 100), id: \.self) { i in
                    LineMark(
                        x: .value("Time", i),
                        y: .value("Points",
                                  calcOptimalY(i)
                                 ),
                        series: .value("", "optimal")
                    )
                    .foregroundStyle(.gray)
                    
                    PointMark(
                        x: .value("Time", i),
                        y: .value("Points", calcOptimalY(i))
                    )
                    .foregroundStyle(Color.gray)
                }
                
                // MARK: first point = max points
                LineMark(
                    x: .value("Time", 0),
                    y: .value("Points", calcOptimalY(0)),
                    series: .value("", "actual")
                )
                .foregroundStyle(Color.green)
                
                PointMark(
                    x: .value("Time", 0),
                    y: .value("Points", calcOptimalY(0))
                )
                .foregroundStyle(Color.green)
                
                AreaMark(
                    x: .value("Time", 0),
                    y: .value("Points", calcOptimalY(0)),
                    series: .value("", "actual")
                )
                .foregroundStyle(Color.green.opacity(0.5))
                
                
                // MARK: show sprints
                ForEach(milestonesFiltered.reversed()){ milestone in
                    LineMark(
                        x: .value("Time", calcXValue(milestone)+1),
                        y: .value("Points", calcYValue(milestone)),
                        series: .value("", "actual")
                    )
                    .foregroundStyle(Color.green)
                    
                    PointMark(
                        x: .value("Time", calcXValue(milestone)+1),
                        y: .value("Points", calcYValue(milestone))
                    )
                    .foregroundStyle(Color.green)
                    
                    AreaMark(
                        x: .value("Time", calcXValue(milestone)+1),
                        y: .value("Points", calcYValue(milestone)),
                        series: .value("", "actual")
                    )
                    .foregroundStyle(Color.green.opacity(0.5))
                    
                }
                
               
                
                
                
                
                
            }
            .padding()
            .chartYScale(domain: 0...(project.total_story_points ?? 100))
            .chartXScale(domain: 0...(project.total_milestones ?? 100))
            
            MilestonesList(milestones: milestonesFiltered)
        }
        .background(Color.background)
    }
    
    func calcOptimalY(_ index: Int) -> Double{
        return (project.total_story_points ?? Double(100)) - (
            (project.total_story_points ?? Double(100)) / Double(project.total_milestones ?? 100) * Double(index)
        )
    }
    
    func calcXValue(_ current: TaigaMilestone) -> Int{
        var index: Int = 0
        for milestone in milestonesFiltered.reversed(){
            if(current.id == milestone.id){
                break
            }
            index += 1
        }
        
        return index
    }
    
    func calcYValue(_ current: TaigaMilestone) -> Double{
        var closedPoints: Double = 0
        for milestone in milestonesFiltered.reversed(){
            closedPoints += (milestone.closed_points ?? 0)
            if(current.id == milestone.id){
                break
            }
        }
        
        return (project.total_story_points ?? 100) - closedPoints
    }
}

struct MilestonesList: View {
    let milestones: [TaigaMilestone]
    
    var body: some View {
        List(milestones) { milestone in
             HStack {
                 Text("\(milestone.name)")
             }
         }
    }
}
