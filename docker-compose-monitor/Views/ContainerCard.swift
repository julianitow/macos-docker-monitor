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
    
    @State private var isPulling = false
    @State private var isStarting = false
    @State private var isStopping = false
        
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "shippingbox.fill")
                Text(container.name.uppercased())
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(width: 300)
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            HStack {
                Button(action: {
                    runAction()
                }) {
                    Label("Run", systemImage: isStarting ? "circle.dotted" : "play.fill")
                }
                .disabled(container.status == .RUNNING)
                Button(action: {
                    stopAction()
                }) {
                    Label("Stop", systemImage: isStopping ? "circle.dotted" : "stop.fill")
                }
                .disabled(container.status == .STOPPED)
                Button(action: {
                    pullAction()
                }) {
                    Label("Pull", systemImage: isPulling ? "circle.dotted" : "square.and.arrow.down.fill")
                }
                Button(action: showLogs) {
                    Label("Show logs", systemImage: "play.display")
                }
            }
            .padding()
                    
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
        isStarting = true
        DispatchQueue.global(qos: .utility).async {
            do {
                let _ = try SSHService.dockerRun(of: config, _for: container)
            } catch {
                DispatchQueue.main.async {
                    Utils.alertError(error: error)
                    isStarting = false
                }
            }
        }
    }
    
    private func stopAction() -> Void {
        isStopping = true
        DispatchQueue.global(qos: .utility).async {
            do {
                let _ = try SSHService.dockerStop(of: config, _for: container)
            } catch {
                DispatchQueue.main.async {
                    Utils.alertError(error: error)
                    isStopping = false
                }
            }
            isStopping = false
        }
    }
    
    private func pullAction() -> Void {
        isPulling = true
        let alert = NSAlert()
        DispatchQueue.global(qos: .utility).async {
            do {
                alert.messageText = try SSHService.dockerPull(of: config, _for: container)
            } catch {
                DispatchQueue.main.async {
                    Utils.alertError(error: error)
                    isPulling = false
                }
            }
            DispatchQueue.main.async {
                alert.addButton(withTitle: "Roger.")
                alert.alertStyle = .informational
                alert.runModal()
                isPulling = false
            }
        }
    }
    
    private func showLogs() -> Void {
        self.displayLogs.toggle()
        ContainerOutput(config: config, container: container).openInWindow(title: container.name, sender: self)
    }
}

struct ContainerCard_Previews: PreviewProvider {
    static var previews: some View {
        let config = MockedData.fetchConfigs()[0]
        var container = MockedData.fetchContainersProd()[0]
        let bindingContainer = Binding { container } set: { container = $0 }
        ContainerCard(config: config, container: bindingContainer)
    }
}
