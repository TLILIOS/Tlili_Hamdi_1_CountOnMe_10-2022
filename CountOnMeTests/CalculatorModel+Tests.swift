import XCTest
@testable import CountOnMe

class CalculatorModel_Tests: XCTestCase {
    
//    typealias NameAndAge = (name: String, age: Int)
    //        let nameAndAge: NameAndAge = ("Maxime", 30)
    //        nameAndAge.name
    //        nameAndAge.age
    
    typealias SymbolAndSymbolString = (symbol: CalculatorSymbol, string: String)
    
    func test_calculator_symbol_enum() {
        // arrange
//        let symbolAndSymbolStringArray: [SymbolAndSymbolString] = [
//            (.add, " + "),
//            (.divide, " / "),
//            (.multiplication, " X "),
//            (.percent, " % "),
//            (.dot, "."),
//            (.substraction, " - ")
//        ]
//
//        for symbolAndSymbolString in symbolAndSymbolStringArray {
//            when(
//                symbolToTestIs: symbolAndSymbolString.symbol,
//                thenSymbolStringShouldBe: symbolAndSymbolString.string
//            )
//        }
        
        when(
            symbolToTestIs: .add,
            thenSymbolStringShouldBe: " + "
        )
    }
}

// MARK: - Convenience Methods

extension CalculatorModel_Tests {
    
    private func when(
        symbolToTestIs symbolToTest: CalculatorSymbol,
        thenSymbolStringShouldBe symbolStringShouldBe: String
    ) {
        // act
        let symbolString = symbolToTest.getSymbolString()
        // assert
        XCTAssertEqual(symbolStringShouldBe, symbolString)
    }
}
