//
//  PrimaryFlightDisplayScene.swift
//  MavlinkPrimaryFlightDisplay
//
//  Created by Michael Koukoullis on 21/11/2015.
//  Copyright © 2015 Michael Koukoullis. All rights reserved.
//

import SpriteKit
import Darwin

public class PrimaryFlightDisplayView: SKView {
    
    // MARK: Initializers
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        let scene = PrimaryFlightDisplayScene(size: bounds.size)
        scene.scaleMode = .AspectFill
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        presentScene(scene)
        
        // Apply additional optimizations to improve rendering performance
        ignoresSiblingOrder = true
        
        // Diagnostics
        showsFPS = true
        showsNodeCount = true
    }    
}

extension PrimaryFlightDisplayView: AttitudeSettable {
    func setAttitude(attitude: AttitudeType) {
        if let scene = scene as? PrimaryFlightDisplayScene {
            scene.setAttitude(attitude)
        }
    }
}

private class PrimaryFlightDisplayScene: SKScene {
    
    let horizon: Horizon
    let pitchLadder: PitchLadder
    let attitudeReferenceIndex = AttitudeReferenceIndex()
    let bankIndicator = BankIndicator()
    let altimeter = TapeIndicator(
        size: Constants.Size.Altimeter.size,
        style: TapeIndicatorStyle(orientation: .Vertical, justification: .Right),
        backgroundColor: Constants.Color.Altimeter.background)
    let airSpeedIndicator = TapeIndicator(
        size: Constants.Size.AirSpeedIndicator.size,
        style: TapeIndicatorStyle(orientation: .Vertical, justification: .Left),
        backgroundColor: Constants.Color.AirSpeedIndicator.background)
    let headingIndicator = TapeIndicator(
        size: Constants.Size.HeadingIndicator.size,
        style: TapeIndicatorStyle(orientation: .Horizontal, justification: .Top),
        backgroundColor: Constants.Color.HeadingIndicator.background)

    override init(size: CGSize) {
        horizon = Horizon(sceneSize: size)
        pitchLadder = PitchLadder(sceneSize: size)
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToView(view: SKView) {
        scaleMode = .ResizeFill
        addChild(horizon)
        addChild(pitchLadder)
        addChild(attitudeReferenceIndex)
        addChild(bankIndicator)
        addChild(altimeter)
        addChild(airSpeedIndicator)
        addChild(headingIndicator)
    }
    
    private override func didChangeSize(oldSize: CGSize) {
        altimeter.position = CGPoint(
            x: -size.width/2 + Constants.Size.Altimeter.size.width/2,
            y: 0)
        airSpeedIndicator.position = CGPoint(
            x: size.width/2 - Constants.Size.AirSpeedIndicator.size.width/2,
            y: 0)
        headingIndicator.position = CGPoint(
            x: 0,
            y: size.height/2 - Constants.Size.HeadingIndicator.size.height/2)
    }
}

extension PrimaryFlightDisplayScene: AttitudeSettable {

    func setAttitude(attitude: AttitudeType) {
        horizon.setAttitude(attitude)
        pitchLadder.setAttitude(attitude)
        bankIndicator.setAttitude(attitude)
    }
}
