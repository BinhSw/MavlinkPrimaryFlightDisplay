//
//  PitchLadder.swift
//  MavlinkPrimaryFlightDisplay
//
//  Created by Michael Koukoullis on 5/01/2016.
//  Copyright © 2016 Michael Koukoullis. All rights reserved.
//

import SpriteKit

class PitchLadder: SKNode {
    
    private let minorPitchLineWidth = 20
    private let majorPitchLineWidth = 60
    private let minorPitchDegreeValues = Array(5.stride(to: 86, by: 10))
    private let majorPitchDegreeValues = Array(10.stride(to: 91, by: 10))
    private let cropNode = SKCropNode()
    private let maskNode = SKSpriteNode(color: SKColor.blackColor(), size: CGSize(width: 110, height: 220))
    
    init(sceneSize: CGSize, degreeSpacing: Int) {
        super.init()
        
        cropNode.maskNode = maskNode
        
        for degree in majorPitchDegreeValues {
            cropNode.addChild(PitchLineBuilder.pitchLineForDegree(degree, width: majorPitchLineWidth, degreeSpacing: degreeSpacing))
        }

        for degree in majorPitchDegreeValues.map({ $0 * -1 }) {
            cropNode.addChild(PitchLineBuilder.pitchLineForDegree(degree, width: majorPitchLineWidth, degreeSpacing: degreeSpacing))
        }
        
        for degree in minorPitchDegreeValues {
            cropNode.addChild(PitchLineBuilder.pitchLineForDegree(degree, width: minorPitchLineWidth, degreeSpacing: degreeSpacing))
        }

        for degree in minorPitchDegreeValues.map({ $0 * -1 }) {
            cropNode.addChild(PitchLineBuilder.pitchLineForDegree(degree, width: minorPitchLineWidth, degreeSpacing: degreeSpacing))
        }

        addChild(cropNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PitchLadder: AttitudeSettable {
    
    func setAttitude(attitude: AttitudeType) {
        cropNode.runAction(attitude.pitchAction())
        maskNode.runAction(attitude.pitchReverseAction())
        runAction(attitude.rollAction())
    }
}

struct PitchLineBuilder {
    
    static func pitchLineForDegree(degree: Int, width: Int, degreeSpacing: Int) -> SKShapeNode {
        let halfWidth = CGFloat(width) / 2
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, -halfWidth, 2)
        CGPathAddLineToPoint(path, nil, halfWidth, 2)
        CGPathAddLineToPoint(path, nil, halfWidth, -2)
        CGPathAddLineToPoint(path, nil, -halfWidth, -2)
        CGPathCloseSubpath(path)
        
        var transform = CGAffineTransformMakeTranslation(0, CGFloat(degree * degreeSpacing))
        let transformedPath = withUnsafeMutablePointer(&transform) {
            CGPathCreateMutableCopyByTransformingPath(path, $0)
        }

        let line = SKShapeNode(path: transformedPath!)
        line.fillColor = fillColor()
        line.strokeColor = SKColor.blackColor()
        return line
    }
    
    private static func fillColor() -> SKColor {
        return SKColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
    }
}

