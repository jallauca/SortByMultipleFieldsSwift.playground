//: Playground - noun: a place where people can play

import UIKit
import XCTest

struct Location {
    var city: String
    var county: String
    var state: String
}

var locations: [Location] {
    return [
        Location(city: "Dania Beach", county: "Broward", state: "Florida"),
        Location(city: "Fort Lauderdale", county: "Broward", state: "Florida"),
        Location(city: "Hallandale Beach", county: "Broward", state: "Florida"),
        Location(city: "Pompano Beach", county: "Broward", state: "Florida"),
        Location(city: "Boca Raton", county: "Palm Beach", state: "Florida"),
        Location(city: "Delray Beach", county: "Palm Beach", state: "Florida"),
        Location(city: "West Palm Beach", county: "Palm Beach", state: "Florida"),
        Location(city: "Aventura", county: "Miami-Dade", state: "Florida"),
        Location(city: "Bal Harbour", county: "Miami-Dade", state: "Florida"),
        Location(city: "Coral Gables", county: "Miami-Dade", state: "Florida"),
        Location(city: "Miami Beach", county: "Miami-Dade", state: "Florida"),

        Location(city: "Savannah", county: "Chatham", state: "Georgia"),
        Location(city: "Richmond Hill", county: "Bryan", state: "Georgia"),
        Location(city: "St. Marys", county: "Camden", state: "Georgia"),
        Location(city: "Kingsland", county: "Camden", state: "Georgia"),
    ]
}

func test_regular_sort_by_county_and_city_anonymous_closures() {
    let sortedLocations =
        locations
            .sorted {
                if $0.county == $1.county {
                    return $0.city < $1.city
                } else {
                    return $0.county < $1.county
                }
            }
            .map { $0.city }

    let expected = [
        "Dania Beach", "Fort Lauderdale", "Hallandale Beach",
        "Pompano Beach", "Richmond Hill", "Kingsland", "St. Marys",
        "Savannah", "Aventura", "Bal Harbour", "Coral Gables",
        "Miami Beach", "Boca Raton", "Delray Beach", "West Palm Beach"
    ]
    XCTAssertEqual(expected, sortedLocations)
}
test_regular_sort_by_county_and_city_anonymous_closures()

func test_regular_sort_by_state_desc_county_and_city_anonymous_closures() {
    let sortedLocations =
        locations
            .sorted {
                if $0.state == $1.state {
                    if $0.county == $1.county {
                        return $0.city < $1.city
                    } else {
                        return $0.county < $1.county
                    }
                } else {
                    return $0.state > $1.state
                }
            }
            .map { $0.city }

    let expected = [
        "Richmond Hill", "Kingsland", "St. Marys", "Savannah",
        "Dania Beach", "Fort Lauderdale", "Hallandale Beach",
        "Pompano Beach", "Aventura", "Bal Harbour", "Coral Gables",
        "Miami Beach", "Boca Raton", "Delray Beach", "West Palm Beach"
    ]
    XCTAssertEqual(expected, sortedLocations)
}
test_regular_sort_by_state_desc_county_and_city_anonymous_closures()

extension Sequence {
    typealias ClosureCompare = (Iterator.Element, Iterator.Element) -> ComparisonResult

    func sorted(by comparisons: ClosureCompare...) -> [Iterator.Element] {
        return self.sorted { e1, e2 in
            for comparison in comparisons {
                let comparisonResult = comparison(e1, e2)
                guard comparisonResult == .orderedSame
                    else { return comparisonResult == .orderedAscending }
            }
            return false
        }
    }
}

func test_sort_by_county_and_city_with_anonymous_closures() {
    let sortedLocations =
        locations
            .sorted(by:
                { $0.county.compare($1.county) },
                    { $0.city.compare($1.city) }
            )
            .map { $0.city }

    let expected = [
        "Dania Beach", "Fort Lauderdale", "Hallandale Beach",
        "Pompano Beach", "Richmond Hill", "Kingsland", "St. Marys",
        "Savannah", "Aventura", "Bal Harbour", "Coral Gables",
        "Miami Beach", "Boca Raton", "Delray Beach", "West Palm Beach"
    ]
    XCTAssertEqual(expected, sortedLocations)
}
test_sort_by_county_and_city_with_anonymous_closures()

