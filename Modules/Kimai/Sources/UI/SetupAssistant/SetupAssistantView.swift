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
        List {
            Image("no-customers")
                .resizable()
                .scaledToFit()
                .padding()
                .cornerRadius(10)
                .padding()

            
            Text("Setup Checklist")
                .font(.title)
                .bold()
            
            /*
            ForEach(KimaiFeature.Step.allCases) { step in
                HStack {
                    Image(systemName: step.index < (currentStep?.index) ?? 0 ? "checkmark.circle.fill" : "circle")
                        .imageScale(.large)
                    Spacer()
                    Text(steps[step].rawValue)
                }
                .foregroundStyle(step == currentStep ? Color.theme : step.index <= (currentStep?.index) ?? 0 ? Color.contrast : Color.gray)
                .onTapGesture {
                    if(step == currentStep) {
                        stepTapped()
                    }
                }
            }
             */
            
            Button(action: {
                dashboardTapped()
            }) {
                Text("Dashboard")
            }
            .padding(10)
            .background(Color.theme)
            .cornerRadius(10)
            .foregroundStyle(Color.background)
            
        }
    }
}

