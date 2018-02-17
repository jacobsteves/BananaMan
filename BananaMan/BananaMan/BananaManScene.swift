//
//  BananaManScene.swift
//  BananaMan
//
//  Created by Jacob Steves on 2018-02-16.
//  Copyright © 2018 Jacob Steves. All rights reserved.
//

import Cocoa
import SpriteKit

struct PhysicsCategory {
    static let None: UInt32 = 0
    static let All: UInt32 = UInt32.max
    static let Edge: UInt32 = 0b1
    static let Character: UInt32 = 0b10
    static let Collider: UInt32 = 0b100
    static let Obstacle: UInt32 = 0b1000
}

let defaults = UserDefaults.standard

class BananaManScene: SKScene, SKPhysicsContactDelegate {

    var sceneCreated = false
    var gameStarted = false
    var canJump = false
    var shouldSpawnObstacle = false
    var shouldUpdateScore = false

    let titleNode = SKLabelNode(fontNamed: "Courier")
    let subtitleNode = SKLabelNode(fontNamed: "Courier")
    let scoreNode = SKLabelNode(fontNamed: "Courier")
    let bananamanSpriteNode = SKSpriteNode(imageNamed: "BananaManSprite")
    let bottomCollider: SKPhysicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: 0, y:0), to: CGPoint(x:1005, y:0))

    var currentScore = 0

    override func didMove(to view: SKView) {
        if !sceneCreated {
            sceneCreated = true
            createSceneContents()
        }
    }

    func viewDidLoad() {
        if (defaults.string(forKey: "highscore")?.isEmpty)! {
            defaults.set(generateScore(), forKey: "highscore")
        }
    }

    func startGame() {
        srand48(Int(arc4random()))

        for node in self.children {
            if (node.physicsBody?.categoryBitMask == PhysicsCategory.Obstacle) {
                self.removeChildren(in: [node])
            }
        }

        gameStarted = true
        canJump = true
        currentScore = 0
        shouldUpdateScore = true
        updateScore()
        titleNode.isHidden = true
        subtitleNode.isHidden = true
        self.shouldSpawnObstacle = true
        self.spawnObstacle()
    }

    func createSceneContents() {
        self.addChild(titleLabel())
        self.addChild(subtitleLabel())
        self.addChild(bananamanSprite())
        self.addChild(scoreLabel())
        self.physicsWorld.contactDelegate = self
        self.backgroundColor = SKColor(red: 200/255.0, green: 149/255.0, blue: 91/255.0, alpha: 1)

        self.physicsBody = bottomCollider
        bottomCollider.categoryBitMask = PhysicsCategory.Edge | PhysicsCategory.Collider
        bottomCollider.contactTestBitMask = PhysicsCategory.Character
        bottomCollider.friction = 0
        bottomCollider.restitution = 0
        bottomCollider.linearDamping = 0
        bottomCollider.angularDamping = 1
        bottomCollider.isDynamic = false
        bottomCollider.affectedByGravity = false
        bottomCollider.allowsRotation = false

        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.8)

        self.spawnObstacle()
    }

    func titleLabel() -> SKLabelNode {
        titleNode.text = "BananaMan"
        titleNode.fontSize = 10
        titleNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        titleNode.fontColor = SKColor.white
        titleNode.zPosition = 50

        return titleNode
    }

    func subtitleLabel() -> SKLabelNode {
        subtitleNode.text = "Touch anywhere to begin..."
        subtitleNode.fontSize = 7
        subtitleNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY-10)
        subtitleNode.fontColor = SKColor.white
        subtitleNode.zPosition = 50

        return subtitleNode
    }

    func scoreLabel() -> SKLabelNode {
        scoreNode.text = "HighScore: " + scoreFormat(score: defaults.integer(forKey: "highscore"))
        scoreNode.fontSize = 13
        scoreNode.horizontalAlignmentMode = .right
        scoreNode.position = CGPoint(x: self.frame.maxX - 4, y:self.frame.midY + 2)
        scoreNode.fontColor = SKColor.white
        scoreNode.zPosition = 80

        return scoreNode
    }

    func scoreFormat(score: Int) -> String {
        return String(format: "%07d", score)
    }

    func generateScore() -> String {
        return scoreFormat(score: currentScore)
    }

    func newHighscore() -> Bool {
        return currentScore > defaults.integer(forKey: "highscore")
    }

    func bananamanSprite() -> SKSpriteNode {
        bananamanSpriteNode.setScale(0.5)
        bananamanSpriteNode.position = CGPoint(x: 20, y: 40)
        bananamanSpriteNode.physicsBody = SKPhysicsBody(rectangleOf: bananamanSpriteNode.size)
        if let pb = bananamanSpriteNode.physicsBody {
            pb.isDynamic = true
            pb.affectedByGravity = true
            pb.allowsRotation = false
            pb.categoryBitMask = PhysicsCategory.Character
            pb.collisionBitMask = PhysicsCategory.Edge
            pb.contactTestBitMask = PhysicsCategory.Collider
            pb.restitution = 0
            pb.friction = 1
            pb.linearDamping = 1
            pb.angularDamping = 1
        }
        return bananamanSpriteNode
    }

    func updateHighscore() {
        defaults.set(currentScore, forKey: "highscore")
        scoreNode.text = "New Highscore: " + scoreNode.text!
    }

    func endGame() {

        titleNode.isHidden = false
        subtitleNode.isHidden = false

        canJump = false
        shouldSpawnObstacle = false
        gameStarted = false
        shouldUpdateScore = false

        if (newHighscore()) {
            updateHighscore()
        }

        for node in self.children {
            if (node.physicsBody?.categoryBitMask == PhysicsCategory.Obstacle) {
                node.physicsBody?.velocity = CGVector(dx:0, dy:0)
            }
        }
    }

    func jump() {

        if !gameStarted {
            startGame()
        }

        if !canJump {
            return
        }

        if let pb = bananamanSpriteNode.physicsBody {
            pb.applyImpulse(CGVector(dx:0, dy:6.8), at: bananamanSpriteNode.position)
        }
    }

    func spawnObstacle() {
        if self.shouldSpawnObstacle == false {
            return
        }

        let x = arc4random() % 3;

        if x != 2 {
            let ob = SKSpriteNode(imageNamed: "Obstacle")
            ob.setScale(CGFloat(drand48() * 0.2 + 0.3))
            ob.position = CGPoint(x: 1020, y: ob.size.height/2)
            ob.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Obstacle"), size: ob.size)
            if let pb = ob.physicsBody {
                pb.isDynamic = true
                pb.affectedByGravity = false
                pb.allowsRotation = false
                pb.categoryBitMask = PhysicsCategory.Obstacle
                pb.contactTestBitMask = PhysicsCategory.Character
                pb.collisionBitMask = 0
                pb.restitution = 0
                pb.friction = 0
                pb.linearDamping = 0
                pb.angularDamping = 0
                pb.velocity = CGVector(dx: -160, dy: 0)
            }
            self.addChild(ob)

            DispatchQueue.main.asyncAfter(deadline: .now() + 14.0, execute: {
                if self.shouldSpawnObstacle {
                    self.removeChildren(in: [ob])
                }
            })
        }


        let randDelay = drand48() * 0.3 - Double(currentScore) / 1000.0

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6 + randDelay, execute: {
            if self.shouldSpawnObstacle == true {
                self.spawnObstacle()
            }
        })
    }

    func updateScore() {
        currentScore += 1
        scoreNode.text = generateScore()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            if (self.shouldUpdateScore) {
                self.updateScore()
            }
        })
    }

    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA == bananamanSpriteNode.physicsBody && contact.bodyB == bottomCollider) ||
            (contact.bodyB == bananamanSpriteNode.physicsBody && contact.bodyA == bottomCollider) {
            canJump = true
        }
    }

    func didEnd(_ contact: SKPhysicsContact) {
        if (contact.bodyA == bananamanSpriteNode.physicsBody && contact.bodyB == bottomCollider) ||
            (contact.bodyB == bananamanSpriteNode.physicsBody && contact.bodyA == bottomCollider) {
            canJump = false
        } else {
            endGame()
        }
    }
}
