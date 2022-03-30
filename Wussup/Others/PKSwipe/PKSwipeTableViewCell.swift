//
//  PKSwipeTableViewCell.swift
//  Wussup
//
//  Created by MAC219 on 7/2/18.
//  Copyright © 2018 MAC26. All rights reserved.
//

import UIKit

protocol PKSwipeCellDelegateProtocol : class {
    func swipeBeginInCell(_ cell:PKSwipeTableViewCell)
    func swipeDoneOnPreviousCell()->PKSwipeTableViewCell?
    func buttonRemoveClicked(cell : WUFavoriteOptInTableCell)
    func switchToggleClicked(cell : WUFavoriteOptInTableCell)

}

class PKSwipeTableViewCell: UITableViewCell  {

    //Set the delegate object
    weak var delegate : PKSwipeCellDelegateProtocol?
    //set the view of right Side
    internal var isPanEnabled = true
    fileprivate var viewRightAccessory = UIView()
    fileprivate var backview:UIView = UIView()
    
    
    //MARK: Cell Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.resetCellState()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initializeCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initializeCell()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    //MARK: Gesture Method
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isKind(of: UIPanGestureRecognizer.classForCoder()) {
            let point =  (gestureRecognizer as! UIPanGestureRecognizer).translation(in: self.superview)
            return ((fabs(point.x) / fabs(point.y))) > 1 ? true : false
        }
        return false
    }
    
    //MARK: Private Functions
    /**
     This Method is used to initialize the cell with pan gesture and back views.
     
     */
    fileprivate func initializeCell() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))//#selector(PKSwipeTableViewCell.handlePanGesture(_:))
        self.addGestureRecognizer(panGesture)
        panGesture.delegate = self
        let cellFrame = CGRect(x: 0, y: 0,width: self.screenBoundsFixedToPortraitOrientation().height, height: self.frame.size.height)
        let viewBackground = UIView(frame: cellFrame)
        self.backgroundView = viewBackground
        self.backview =  UIView(frame:cellFrame)
        self.backview.autoresizingMask = UIViewAutoresizing.flexibleHeight
        self.isExclusiveTouch = true
        self.contentView.isExclusiveTouch = true
        self.backview.isExclusiveTouch = true
    }
    
    /**
     This function is used to get the screen frame independent of orientation
     
     - returns: frame of screen
     */
    func screenBoundsFixedToPortraitOrientation()->CGRect {
        let screen = UIScreen.main
        if screen.responds(to: #selector(getter: UIScreen.fixedCoordinateSpace)) {
            return screen.coordinateSpace.convert(screen.bounds, to: screen.fixedCoordinateSpace)
        }
        return screen.bounds
    }
    
    /**
     This Method will be called when user will start the panning
     
     - parameter panGestureRecognizer: panGesture Object
     */
    @objc func handlePanGesture(_ panGestureRecognizer : UIPanGestureRecognizer) {
        if isPanEnabled == false{
            return
        }
        
        if self.delegate != nil {
            let cell = self.delegate?.swipeDoneOnPreviousCell()
            if cell != self && cell != nil {
                cell?.resetCellState()
            }
        }
        
        if self.delegate != nil {
           self.delegate?.swipeBeginInCell(self)
        }

        let translation =  panGestureRecognizer.translation(in: panGestureRecognizer.view)
        let velocity = panGestureRecognizer .velocity(in: panGestureRecognizer.view)
        let panOffset = translation.x
        let actualTranslation = CGPoint(x: panOffset, y: translation.y)
        
        if panGestureRecognizer.state == UIGestureRecognizerState.began && panGestureRecognizer.numberOfTouches > 0 {
            //start swipe
            self.backgroundView!.addSubview(backview)
            self.backgroundView?.bringSubview(toFront: self.backview)
            self.backview.autoresizingMask = [UIViewAutoresizing.flexibleHeight ,UIViewAutoresizing.flexibleWidth]
            animateContentViewForPoint(actualTranslation, velocity: velocity)
        } else if(panGestureRecognizer.state == UIGestureRecognizerState.changed && panGestureRecognizer.numberOfTouches > 0) {
            //animate
            animateContentViewForPoint(actualTranslation, velocity: velocity)
        } else {
            //reset the state
            self.resetCellFromPoint(actualTranslation, withVelocity: velocity)
        }
    }
    
    /**
     This function is called when panning will start to update the frames to show the panning
     
     - parameter point:    point of panning
     - parameter velocity: velocity of panning
     */
    fileprivate func animateContentViewForPoint(_ point:CGPoint, velocity:CGPoint) {
        if (point.x < 0) {
            self.contentView.frame = self.contentView.bounds.offsetBy(dx: point.x, dy: 0)
            self.viewRightAccessory.frame = CGRect(x: max(self.frame.maxX-self.viewRightAccessory.frame.width,self.contentView.frame.maxX), y: self.viewRightAccessory.frame.minY, width: self.viewRightAccessory.frame.width, height: self.viewRightAccessory.frame.height)
        } else {
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.contentView.frame = self.contentView.bounds.offsetBy(dx: 0, dy: 0);
                self.resetCellState()
            }, completion: { (Bool) -> Void in
            })
        }
    }
    
    /**
     This function is called to reset the panning state. If panning is less then it will reset to the original position depending on panning direction.
     
     - parameter point:    point of panning
     - parameter velocity: velocity of panning
     */
    fileprivate func resetCellFromPoint(_ point:CGPoint, withVelocity velocity:CGPoint) {
        if (point.x > 0 && point.x <= self.frame.height) {
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.contentView.frame = self.contentView.bounds.offsetBy(dx: 0, dy: 0);
                self.viewRightAccessory.frame = CGRect(x: self.contentView.frame.maxX+20, y: 0, width: self.viewRightAccessory.frame.width, height: self.frame.height)
            }, completion: { (Bool) -> Void in
            })
        } else if point.x < 0 {
            if (point.x < -self.viewRightAccessory.frame.width) {
                // SCROLL MORE THAN VIEW ACCESSORY
                UIView.animate(withDuration: 0.5, animations: { () -> Void in
                    self.contentView.frame = self.contentView.bounds.offsetBy(dx: -self.viewRightAccessory.frame.width, dy: 0);
                }, completion: { (Bool) -> Void in
                })
            } else if -point.x < self.viewRightAccessory.frame.width {
                // IF SCROLL MORE THAN 50% THEN MAKE THE OPTIONS VISIBLE
                if -point.x > self.viewRightAccessory.frame.size.width / 2.0 {
                    UIView.animate(withDuration: 0.5, animations: { () -> Void in
                        self.contentView.frame = self.contentView.bounds.offsetBy(dx: -self.viewRightAccessory.frame.width, dy: 0)
                        self.viewRightAccessory.frame = CGRect(x: UIScreen.main.bounds.size.width - (self.viewRightAccessory.frame.width), y: 0, width: self.viewRightAccessory.frame.width, height: self.frame.height)
                        
                        
                    }, completion: { (Bool) -> Void in
                    })
                    
                }else {  // IF SCROLL LESS THEN MOVE TO ORIGINAL STATE
                    UIView.animate(withDuration: 0.5, animations: { () -> Void in
                        self.contentView.frame = self.contentView.bounds.offsetBy(dx: 0, dy: 0);
                        self.viewRightAccessory.frame = CGRect(x: self.contentView.frame.maxX + 20, y: 0, width: self.viewRightAccessory.frame.width, height: self.frame.height)
                    }, completion: { (Bool) -> Void in
                    })
                }
            }
        }
    }
    
    //MARK: public Methods
    /**
     This function is used to add the view in right side
     
     - parameter view: view to be displayed on the right hsnd side of the cell
     */
    internal func addRightOptionsView(_ view:UIView) {
        viewRightAccessory.removeFromSuperview()
        viewRightAccessory = view
        viewRightAccessory.autoresizingMask = UIViewAutoresizing.flexibleLeftMargin
        self.backview.addSubview(viewRightAccessory)
    }
    
    /**
     This function is used to reset the cell state back to original position to hide the right view options.
     */
    func resetCellState() {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.contentView.frame = self.contentView.bounds.offsetBy(dx: 0, dy: 0);
            self.viewRightAccessory.frame = CGRect(x: self.contentView.frame.maxX + 30, y: 0, width: self.viewRightAccessory.frame.width, height: self.frame.height) //ZALAK (+20)
        }, completion: { (Bool) -> Void in
        })
    }
    
    @objc func swipeBeginInCell(_ cell: PKSwipeTableViewCell) {
   
    }
    
    @objc func swipeDoneOnPreviousCell() -> PKSwipeTableViewCell? {
        return self
    }
}
