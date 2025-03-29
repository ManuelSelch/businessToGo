import SwiftUI

import KimaiCore

public struct SetupAssistantView: View {
    
    var currentStep: KimaiAssistantStep?
    let steps: [KimaiAssistantStep]
    
    let stepTapped: () -> ()
    let dashboardTapped: () -> ()
    
    public init(currentStep: KimaiAssistantStep? = nil, steps: [KimaiAssistantStep], stepTapped: @escaping () -> Void, dashboardTapped: @escaping () -> Void) {
        self.currentStep = currentStep
        self.steps = steps
        self.stepTapped = stepTapped
        self.dashboardTapped = dashboardTapped
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Image("no-customers")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 800)
                    .padding()
                    .cornerRadius(10)
                    .padding()
                Spacer()
            }
            
            
            Text("Setup Checklist")
                .font(.title)
                .bold()
            
            
            ForEach(steps) { step in
                
                var stepColor: Color {
                    guard let currentStep = currentStep
                    else { return Color.theme } // all steps already finished
                    
                    if(step == currentStep) { return Color.theme } // currently active
                    else if(step.id <= currentStep.id) { return Color.contrast } // already done
                    else { return Color.gray } // not yet done
                }
                
                var stepImage: String {
                    guard let currentStep = currentStep
                    else { return "checkmark.circle.fill" } // all steps already finished
                    
                    if(step.id < currentStep.id) {
                        return "checkmark.circle.fill" // already done
                    } else {
                        return "circle" // not yet done
                    }
                }
                
                HStack {
                    Image(systemName: stepImage)
                        .imageScale(.large)
                    Spacer()
                    Text(step.rawValue)
                }
                .foregroundStyle(stepColor)
                .onTapGesture {
                    if(step == currentStep) {
                        stepTapped()
                    }
                }
            }
            
           
            Button(action: dashboardTapped) {
                Text("Dashboard")
            }
            .padding(10)
            .background(currentStep == nil ? Color.theme : Color.themeGray)
            .cornerRadius(10)
            .foregroundStyle(Color.background)
            .disabled(currentStep != nil)
            
            
        }
        .frame(maxWidth: 2000)
        .padding()
    }
}

