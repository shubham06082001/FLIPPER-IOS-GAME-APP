//
//  CardModel.swift
//  FLIPPER
//
//  Created by SHUBHAM KUMAR on 27/05/21.
//

import Foundation

class CardModel{
    
    func getCards() -> [Card] {
        
        var generatedNumbersArray = [Int]()
        
        //        declare an array to store generated cards
        var generatedCardsArray = [Card]()
        
        //        randomly generate pair of cards
        while generatedNumbersArray.count <= 8{
            
            let randomNumber = arc4random_uniform(13) + 1
            
            //            OPTIONAL: MAke it generate unique cards
            
            if generatedNumbersArray.contains(Int(randomNumber)) == false {
                
                //            print(randomNumber)
                
                generatedNumbersArray.append(Int(randomNumber))
                
                let cardOne = Card()
                cardOne.imageName = "card\(randomNumber)"
                generatedCardsArray.append(cardOne)
                
                let cardTwo = Card()
                cardTwo.imageName = "card\(randomNumber)"
                generatedCardsArray.append(cardTwo)
            }
            
        }
        
        //        TODO: randomize the array
        
        for i in 0...generatedCardsArray.count - 1 {
            
            //             swap the number with random array
            let random = Int(arc4random_uniform(UInt32(generatedCardsArray.count)))
            
            let temp = generatedCardsArray[i]
            generatedCardsArray[i] = generatedCardsArray[random]
            generatedCardsArray[random] = temp
        }
        
        //        return the array
        
        return generatedCardsArray
    }
}
