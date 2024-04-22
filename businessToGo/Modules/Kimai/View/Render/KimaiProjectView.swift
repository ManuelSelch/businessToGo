//
//  KimaiProjectView.swift
//  businessToGo
//
//  Created by Admin  on 14.04.24.
//

import SwiftUI

struct KimaiProjectView: View {    
    let kimaiProject: KimaiProject
    let taigaProject: TaigaProject?
    
    var body: some View {
        VStack {
            Text(kimaiProject.name)
        }
    }
}
