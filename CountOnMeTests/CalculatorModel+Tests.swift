import XCTest
@testable import CountOnMe

class CalculatorModel_Tests: XCTestCase {
    
    typealias SymbolAndSymbolString = (symbol: CalculatorSymbol, string: String)
    
    func test_calculator_symbol_enum() {
        // arrange
       let symbolAndSymbolStringArray: [SymbolAndSymbolString] = [
            (.add, " + "),
           (.divide, " / "),
           (.multiplication, " X "),
            (.dot, "."),
           (.substraction, " - ")
        ]

        for symbolAndSymbolString in symbolAndSymbolStringArray {
            when(
                symbolToTestIs: symbolAndSymbolString.symbol,
                thenSymbolStringShouldBe: symbolAndSymbolString.string
            )
        }
        
        when(symbolToTestIs: .add, thenSymbolStringShouldBe: " + ")
        when(symbolToTestIs: .divide, thenSymbolStringShouldBe: " / ")
        when(symbolToTestIs: .multiplication, thenSymbolStringShouldBe: " X ")
        when(symbolToTestIs: .dot, thenSymbolStringShouldBe: ".")
        when(symbolToTestIs: .substraction, thenSymbolStringShouldBe: " - ")
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
//
