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
            case .timeItemTapped(let id):
                state.timerSheet = state.timers[id: id].flatMap(TimerSheet.State.init)
                return .none
            case .timerSheetAction(.presented(.tappedRemove)):
                if let id = state.timerSheet?.timerItem.id {
                    state.timers.remove(id: id)
                }

                state.timerSheet = nil
                
                return .none
            case .timerSheetAction(_):
                return .none
            }
        }
        .ifLet(\.$timerSheet, action: /Action.timerSheetAction) {
            TimerSheet()
        }
    }

    enum Action: Equatable {
        case timerSheetAction(PresentationAction<TimerSheet.Action>)

        case start
        case stop
        case titleChanged(String)
        case timerTicked
        case timeItemTapped(id: TimerItem.ID)
    }

    struct State: Equatable {
        @PresentationState var timerSheet: TimerSheet.State?

        var isTimerActive = false
        var timerTitle = ""
        var isStartDisabled: Bool { timerTitle.isEmpty }
        var secondsElapsed = 0
        var timers = IdentifiedArrayOf<TimerItem>()
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
