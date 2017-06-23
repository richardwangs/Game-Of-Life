//
//  Grid.swift
//  GameOfLife
//
//  Created by Mr StealUrGirl on 6/21/17.
//  Copyright © 2017 Mr StealUrGirl. All rights reserved.
//

import SpriteKit

class Grid: SKSpriteNode {
    
    var gridArray = [[Creature]]()
    var population = 0
    var generation = 0
    
    var neighborCount = 0
    /* Grid array dimensions */
    let rows = 8
    let columns = 10
    
    /* Individual cell dimension, calculated in setup*/
    var cellWidth = 0
    var cellHeight = 0
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        
        /* There will only be one touch as multi touch is not enabled by default */
        let touch = touches.first!
        let location = touch.location(in: self)
        
        let gridX = Int(location.x) / cellWidth
        let gridY = Int(location.y) / cellHeight
        
        /* Toggle creature visibility */
        let creature = gridArray[gridX][gridY]
        creature.isAlive = !creature.isAlive
    }
    
    /* You are required to implement this for your subclass to work */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        /* Enable own touch implementation for this node */
        isUserInteractionEnabled = true
        
        /* Calculate individual cell dimensions */
        cellWidth = Int(size.width) / columns
        cellHeight = Int(size.height) / rows
        populateGrid()
        
    }
    func addCreatureAtGrid(x : Int , y : Int){
        let creature = Creature()
        
        let gridPosition = CGPoint(x: x*cellWidth, y: y*cellWidth)
        creature.position = gridPosition
        
        creature.isAlive = false
        
        addChild(creature)
        
        gridArray[x].append(creature)
        
    }
    func populateGrid(){
        
        for gridX in 0..<columns{
            
            gridArray.append([])
            
            for gridY in 0..<rows {
                
                addCreatureAtGrid(x: gridX, y: gridY)
            }
        }
    }
    func countNeighbor(){
        
        for gridX in 0..<columns {
            
            for gridY in 0..<rows {
                let currentCreature = gridArray[gridX][gridY]
                
                currentCreature.neighborCount = 0
                
                for innerGridX in (gridX - 1)...(gridX + 1 ){
                    if innerGridX < 0 || innerGridX >= columns{continue}
                    for innerGridY in (gridY - 1)...( gridY + 1 ) {
                        /* Ensure inner grid row is inside array */
                        if innerGridY<0 || innerGridY >= rows { continue }
                        
                        /* Creature can't count itself as a neighbor */
                        if innerGridX == gridX && innerGridY == gridY { continue }
                        
                        let adjacentCreature:Creature = gridArray[innerGridX][innerGridY]
                        
                        /* Only interested in living creatures */
                        if adjacentCreature.isAlive {
                            currentCreature.neighborCount += 1
                        }
                    }
                    
                }
            }
        }
    }
    func updateCreatures() {
        /* Process array and update creature status */
        
        /* Reset population counter */
        population = 0
        
        /* Loop through columns */
        for gridX in 0..<columns {
            
            /* Loop through rows */
            for gridY in 0..<rows {
                
                /* Grab creature at grid position */
                let currentCreature = gridArray[gridX][gridY]
                
                /* Check against game of life rules */
                switch currentCreature.neighborCount {
                case 3:
                    currentCreature.isAlive = true
                    break;
                case 0...1, 4...8:
                    currentCreature.isAlive = false
                    break;
                default:
                    break;
                }
                
                /* Refresh population count */
                if currentCreature.isAlive { population += 1 }
            }
        }
    }
    func evolve(){
        
        countNeighbor()
        
        updateCreatures()
        
        generation += 1
    }
}
