import XCTest
@testable import CountOnMe

class CalculatorModel_Tests: XCTestCase {
    
    private lazy var model = CalculatorModel(delegate: self)
    typealias SymbolAndSymbolString = (symbol: CalculatorSymbol, string: String)
    var protocolValue: String = ""
    
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
    
    func test1() {
        model.currentOperation = ""
        model.add(number: "0")
        XCTAssertEqual(model.currentOperation, "0")
        
        model.currentOperation = ""
        model.add(number: "1")
        XCTAssertEqual(protocolValue, "DELETEZERO")
        
        model.currentOperation = "1 + 2 ="
        model.add(number: "3")
        XCTAssertEqual(model.currentOperation, "03")
        XCTAssertEqual(protocolValue, "RESET")
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

extension CalculatorModel_Tests: CalculatorDelegate {
    func showAlertController(title: String, message: String) {
        protocolValue = "ALERT"
    }
    
    func resetTextView() {
        protocolValue = "RESET"
    }
    
    func addText(text: String) {
        //
    }
    
    func deleteZero() {
        protocolValue = "DELETEZERO"
    }
    
    
}
