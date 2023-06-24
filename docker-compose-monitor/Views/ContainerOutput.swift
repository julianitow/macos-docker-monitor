//
//  ContainerOutput.swift
//  docker-compose-monitor
//
//  Created by Julien Guillan on 24/06/2023.
//

import SwiftUI

struct ContainerOutput: View {
    
    @State var config: Config
    @State var container: Container
    
    @State var text: String = ""
    @State private var scrollViewProxy: ScrollViewProxy?
    
    private let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            Button(action: refreshAction) {
                Label("Refresh", systemImage: "arrow.clockwise.circle.fill")
            }.padding()
            HStack {
                ScrollViewReader { proxy in
                    ScrollView{
                        Text(text)
                            .id("stdout")
                            .textSelection(.enabled)
                            .padding()
                            .onChange(of: text) { _ in
                                scrollToBottom(proxy: proxy)
                            }
                            .onAppear {
                                scrollViewProxy = proxy
                            }
                    }
                }
            }
        }
        .frame(minWidth: 600, maxWidth: .infinity, minHeight: 800, maxHeight: .infinity)
        .task {
            updateText()
        }
        .onReceive(timer) { _ in
            updateText()
        }
    }
    
    private func updateText() -> Void {
        DispatchQueue.global(qos: .utility).async {
            text = SSHService.fetchLogs(of: config, _for: container)!
        }
    }
    
    private func refreshAction() -> Void {
        text = SSHService.fetchLogs(of: config, _for: container)!
    }
    
    private func scrollToBottom(proxy: ScrollViewProxy) -> Void {
        withAnimation {
            proxy.scrollTo("stdout", anchor: .bottom)
        }
    }
}

struct ContainerOutput_Previews: PreviewProvider {
    static var previews: some View {
        let config = MockedData.fetchConfigs()[0]
        let container = MockedData.fetchContainersBeta()[0]
        ContainerOutput(config: config, container: container)
    }
}
