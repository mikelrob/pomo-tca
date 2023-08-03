//
//  PomoTests.swift
//  PomoTests
//
//  Created by Mike Robinson on 02/08/2023.
//

import ComposableArchitecture
@testable import Pomo
import XCTest

let testDate = Date()
let testUUID = UUID()
let clock = TestClock()

@MainActor
final class PomoTests: XCTestCase {

    func testToggleTimer() async throws {
        let store = TestStore(
            initialState: Pomo.State(timerTitle: "ToggleTest"),
            reducer: { Pomo() }) {
                $0.continuousClock = clock
                $0.uuid = UUIDGenerator { testUUID }
                $0.date = DateGenerator { testDate }
            }

        await store.send(.start) {
            $0.isTimerActive = true
        }

        await clock.advance(by: .seconds(3))

        await store.receive(.timerTicked) { $0.secondsElapsed = 1 }
        await store.receive(.timerTicked) { $0.secondsElapsed = 2 }
        await store.receive(.timerTicked) { $0.secondsElapsed = 3 }
        
        await store.send(.stop) {
            $0.isTimerActive = false
            $0.secondsElapsed = 0
            $0.timers = [
                TimerItem(
                    id: testUUID,
                    title: "ToggleTest",
                    secondsElapsed: 3,
                    date: testDate
                )
            ]
        }
    }

    func testTimerEndsNaturally() async throws {
        let store = TestStore(
            initialState: Pomo.State(
                timerTitle: "NaturalEndTest",
                secondsElapsed: 1498
            ),
            reducer: { Pomo() }) {
                $0.continuousClock = clock
                $0.uuid = UUIDGenerator { testUUID }
                $0.date = DateGenerator { testDate }
            }

        await store.send(.start) {
            $0.isTimerActive = true
        }

        await clock.advance(by: .seconds(2))

        await store.receive(.timerTicked) { $0.secondsElapsed = 1499 }
        await store.receive(.timerTicked) { $0.secondsElapsed = 1500 }

        await store.receive(.stop) {
            $0.isTimerActive = false
            $0.secondsElapsed = 0
            $0.timers = [
                TimerItem(
                    id: testUUID,
                    title: "NaturalEndTest",
                    secondsElapsed: 1500,
                    date: testDate
                )
            ]
        }
    }

}
