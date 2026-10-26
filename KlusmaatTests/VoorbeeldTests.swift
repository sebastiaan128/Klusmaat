//
//  VoorbeeldTests.swift
//  KlusmaatTests
//
//  Voorbeeldtest met Swift Testing die altijd slaagt.
//

import Testing

struct VoorbeeldTests {
    @Test func altijdGroen() {
        #expect(1 + 1 == 2)
    }
}
