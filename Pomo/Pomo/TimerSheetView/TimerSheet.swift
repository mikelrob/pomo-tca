//
//  TimerSheet.swift
//  Pomo
//
//  Created by Mike Robinson on 04/08/2023.
//

import ComposableArchitecture

struct TimerSheet: Reducer {
    var body: some ReducerOf<Self> {
        Reduce { state, action in
                .none
        }
    }

    enum Action: Equatable {
        case tappedRemove
    }

    struct State: Equatable {
        let timerItem: TimerItem
        var emoji: String {
            switch timerItem.secondsElapsed {
            case 5...80:
                return "💪"
            case 80...:
                return "🤯"
            default:
                return "⏰"
            }
        }
    }
}
