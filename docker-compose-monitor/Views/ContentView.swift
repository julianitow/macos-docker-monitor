//
//  ContentView.swift
//  docker-compose-monitor
//
//  Created by Julien Guillan on 24/06/2023.
//

import SwiftUI

struct ContentView: View {
    @State var configs = MockedData.fetchConfigs()
    @State var selectedConfig: Config?
    @State var containers: Array<Container> = []
    
    @State private var firstColumnWidth: CGFloat = 0.2
    @State private var dragOffset: CGFloat = 0.0
    
    @State private var isCardOpened = false
    @State private var openedCardIndex = 0
    
    @State var containerGeometryProxy: GeometryProxy? = nil
    
    private let sshService = MockSSHService.self
    private let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()

    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .top, spacing: 0) {
                VStack { // config list
                    Button(action: addConfig) {
                            Label("Add config", systemImage: "folder.badge.plus")
                    }
                    .padding()
                    Divider()
                    ScrollView(.vertical) {
                        GeometryReader { scrollGeometry in
                            VStack (spacing: 5) {
                                if configs.count > 0 {
                                    ForEach(Array(configs.enumerated()), id: \.element.id) { (index, config) in
                                        ConfigCard(config: $configs[index], geometryProxy: scrollGeometry)
                                            .gesture(TapGesture(count: 2).onEnded { gesture in
                                                toggleConnection(for: config)
                                            })
                                            .gesture(TapGesture(count: 1).onEnded {
                                                toggleSelection(for: config)
                                            })
                                    }
                                } else {
                                    Text("No configuration found. \n Please edit config file (located in \n $HOME/.docker-inspector/config.json) and add configurations, ex:\n { \n \"name\": ..., \n \"host\": ...\n \"username\": ...,\n \"port\": 22,\n \"publicKey\": \"path_to_file\",\n \"privateKey\": \"path_to_file\",\n }")
                                        .frame(width: scrollGeometry.size.width, height: 500)
                                }
                            }
                            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                        }
                    }
                }
                .frame(width: geometry.size.width * firstColumnWidth)
                Divider()
                    .onHover { inside in
                        if (inside) {
                            NSCursor.resizeLeftRight.push()
                        } else {
                            NSCursor.pop()
                        }
                    }
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let dragAmount = value.translation.width
                                let totalWidth = geometry.size.width
                                let newFirstColumnWidth = firstColumnWidth + dragAmount / totalWidth
                                let minColumnWidth: CGFloat = 0.1
                                let maxColumnWidth: CGFloat = 0.8
                                firstColumnWidth = max(min(newFirstColumnWidth, maxColumnWidth), minColumnWidth)
                            }
                    )
                GeometryReader { rightGeometry in
                    let spacing: CGFloat = 1
                    ScrollView([.horizontal, .vertical]) {
                        if selectedConfig != nil {
                            if selectedConfig!.isConnected {
                                let rows = 5
                                @State var columns = ((selectedConfig?.containers.count)! + rows - 1) / rows
                                VStack {
                                    ForEach(0..<rows) { row in
                                        HStack(spacing: spacing) {
                                            ForEach(0..<columns) { column in
                                                let index = row * columns + column
                                                if index < selectedConfig!.containers.count {
                                                    if let config = selectedConfig {
                                                        let containers = Binding { config.containers } set: { selectedConfig?.containers = $0 }
                                                        ContainerCard(config: selectedConfig!, container: containers[index])
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    
                                }
                                .onReceive(timer) { _ in
                                    if selectedConfig != nil {
                                        if selectedConfig!.isConnected {
                                            DispatchQueue.global(qos: .utility).async {
                                                selectedConfig!.containers = fetchContainersState(for: selectedConfig!)
                                            }
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity)
                            } else {
                                Text("Not connected")
                            }
                        } else {
                            Text("Not connected")
                        }
                    }
                    .background(Color(hex: COLORS_HEX.BLACK_BACKGROUND.rawValue))
                    .onAppear {
                        containerGeometryProxy = rightGeometry
                    }
                }
            }
        }
    }
    
    private func getContainerCardIndex(row: Int, column: Int, rows: Int) -> Int? {
        if selectedConfig == nil {
            return nil
        }
        let index = column * rows + row
        return index
    }
    
    private func addConfig() -> Void {
        // TODO: display a window to add a ne config
        let alert = NSAlert()
        alert.messageText = "Not implemented yet"
        alert.informativeText = "Edition from GUI not done yet, WIP, please edit configuration file directory"
        alert.runModal()
    }
    
    private func toggleSelection(for config: Config) -> Void {
        self.selectedConfig?.containers = []
        for i in 0..<configs.count {
            if config.id == configs[i].id {
                configs[i].isSelected.toggle()
                self.selectedConfig = configs[i]
                self.containers = configs[i].containers
            } else {
                configs[i].isSelected = false
            }
        }
    }
    
    private func fetchContainersState(for config: Config) -> Array<Container> {
        if configs.firstIndex(where: { $0.id == config.id }) != nil {
            if connect(to: config) {
                do {
                    return try sshService.fetchContainers(of: config)!
                } catch {
                    Utils.alertError(error: error)
                }
            }
        }
        return []
    }
    
    private func toggleConnection(for config: Config) -> Void {
        if let index = configs.firstIndex(where: { $0.id == config.id }) {
            if connect(to: config) {
                do {
                    let containers = try sshService.fetchContainers(of: config)
                    configs[index].containers = containers!
                    self.containers = configs[index].containers
                    configs[index].isConnected.toggle()
                    self.toggleSelection(for: configs[index])
                } catch {
                    Utils.alertError(error: error)
                }
            }
        }
    }
    
    private func connect(to config: Config) -> Bool {
        do {
            return try sshService.connect(to: config)
        } catch {
            Utils.alertError(error: error)
        }
        return false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
