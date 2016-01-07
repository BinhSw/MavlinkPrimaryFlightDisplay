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
    
    let artificalHorizon: ArtificialHorizon
    let pitchLadder: PitchLadder
    let attitudeReferenceIndex = AttitudeReferenceIndex()

    override init(size: CGSize) {
        artificalHorizon = ArtificialHorizon(sceneSize: size)
        pitchLadder = PitchLadder(sceneSize: size, degreeSpacing: 5)
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToView(view: SKView) {
        attitudeReferenceIndex.position = CGPoint.zero
        addChild(artificalHorizon)
        addChild(pitchLadder)
        addChild(attitudeReferenceIndex)
    }
}

extension PrimaryFlightDisplayScene: AttitudeSettable{

    func setAttitude(attitude: AttitudeType) {
        artificalHorizon.setAttitude(attitude)
        pitchLadder.setAttitude(attitude)
    }
}
