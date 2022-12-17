import XCTest
@testable import CountOnMe

class CalculatorModel_Tests: XCTestCase {
    
    private lazy var model = CalculatorModel(delegate: self)
    typealias SymbolAndSymbolString = (symbol: CalculatorSymbol, string: String)
    
    var protocolValue: String = ""
    var number = "0"
    
    func test_calculator_symbol_enum() {
        // arrange
        let symbolAndSymbolStringArray: [SymbolAndSymbolString] = [
            (.add, " + "),
            (.divide, " / "),
            (.multiplication, " X "),
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
        when(symbolToTestIs: .substraction, thenSymbolStringShouldBe: " - ")
    }
    
    func testGivenZeroOnTheScreen_WhenStartWithZero_ThenOnlyOneZeroStill() {
        
        model.currentOperation = number
        model.add(number: number)
        XCTAssertEqual(model.currentOperation, number)
    }
    
    func testGivenCleanView_WhenStartWithZero_ThenShouldBeZero() {
        model.currentOperation = ""
        model.add(number: number)
        XCTAssertEqual(model.currentOperation, number)
    }
    
    func testGivenClearScreen_WhenNumberButtonPressedOtherThenZero_ThenDeletZero() {
        number = "1"
        model.currentOperation = ""
        model.add(number: number)
        XCTAssertEqual(model.currentOperation, "1")
        XCTAssertEqual(protocolValue, "ADDTEXT")
    }
    
    func testGivenExpressionHaveResult_WhenAddNumber_ThenNumberAdded() {
        model.expressionHaveResult = true
        number = "1"
        model.add(number: number)
        XCTAssertEqual(model.currentOperation, "1")
        XCTAssertFalse(model.expressionHaveResult)
    }
    
    func testGivenExpressionHaveResult_WhenNumberButtonPressed_ThenClearAll() {
        model.expressionHaveResult = true
        model.add(number: number)
        XCTAssertEqual(model.currentOperation, number)
    }
    
    func testGivenStartingOperation_WhenAddSymbol_ThenClearAll() {
        let symbol: CalculatorSymbol = .divide
        model.expressionHaveResult = true
        model.add(symbol: symbol)
        XCTAssertEqual(model.currentOperation, "")
    }
    func testGivenStartingOperation_WhenAddSymbol_ThenSymbolAdded() {
        model.expressionHaveResult = false
        model.currentOperation = "1 + 2"
        model.add(symbol: .add)
        XCTAssertEqual(model.currentOperation, "1 + 2 + ")
    }
    
    func testGivenExpressionEndsWithSymbol_whenEquelButttonPressed_thenAllertShowUp() {
        model.currentOperation = "1 +"
        model.calculate()
        XCTAssertEqual(model.currentOperation, "1 +")
        XCTAssertEqual( protocolValue, "SHOW_ALERT")
    }
    
    func testGivenExpressionContainsOnlyOne_whenEquelButttonPressed_thenAllertShowUp() {
        model.currentOperation = "1"
        model.calculate()
        XCTAssertEqual(model.currentOperation, "1")
        XCTAssertEqual( protocolValue, "SHOW_ALERT")
    }
    
    func testGivenExpressionBeginsWithSymbol_whenEquelButttonPressed_thenAllertShowUp() {
        model.currentOperation = "+ + 1"
        model.calculate()
        XCTAssertEqual(model.currentOperation, "+ + 1")
        XCTAssertEqual( protocolValue, "SHOW_ALERT")
    }
    
    func testGivenExpressionHasTwoSymbolConsecutive_whenEquelButttonPressed_thenAllertShowUp() {
        model.currentOperation = "1 + + 1"
        model.calculate()
        XCTAssertEqual(model.currentOperation, "1 + + 1")
        XCTAssertEqual( protocolValue, "SHOW_ALERT")
    }
    
    func testGivenOnePlusOne_whenEquelButttonPressed_thenTheResultShoudBeTwo(){
        model.currentOperation = "1 + 1"
        model.calculate()
        XCTAssertEqual(model.currentOperation, "2")
    }
    
    func testGivenOneTimesOne_whenEquelButttonPressed_thenTheResultShoudBeOne(){
        model.currentOperation = "1 X 1"
        model.calculate()
        XCTAssertEqual(model.currentOperation, "1")
    }
    
    func testGivenOneDividedByOne_whenEquelButttonPressed_thenTheResultShoudBeOne() {
        model.currentOperation = "1 / 1"
        model.calculate()
        XCTAssertEqual(model.currentOperation, "1")
    }
    
    func testGivenOneMinusOne_whenEquelButttonPressed_thenTheResultShoudBeZero(){
        model.currentOperation = "1 - 1"
        model.calculate()
        XCTAssertEqual(model.currentOperation, "0")
    }
    
    func testGivenOneDividedByZero_whenEquelButttonPressed_thenAllertShowUp() {
        model.currentOperation = "1/0"
        model.calculate()
        XCTAssertEqual(model.currentOperation, "1/0")
        XCTAssertEqual(protocolValue, "SHOW_ALERT")
    }
    
    func testGivenTextOnTheScreen_WhenAcButtonPressed_ThenAllClear() {
        model.calculate()
        model.currentOperation = "86"
        model.delegate.clearAll()
        XCTAssertEqual(model.currentOperation, "86")
        XCTAssertEqual(protocolValue, "CLEARALL")
    }
    
    func testGivenTextOnTheScreen_WhenResset_ThenShouldBeZeroOnTheScreen() {
        model.calculate()
        model.currentOperation = "5"
        model.delegate.deleteZero()
        XCTAssertEqual(model.currentOperation, "5")
        XCTAssertEqual(protocolValue, "DELETEZERO")
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
    func resetTextView() {
        protocolValue = "RESET"
    }
    
    func clearAll() {
        protocolValue = "CLEARALL"
    }
    
    func showAlertController(title: String, message: String) {
        protocolValue = "SHOW_ALERT"
    }
    
    func testshowAlertController(title: String, message: String) {
        protocolValue = "ALERT"
    }
    
    func addText(text: String) {
        protocolValue = "ADDTEXT"
    }
    
    func deleteZero() {
        protocolValue = "DELETEZERO"
    }
    
}


