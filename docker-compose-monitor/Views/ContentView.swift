//
//  ContentView.swift
//  docker-compose-monitor
//
//  Created by Julien Guillan on 24/06/2023.
//

import SwiftUI

struct ContentView: View {
    @State var configs = ConfigParserService.fetchConfigs()
    @State var selectedConfig: Config?
    @State var containers: Array<Container> = []
    
    @State private var firstColumnWidth: CGFloat = 0.2
    @State private var dragOffset: CGFloat = 0.0
    
    @State private var isCardOpened = false
    @State private var openedCardIndex = 0
    
    @State var containerGeometryProxy: GeometryProxy? = nil
    @State var searchFilter: String = ""
    
    @State private var isConfigFormPresented: Bool = false
    @State private var isLoading = false
    
    private let sshService = SSHService.self
    private let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()

    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .top, spacing: 0) {
                VStack { // config list
                    Button(action: addConfig) {
                            Label("Add config", systemImage: "folder.badge.plus")
                    }
                    .padding()
                    .sheet(isPresented: $isConfigFormPresented) {
                        ConfigForm(isPresented: $isConfigFormPresented)
                            .frame(width: 400)
                            .onDisappear {
                                configs = ConfigParserService.fetchConfigs()
                            }
                    }
                    Divider()
                    GeometryReader { scrollGeometry in
                        ScrollView(.vertical) {
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
                            if selectedConfig!.connectionStatus == .CONNECTED {
                                // TODO: Fix when selecting another config with differents columns count displays bad count of containers
                                let rows = INTEGERS.CONTAINER_ROW_COUNT.rawValue
                                VStack {
                                    ForEach(0..<rows, id: \.self) { row in
                                        HStack(spacing: spacing) {
                                            ForEach(0..<columns, id: \.self) { column in
                                                let index = row * columns + column
                                                if let config = selectedConfig {
                                                    let _containers = Binding { config.containers } set: { selectedConfig?.containers = $0 }
                                                    if index < selectedConfig!.containers.count {
                                                        ContainerCard(config: selectedConfig!, container: _containers[index])
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    
                                }
                                .onReceive(timer) { _ in
                                    if selectedConfig != nil {
                                        if selectedConfig!.connectionStatus == .CONNECTED {
                                            DispatchQueue.global(qos: .utility).async {
                                                let _containers = fetchContainersState(for: selectedConfig!)
                                                if searchFilter.count == 0 {
                                                    selectedConfig?.containers = _containers
                                                    containers = selectedConfig?.containers ?? []
                                                } else {
                                                    let containerSelected = _containers.first(where: {$0.name == selectedConfig?.containers[0].name})!
                                                    selectedConfig!.containers = Array<Container>(arrayLiteral: containerSelected)
                                                }
                                            }
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity)
                            } else {
                                Text("Not connected")
                            }
                        } else {
                            Text("No configuration selected")
                        }
                    }
                    .background(Color(hex: COLORS_HEX.BLACK_BACKGROUND.rawValue))
                    .onAppear {
                        containerGeometryProxy = rightGeometry
                    }
                    .searchable(text: $searchFilter) {
                        ForEach(containers) { container in
                            if container.name.contains(searchFilter) {
                                Text(container.name)
                                    .onTapGesture {
                                        selectedConfig?.containers = [container]
                                    }
                            }
                        }
                    }
                    .onChange(of: searchFilter) { _ in
                        if searchFilter.count == 0 {
                            selectedConfig?.containers = containers
                        }
                    }
                }
            }
        }
    }
    
    private var columns: Int {
        return ((selectedConfig?.containers.count)! + INTEGERS.CONTAINER_ROW_COUNT.rawValue - 1) / INTEGERS.CONTAINER_ROW_COUNT.rawValue
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
        isConfigFormPresented = true
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
    
    private func toggleSelection(for config: Config) -> Void {
        isLoading = true
        if selectedConfig?.id == config.id {
            selectedConfig = nil
            return
        }
        selectedConfig = config
        selectedConfig?.containers = []
        print(config.name, selectedConfig!.name)
    }
    
    private func toggleConnection(for config: Config) -> Void {
        DispatchQueue.global(qos: .utility).async {
            if let index = configs.firstIndex(where: { $0.id == config.id }) {
                if config.connectionStatus == .CONNECTED {
                    configs[index].connectionStatus = .DISCONNECTED
                    if selectedConfig?.id == configs[index].id {
                        selectedConfig = nil
                    }
                    return
                }
                configs[index].connectionStatus = .CONNECTING
                if connect(to: config) {
                    do {
                        selectedConfig = nil
                        containers = try sshService.fetchContainers(of: config) ?? []
                        configs[index].containers = containers
                        configs[index].connectionStatus = .CONNECTED
                        selectedConfig = configs[index]
                    } catch {
                        DispatchQueue.main.async {
                            Utils.alertError(error: error)
                        }
                    }
                } else {
                    configs[index].connectionStatus = .ERROR
                }
            }
        }
    }
    
    private func connect(to config: Config) -> Bool {
        do {
            return try sshService.connect(to: config)
        } catch {
            DispatchQueue.main.async {
                Utils.alertError(error: error)
            }
        }
        return false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
