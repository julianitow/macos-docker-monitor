//
//  ContainerCard.swift
//  docker-compose-monitor
//
//  Created by Julien Guillan on 24/06/2023.
//

import SwiftUI

struct ContainerCard: View {
    
    @State var config: Config
    @Binding var container: Container
    @State var displayLogs: Bool = false
        
    var body: some View {
        VStack {
            Text(container.name.uppercased())
                .font(.title)
                .fontWeight(.bold)
                .frame(width: 300)
                .foregroundColor(.white)
            
            Spacer()
            
            HStack {
                Button(action: runAction) {
                    Label("Run", systemImage: "play.fill")
                }
                .disabled(container.status == .RUNNING)
                Button(action: stopAction) {
                    Label("Stop", systemImage: "stop.fill")
                }
                .disabled(container.status == .STOPPED)
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
        }
        .background(container.status == .RUNNING ? Color(hex: "#2ecc71") : container.status == .EXITED ? Color(hex: "#c0392b") : container.status == .STOPPED ? Color(hex: "#95a5a6") : .white)
        .cornerRadius(10)
        .frame(width: SIZES.CONTAINER_CARD_WIDTH.rawValue)
        .fixedSize(horizontal: false, vertical: true)
        .padding()
    }
    
    private func runAction() -> Void {
        DispatchQueue.main.async {
            do {
                let _ = try SSHService.dockerRun(of: config, _for: container)
            } catch {
                Utils.alertError(error: error)
            }
        }
    }
    
    private func stopAction() -> Void {
        do {
            let _ = try SSHService.dockerStop(of: config, _for: container)
        } catch {
            Utils.alertError(error: error)
        }
    }
    
    private func pullAction() -> Void {
        let alert = NSAlert()
        do {
            alert.messageText = try SSHService.dockerPull(of: config, _for: container)
        } catch {
            Utils.alertError(error: error)
        }
        alert.addButton(withTitle: "Roger.")
        alert.alertStyle = .informational
        alert.runModal()
        
    }
    
    private func showLogs() -> Void {
        self.displayLogs.toggle()
        ContainerOutput(config: config, container: container).openInWindow(title: container.name, sender: self)
    }
}

// struct ContainerCard_Previews: PreviewProvider {
//     static var previews: some View {
//         let config = MockedData.fetchConfigs()[0]
//         let container = MockedData.fetchContainersProd()[0]
//         ContainerCard(config: config, container: container)
//     }
// }
