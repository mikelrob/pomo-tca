//
//  TimerView.swift
//  Pomo
//
//  Created by Mike Robinson on 03/08/2023.
//

import SwiftUI

struct TimerView: View {

    let secondsElapsed: Int

    var body: some View {
        HStack {
            Spacer()
            Text(Duration.seconds(secondsElapsed),
                 format: .time(
                    pattern: .minuteSecond
                 )
            )
            .frame(maxWidth: .infinity)
            .id(secondsElapsed)
            .monospacedDigit()
            .transition(
                .push(from: .top)
            )
            .font(.largeTitle)
            Spacer()
            HStack {
                Image(systemName: "smallcircle.filled.circle.fill")
                    .imageScale(
                        secondsElapsed.isMultiple(of: 2) ? .small : .large
                    )
                Image(systemName: "smallcircle.filled.circle.fill")
                    .imageScale(
                        secondsElapsed.isMultiple(of: 2) ? .large : .small
                    )
                Image(systemName: "smallcircle.filled.circle.fill")
                    .imageScale(
                        secondsElapsed.isMultiple(of: 2) ? .small : .large
                    )
                Image(systemName: "smallcircle.filled.circle.fill")
                    .imageScale(
                        secondsElapsed.isMultiple(of: 2) ? .large : .small
                    )
                Image(systemName: "smallcircle.filled.circle.fill")
                    .imageScale(
                        secondsElapsed.isMultiple(of: 2) ? .small : .large
                    )
            }
            .frame(maxWidth: .infinity)
            Spacer()
        }
    }
}

#Preview {
    Group {
        TimerView(secondsElapsed: 1)
        TimerView(secondsElapsed: 2)
        TimerView(secondsElapsed: 3)
        TimerView(secondsElapsed: 4)
        TimerView(secondsElapsed: 5)
        TimerView(secondsElapsed: 6)
    }
}
