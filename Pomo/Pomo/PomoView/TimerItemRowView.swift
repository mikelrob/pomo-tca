//
//  TimerItemRowView.swift
//  Pomo
//
//  Created by Mike Robinson on 03/08/2023.
//

import SwiftUI

struct TimerItemRowView: View {
    
    let item: TimerItem
    var tapAction: () -> Void = { print("tapped the button")
    }

    var body: some View {
        Button(action: tapAction,
               label: {
            VStack(alignment: .leading) {
                Text("\(item.title)")
                    .font(.title2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    Image(systemName: "timer")
                    Text(
                        Duration.seconds(
                            item.secondsElapsed
                        ),
                        format: .time(pattern: .minuteSecond
                                     )
                    )
                    Image(systemName: "calendar")
                    Text(
                        item.date,
                        format: .relative(
                            presentation: .named,
                            unitsStyle: .abbreviated
                        )
                    )
                }
                .font(.caption)
            }
            .padding()
            .background(
                in: RoundedRectangle(cornerRadius: 15.0)
            )
            .backgroundStyle(
                .conicGradient(
                    colors: [
                        .pink.opacity(0.5),
                        .accent,
                    ],
                    center: .bottom
                )
            )
        })
    }
}

#Preview {
    let timers = [
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

    return ForEach(timers) { item in
        TimerItemRowView(item: item)
    }
    .padding(.horizontal)
}
