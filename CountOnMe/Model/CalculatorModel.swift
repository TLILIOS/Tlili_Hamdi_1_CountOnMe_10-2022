import Foundation

enum CalculatorSymbol {
    case add, divide, multiplication, substraction
    
    func getSymbolString() -> String {
        switch self {
        case .add: return " + "
        case .divide: return " / "
        case .multiplication: return " X "
        case .substraction: return " - "
        }
    }
}


protocol CalculatorDelegate {
    func showAlertController(title: String, message: String)
    func resetTextView()
    func addText(text: String)
    func deleteZero()
    func clearAll()
}

final class CalculatorModel {
    
   let delegate: CalculatorDelegate
    
    init(delegate: CalculatorDelegate) {
        self.delegate = delegate
    }

    var currentOperation: String = "0"
    var expressionHaveResult: Bool = false
    
    // Return an array with the splitted expression
    private var elements: [String] {
        return self.currentOperation.split(separator:" ").map { "\($0)" }
    }
    
    private var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
   
    var expressionIsCorrect: Bool {
        guard elements.last != nil else { return false }
        return elements.last != "+" && elements.last != "-" && elements.last != "X" && elements.last != "/"
    }
    
    // MARK: - Private methods
    
    // Check if multiplication or divison, if so it will return concerned operand index.
    func checkPriorityOperand(arrayOfElements: [String]) -> Int {
        for (index, element) in arrayOfElements.enumerated() {
            if element == "X" || element == "/" {
                return index
            } else {
                continue
            }
        }
        return 1
    }
}
    


// MARK: - Public Methods

extension CalculatorModel {
    
    func add(number: String) {
        //The Operation starts with ZERO "0"
        if number == "0",  currentOperation == "0" || currentOperation == "" {
            self.currentOperation = number
        } else {
            //Remove default view "0"
            if currentOperation == "0" || currentOperation == "" , number != "0" {
                delegate.deleteZero()
            }
            
            if expressionHaveResult {
                self.resetText()
                delegate.clearAll()
                delegate.addText(text: number)
                self.currentOperation.append(number)
                expressionHaveResult = false
                return
            }
            
            delegate.addText(text: number)
            self.currentOperation.append(number)
        }
    }
    
    func add(symbol: CalculatorSymbol) {
        let text = symbol.getSymbolString()
        if expressionHaveResult {
            self.resetText()
            delegate.clearAll()
            expressionHaveResult = false
        } else if expressionIsCorrect {
            delegate.addText(text: text)
            self.currentOperation.append(text)
        } else {
            delegate.showAlertController(
                title: "Zéro!",
                message: "Vous ne pouvez pas insérer << \(symbol.getSymbolString()) >> à cette endroit "
            )
            delegate.clearAll()
        }
    }
    
    func resetText() {
        self.resetCurrentOperation()
        self.delegate.clearAll()
    }
    
    func resetCurrentOperation() {
        self.currentOperation = ""
    }
    
    func calculate() {
        guard expressionIsCorrect else {
            self.delegate.showAlertController(title: "Zéro!", message: "Expression incorrect ajoutez un numéro !")
            return
        }
        
        guard expressionHaveEnoughElement else {
            self.delegate.showAlertController(title: "Zéro!", message: "Démarrez un nouveau calcul !")
            return
        }
        // Create local copy of operations
        var operationsToReduce = elements
        
        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {
            let index = checkPriorityOperand(arrayOfElements: operationsToReduce)
            guard let left = Double(operationsToReduce[index - 1]) else {
                self.delegate.showAlertController(title: "Zéro!", message: "1er élement est incorrect")
                return
            }
            let operand = operationsToReduce[index]
            guard let right = Double(operationsToReduce[index + 1]) else {
                self.delegate.showAlertController(title: "Zéro!", message: "3ème élement est incorrect")
                return
            }
            
            var result: Double = 0.0
            
            switch operand {
            case "+": result = left + right
            case "-": result = left - right
            case "X": result = left * right
            case "/": if right != 0 {
                result = left / right
            } else {
                delegate.showAlertController(
                    title: "Zéro!",
                    message: "Division par Zéro non autorise !")
            }
                
            default: fatalError("Unknown operator !")
                
            }
            let startIndex: Int = index-1
            let endIndex: Int = index+1
            
            let resultNumber: Any = resultIsAnInteger(number: result) ? Int(result): result
            
            operationsToReduce.replaceSubrange(Range(startIndex...endIndex), with: [String(describing: resultNumber)])
            currentOperation = operand
            
        }
        
        let result = "\(operationsToReduce.first!)"
        resetText()
        self.currentOperation.append(result)
        delegate.addText(text: result)
        expressionHaveResult = true
    }

    func resultIsAnInteger(number: Double) -> Bool {
        return number.truncatingRemainder(dividingBy: 1) == 0
    }
}
