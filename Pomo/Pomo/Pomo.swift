//
//  Pomo.swift
//  Pomo
//
//  Created by Mike Robinson on 02/08/2023.
//

import Foundation
import ComposableArchitecture

struct Pomo: Reducer {

    @Dependency(\.continuousClock) var clock
    @Dependency(\.uuid) var uuid
    @Dependency(\.date) var date

//    var body: some Reducer<Self.State, Self.Action> {
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .start:
                state.isTimerActive = true
                return .run { send in
                    for await _ in clock.timer(interval: .seconds(1)) {
                        await send(.timerTicked)
                    }
                }
                .cancellable(id: TimerCancelID.cancel)
            case .stop:
                if state.secondsElapsed > 0 {
                    state.timers.append(
                        TimerItem(
                            id: uuid(),
                            title: state.timerTitle,
                            secondsElapsed: state.secondsElapsed,
                            date: date()
                        )
                    )
                }
                state.isTimerActive = false
                state.secondsElapsed = 0
                return .cancel(id: TimerCancelID.cancel)
            case .titleChanged(let title):
                state.timerTitle = title
                return .none
            case .timerTicked:
                state.secondsElapsed += 1

                if state.secondsElapsed == 1500 {
                    return .send(.stop)
                }
                return .none
            }
        }
    }

    enum Action: Equatable {
        case start
        case stop
        case titleChanged(String)
        case timerTicked
    }

    struct State: Equatable {
        var isTimerActive = false
        var timerTitle = ""
        var isStartDisabled: Bool { timerTitle.isEmpty }
        var secondsElapsed = 0
        var timers = [TimerItem]()
    }

//    func reduce(into state: inout State, action: Action) -> Effect<Action> {
//        .none
//    }
}

struct TimerItem: Equatable, Identifiable {
    var id: UUID
    var title: String
    var secondsElapsed: Int
    var date: Date
}

private enum TimerCancelID { case cancel }