extension Location {
    static func cityCompare(e1: Location, e2: Location) -> ComparisonResult {
        return e1.city.compare(e2.city)
    }

    static func countyCompare(e1: Location, e2: Location) -> ComparisonResult {
        return e1.county.compare(e2.county)
    }

    static func stateCompare(e1: Location, e2: Location) -> ComparisonResult {
        return e1.state.compare(e2.state)
    }
}

func test_sort_by_county_and_city_with_static_methods() {
    let sortedLocations =
        locations
            .sorted(by:
                Location.countyCompare,
                Location.cityCompare
            )
            .map { $0.city }

    let expected = [
        "Dania Beach", "Fort Lauderdale", "Hallandale Beach",
        "Pompano Beach", "Richmond Hill", "Kingsland", "St. Marys",
        "Savannah", "Aventura", "Bal Harbour", "Coral Gables",
        "Miami Beach", "Boca Raton", "Delray Beach", "West Palm Beach"
    ]
    XCTAssertEqual(expected, sortedLocations)
}
test_sort_by_county_and_city_with_static_methods()

extension ComparisonResult {
    static func flip(c: ComparisonResult) -> ComparisonResult {
        switch c {
        case .orderedAscending:
            return .orderedDescending
        case .orderedDescending:
            return .orderedAscending
        default:
            return .orderedSame
        }
    }
}
infix operator <<<
func <<< <A, B, C>(f: @escaping (B) -> C, g: @escaping (A) -> B) -> (A) -> C {
    return { x in f(g(x)) }
}

func test_sort_by_state_desc_county_asc_and_city_with_static_methods() {
    let sortedLocations =
        locations
            .sorted(by:
                ComparisonResult.flip <<< Location.stateCompare,
                Location.countyCompare,
                Location.cityCompare
            )
            .map { $0.city }

    let expected = ["Richmond Hill", "Kingsland", "St. Marys", "Savannah",
                    "Dania Beach", "Fort Lauderdale", "Hallandale Beach",
                    "Pompano Beach", "Aventura", "Bal Harbour", "Coral Gables",
                    "Miami Beach", "Boca Raton", "Delray Beach", "West Palm Beach"]
    XCTAssertEqual(expected, sortedLocations)
}
test_sort_by_state_desc_county_asc_and_city_with_static_methods()

extension Location {
    func cityCompare(e2: Location) -> ComparisonResult {
        return city.compare(e2.city)
    }

    func countyCompare(e2: Location) -> ComparisonResult {
        return county.compare(e2.county)
    }

    func stateCompare(e2: Location) -> ComparisonResult {
        return state.compare(e2.state)
    }
}
extension ComparisonResult {
    func flip() -> ComparisonResult {
        switch self {
        case .orderedAscending:
            return .orderedDescending
        case .orderedDescending:
            return .orderedAscending
        default:
            return .orderedSame
        }
    }
}

func <<< <A, B, C>(f: @escaping (B) -> () -> C, g: @escaping (A) -> (A) -> B) -> (A) -> (A) -> C {
    return { x in { y in f(g(x)(y))() } }
}
extension Sequence {
    typealias AttributeCompare = (Iterator.Element) -> (Iterator.Element) -> ComparisonResult

    func sorted(by comparisons: AttributeCompare...) -> [Iterator.Element] {
        return self.sorted { e1, e2 in
            for comparison in comparisons {
                let comparisonResult = comparison(e1)(e2)
                guard comparisonResult == .orderedSame
                    else {
                        return comparisonResult == .orderedAscending
                }
            }
            return false
        }
    }
}

func test_sort_by_state_desc_county_asc_and_city_with_instance_methods() {
    let sortedLocations =
        locations
            .sorted(by:
                ComparisonResult.flip <<< Location.stateCompare,
                    Location.countyCompare,
                    Location.cityCompare
            )
            .map { $0.city }

    let expected = ["Richmond Hill", "Kingsland", "St. Marys", "Savannah",
                    "Dania Beach", "Fort Lauderdale", "Hallandale Beach",
                    "Pompano Beach", "Aventura", "Bal Harbour", "Coral Gables",
                    "Miami Beach", "Boca Raton", "Delray Beach", "West Palm Beach"]
    XCTAssertEqual(expected, sortedLocations)
}
test_sort_by_state_desc_county_asc_and_city_with_instance_methods()