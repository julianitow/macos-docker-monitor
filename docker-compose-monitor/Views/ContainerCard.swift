//
//  ContainerCard.swift
//  docker-compose-monitor
//
//  Created by Julien Guillan on 24/06/2023.
//

import SwiftUI

struct ContainerCard: View {
    
    @State var container: Container
    @State var displayLogs: Bool = false
    
    var body: some View {
        VStack {
            Text(container.name.uppercased())
                .font(.title)
                .fontWeight(.bold)
                .frame(width: 200)
                .foregroundColor(.white)
            
            Spacer()
            
            HStack {
                Button(action: runAction) {
                    Label("Run", systemImage: "play.fill")
                }
                Button(action: stopAction) {
                    Label("Stop", systemImage: "stop.fill")
                }
                Button(action: pullAction) {
                    Label("Pull", systemImage: "square.and.arrow.down.fill")
                }
                Button(action: showLogs) {
                    Label("Show logs", systemImage: "play.display")
                }
            }
                    
            Text(container.status.rawValue)
                .font(.subheadline)
                .foregroundColor(.black)
                .padding(.bottom)
            
            if displayLogs {
                VStack {
                    Text("Logs")
                }
                .frame(width: 600, height: 600)
            }
        }
        .background(container.status == .RUNNING ? Color(hex: "#2ecc71") : container.status == .EXITED ? Color(hex: "#c0392b") : container.status == .STOPPED ? Color(hex: "#95a5a6") : .white)
        .cornerRadius(10)
        .frame(width: 500)
        .fixedSize(horizontal: false, vertical: true)
        .padding()
    }
    
    private func runAction() -> Void {
        
    }
    
    private func stopAction() -> Void {
        
    }
    
    private func pullAction() -> Void {
        
    }
    
    private func showLogs() -> Void {
        self.displayLogs.toggle()
    }
}

struct ContainerCard_Previews: PreviewProvider {
    static var previews: some View {
        let container = MockedData.fetchContainersProd()[0]
        ContainerCard(container: container)
    }
}
