//
//  HomeView.swift
//  iBreath-X
//
//  Created by app on 2024/8/22.
//

import SwiftUI
import CoreBluetooth

struct HomeView: View {
    @Binding var selectedTab: TabType
    @State private var isPressed: HomeTitleTab = .all
    @StateObject var bluetoothManager = BluetoothManager()
    @State private var showTestJsonView = false

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    nameView
                    Spacer()
                    Button(action: {
                        showTestJsonView = true
                    }) {
                        Image(systemName: "network")
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 100)
                
                titleBar
                Spacer().frame(height: 40)
                Button(action: {
                    bluetoothManager.toggleBluetooth()
                }){
                    Text(bluetoothManager.isBluetoothEnabled ? "Turn Off Bluetooth" : "Turn On Bluetooth")
                                .padding()
                }
//                HomeTitleItem(isPressed: $isPressed)
                List (bluetoothManager.discoveredPeripherals,id: \.peripheral.identifier){per in
                    NavigationLink(value:routeForPeripheral(name: per.peripheral.name,peripheral: per.peripheral)) {
                        VStack {
                            Text(per.peripheral.name ?? "Unknown")
                            Text("UUID: \(per.id)")
                        }
                    }
                }
                Spacer()
            }.background(MyColorScheme.bgColor).homeRoutes()
            .sheet(isPresented: $showTestJsonView) {
                
            }
        }.onDisappear{
            bluetoothManager.stopScanning()
        }
    }
    func routeForPeripheral(name: String?, peripheral: CBPeripheral) -> PeripheralRoutes {
        if let name = name {
            if name.contains("Air Pro 007") || name.contains("AeroIns"){
                return .atomizer(peripheral: peripheral)
            }else if name.contains("Air Fit Smart"){
                return .airFitSmart
            }
        }
        return .defaultView
    }
    
    private var titleBar: some View {
        HStack {
            Spacer()
            HStack(spacing: 30) {
                tabButton(for: .all)
                tabButton(for: .sort)
            }
            Spacer()
        }
    }

    private func tabButton(for tab: HomeTitleTab) -> some View {
        VStack {
            Text(tab == .all ? "All" : "Sort")
                .foregroundColor(isPressed == tab ? .blue : .brown)
                .onTapGesture {
                    isPressed = tab
                }
            Rectangle()
                .fill(isPressed == tab ? Color.blue : Color.clear)
                .frame(height: 2)
                .frame(width: 20)
        }
    }

    private var nameView:some View{
        ImageTextView(
            imageName: "star", // 示例图标
            text: "Hi~G",  // 示例文本
            alignment: .rightImage, // 示例排列方式
            action: {
                selectedTab = TabType.profile
            }
        ).padding(.top,100).padding(.leading,20).frame(maxWidth: .infinity,alignment: .leading)
    }
}

#Preview {
    HomeView(selectedTab: .constant(TabType.home))
}


