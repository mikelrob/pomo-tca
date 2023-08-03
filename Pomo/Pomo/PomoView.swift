//
//  ContentView.swift
//  Pomo
//
//  Created by Mike Robinson on 02/08/2023.
//

import SwiftUI
import ComposableArchitecture

struct PomoView: View {

    let store: Store<Pomo.State, Pomo.Action>
//    let store: StoreOf<Pomo>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                VStack {
                    TimerView(secondsElapsed: viewStore.secondsElapsed)
                        .animation(.default, value: viewStore.secondsElapsed)

                    HStack(spacing: 15) {
                        Button(
                            action: {
                                if viewStore.isTimerActive {
                                    viewStore.send(.stop)
                                } else {
                                    viewStore.send(.start)
                                }
                            },
                            label: {
                                Image(systemName: viewStore.isTimerActive ? "stop.circle.fill" : "play.circle.fill")
                                    .imageScale(.large)
//                                Text(viewStore.isTimerActive ? "Stop" : "Start")
                            })
                        .opacity(viewStore.isStartDisabled ? 0.5 : 1.0)
                        .disabled(viewStore.isStartDisabled)

                        TextField("",
                                  text: viewStore.binding(
                                    get: \.timerTitle,
                                    send: { .titleChanged($0) }
                                  ),
                                  prompt: Text("Set a goal")
                        )
                        .disabled(viewStore.isTimerActive)
                        .padding()
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(lineWidth: 1.0)
                        }
                    }
                }
                .foregroundStyle(.white)
                .padding([.horizontal, .bottom])
                .background(ignoresSafeAreaEdges: .top)
                .background(in: Rectangle())
                .backgroundStyle(.pink)

                ForEach(viewStore.timers) { item in
                    TimerItemRowView(item: item)
                }
                .padding(.horizontal)

                Spacer()
            }
        }
    }
}

#Preview {
    PomoView(
        store: Store<Pomo.State, Pomo.Action>(
            initialState: Pomo.State(
                timers: [
                    TimerItem(
                        id: UUID(),
                        title: "Preview Timer 1",
                        secondsElapsed: 1234,
                        date: .now
                    ),
                    TimerItem(
                        id: UUID(),
                        title: "Preview Timer 2",
                        secondsElapsed: 1400,
                        date: .now - 60*60
                    ),
                ]
            ),
            reducer: { Pomo() })
    )
}
