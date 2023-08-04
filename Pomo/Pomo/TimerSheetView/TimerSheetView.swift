//
//  TimerSheetView.swift
//  Pomo
//
//  Created by Mike Robinson on 04/08/2023.
//

import SwiftUI
import ComposableArchitecture

struct TimerSheetView: View {

    let store: StoreOf<TimerSheet>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                Text("You've spent")
                    .font(.largeTitle)

//                let (minutes, seconds) = (1, 1)
//
//                Text("\(minutes) minutes, \(seconds) seconds")

                Text(
                    Duration.seconds(
                        viewStore.timerItem.secondsElapsed
                    ),
                    format: .units(
                        allowed: [.minutes, .seconds],
                        width: Duration.UnitsFormatStyle.UnitWidth.abbreviated,
                        maximumUnitCount: nil,
                        zeroValueUnits: Duration.UnitsFormatStyle.ZeroValueUnitsDisplayStrategy.hide,
                        valueLength: nil,
                        fractionalPart: Duration.UnitsFormatStyle.FractionalPartDisplayStrategy.hide
                    )
                )
                .font(.title)
                .fontWeight(.bold)

                Text(viewStore.emoji)
                    .font(.system(size: 120, weight: .bold))
                    .padding(24)

                Text("Working on")
                    .font(.largeTitle)

                Text(viewStore.timerItem.title)
                    .font(.title)
                    .fontWeight(.bold)

            }
            .toolbar {
                Button(action: {
                    viewStore.send(.tappedRemove)
                }, label: {
                    Image(systemName: "trash")
                })
                .tint(.red)
            }
        }
    }
}

#Preview {
    NavigationView {
        TimerSheetView(
            store: StoreOf<TimerSheet>(
                initialState: TimerSheet.State(
                    timerItem: TimerItem(
                        id: UUID(),
                        title: "Preview timer",
                        secondsElapsed: 45,
                        date: .now
                    )
                ),
                reducer: { TimerSheet() }
            )
        )
    }
}
