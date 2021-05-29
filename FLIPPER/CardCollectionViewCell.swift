//
//  CardCollectionViewCell.swift
//  FLIPPER
//
//  Created by SHUBHAM KUMAR on 27/05/21.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var frontCardImage: UIImageView!
    
    @IBOutlet weak var backCardImage: UIImageView!
    
    var card:Card?
    
    func setCard(_ card:Card){
        //        keep track of card
        self.card = card
        
        if card.isMatched == true {
            
            //             if the card is matched make it invisible
            backCardImage.alpha = 0
            frontCardImage.alpha = 0
            
            return
        }
        else{
            
            //             if the card is not matched make it visible
            backCardImage.alpha = 1
            frontCardImage.alpha = 1
        }
        
        frontCardImage.image = UIImage(named: card.imageName)
        
        //        determine the flip mode of the card
        if card.isFlipped == true {
            //            make sure front image view is on the top
            
            UIView.transition(from: backCardImage, to: frontCardImage, duration: 0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        }
        else{
            //            make sure the back image view is on top
            UIView.transition(from: frontCardImage, to: backCardImage, duration: 0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        }
    }
    
    func flip(){
        
        UIView.transition(from: backCardImage, to: frontCardImage, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
    }
    
    func flipBack(){
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            
            UIView.transition(from: self.frontCardImage, to: self.backCardImage, duration: 0.3, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
        }
        
    }
    
    func remove() {
        
        //         remove both images
        
        backCardImage.alpha = 0
        
        //         animate it
        
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            
            self.frontCardImage.alpha = 0
            
        }, completion: nil)
        frontCardImage.alpha = 0
    }
}
