import Foundation

class Order {
    var items = [Item]()
    
    var status: Status = .pending
    
    enum Status {
        case pending
        case payed
    }
    
    enum OrdreError: Error {
        case ordreAlreadyPayed
        case orderIsEmpty
        case invalidPaymentMethod
        case insufficientFundings
    }
    
    func pay(with paymentMethod: PaymentMethod) throws -> Double {
        guard status == .pending else {
            throw OrdreError.ordreAlreadyPayed
        }
        
        guard items.count > 0 else {
            throw OrdreError.orderIsEmpty
        }
        
        var totalPrice = 0.0
        for item in items { totalPrice += item.price }
        
        
        guard paymentMethod.isValid else {
            throw OrdreError.invalidPaymentMethod
        }
        
        guard paymentMethod.maxAmount >= totalPrice else {
            throw OrdreError.insufficientFundings
        }
        
        status = .payed
        return totalPrice
    }
    
    func payFruits() {
        let order = Order()
        order.items = [
            Item(price: 2.40, description: "Melon"),
            Item(price: 4, description: "Fraises"),
            Item(price: 1.20, description: "Pomme")
        ]
        
        let cb = PaymentMethod(isValid: true, maxAmount: 100)
        do {
            // let price = try! order.pay(with: cb) // Part du principe qu'il n'y aura pas d'erreur
            // let price = try? order.pay(with: cb) // Utilise les Optional, price est Optional<Double>
            
            let price = try order.pay(with: cb)
            print("Votre commande d'un montant de \(price)€ a bien été prise en compte.")
        } catch let error as OrdreError {
            switch error {
            case .insufficientFundings: print("pas assez d'argent")
            case .invalidPaymentMethod: print("Mauvaise carte bleu")
            case .orderIsEmpty: print("Aucun article")
            case .ordreAlreadyPayed: print("Déjà payé")
            }
        } catch let error {
            print("Oups...\(error)")
        }
    }
}

struct Item {
    var price = 0.0
    var description = ""
}

struct PaymentMethod {
    var isValid = true
    var maxAmount = 100.0
}
