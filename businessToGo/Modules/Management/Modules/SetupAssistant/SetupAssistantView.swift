import SwiftUI
import ComposableArchitecture

struct SetupAssistantView: View {
    let store: StoreOf<SetupAssistantFeature>
    
    var body: some View {
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
            
            ForEach(0 ..< store.steps.count, id: \.self) { step in
                HStack {
                    Image(systemName: step < store.currentStep ? "checkmark.circle.fill" : "circle")
                        .imageScale(.large)
                    Spacer()
                    Text(store.steps[step])
                }
                .foregroundStyle(step == store.currentStep ? Color.theme : step <= store.currentStep ? Color.contrast : Color.gray)
                .onTapGesture {
                    if(step == store.currentStep) {
                        store.send(.stepTapped)
                    }
                }
            }
            
            Button(action: {
                store.send(.delegate(.showHome))
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

