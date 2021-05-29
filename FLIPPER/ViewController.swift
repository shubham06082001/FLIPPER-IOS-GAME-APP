//
//  ViewController.swift
//  FLIPPER
//
//  Created by SHUBHAM KUMAR on 27/05/21.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var model = CardModel()
    
    var cardArray = [Card]()
    
    var firstFlippedCardIndex: IndexPath?
    
    var timer:Timer?
    
    //     10 seconds
    var milliseconds:Float = 30 * 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        cardArray = model.getCards()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //         create timer
        
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        SoundManager.playSound(.shuffle)
    }
    
    //    MARK: - Timer Methods
    
    @objc func timerElapsed(){
        
        milliseconds -= 1
        
        //         convert to seconds
        let seconds = String(format: "%.2f", milliseconds/1000)
        
        //         set label
        timerLabel.text = "TIME REAMAINING: \(seconds)"
        
        //     when the timer has reaached zero.....
        if milliseconds <= 0 {
            //             stop the timer
            timer?.invalidate()
            timerLabel.textColor = UIColor.red
            
            //             check for unmatched cards
            checkGameEnded()
        }
    }
    
    //    MARK: - UICollectionView Protocol Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return cardArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //        get a card collection view cell object
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        //        get the card for collection view is trying to display
        let card = cardArray[indexPath.row]
        
        //        set the card for the cell
        cell.setCard(card)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //         check if time left
        if milliseconds <= 0{
            return
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        
        let card = cardArray[indexPath.row]
        
        if card.isFlipped == false && card.isMatched == false{
            
            //            flip the card
            cell.flip()
            
            SoundManager.playSound(.flip)
            
            //            set the status of the card
            card.isFlipped = true
            
            //             determine if its 1st card or second card
            
            if firstFlippedCardIndex == nil {
                
                //                first card being flipped
                firstFlippedCardIndex = indexPath
            }
            else{
                
                //                 this is second card being flipped
                
                //                TODO: Perform the matching logic
                checkForMatches(indexPath)
                
            }
        }
    }
    
    //    MARK: - Game Logic Methods
    
    func checkForMatches(_ secondFlippedCardIndex: IndexPath){
        
        //        get the cells for the two cards that were revealed
        
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        //         get the cards for the 2 cards that were revealed
        
        let cardOne = cardArray[firstFlippedCardIndex!.row]
        let cardTwo = cardArray[secondFlippedCardIndex.row]
        
        //         compare the 2 cards
        
        if cardOne.imageName == cardTwo.imageName {
            
            //             its a match
            
            SoundManager.playSound(.match)
            
            //             set the statuses of the cards
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            //             remove the cards from the grid
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            //             check for left unmatched cards
            checkGameEnded()
            
        }
        else{
            
            //             its not a match
            SoundManager.playSound(.nomatch)
            //             set the statuses of the cards
            
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            //             flip both cards back
            
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()
        }
        
        //        tell the collection view to reload the cell of the first card if it is nil
        
        if cardOneCell == nil {
            
            collectionView.reloadItems(at: [firstFlippedCardIndex!])
        }
        
        firstFlippedCardIndex = nil
    }
    
    func checkGameEnded() {
        
        //         determine if any cards unmatched
        var isWon = true
        
        for card in cardArray {
            
            if card.isMatched == false {
                isWon = false
                break
            }
        }
        
        //         messaging variables
        var title = ""
        var message = ""
        
        //         no -- stop timer -- user won
        
        if isWon == true {
            if milliseconds > 0 {
                timer?.invalidate()
            }
            
            title = "CONGRATULATIONS!!"
            message = "You have won the match..."
        }
        
        //         yes -- check time left
        
        else{
            if milliseconds > 0 {
                return
            }
            
            title = "GAME OVER!!"
            message = "You have lost the match..."
        }
        //         show won or lost messaage
        
        showAlert(title, message)
    }
    
    func showAlert(_ title:String, _ message:String){
        
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}

