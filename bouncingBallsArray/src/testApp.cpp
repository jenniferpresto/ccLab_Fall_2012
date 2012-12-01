/*
 An Array of Bouncing Balls
 Jennifer Presto
 December 1, 2012
 
 Balls that bounce off the wall and each other;
 Color changes on key press.
 
 */

#include "testApp.h"

//--------------------------------------------------------------
void testApp::setup(){
    // set window title
    ofSetWindowTitle("Bouncing Balls - Hooray!");
    
    // smooth edges
    ofEnableSmoothing();
    
    // set framerate
    ofSetFrameRate(30);
    
    // starting color is orange (cannot return to this color)
    colorScheme = 25;
    
    // first position of balls
    // start evenly distributed, diagonally down to the right
    for(int i = 0; i<NUMCIRCLES; i++)
    {
        circleX[i] = ofGetWindowWidth()*0.15 * (i+1);
        circleY[i] = ofGetWindowHeight()*0.15 * (i+1);
        velX[i] = int(ofRandom(1, 4));
        velY[i] = int(ofRandom(1, 4));
    }
    
}

//--------------------------------------------------------------
void testApp::update(){

    // collision detection: circle vs. circle
    for (int j = 0; j < NUMCIRCLES; j++){
        for (int k = j+1; k < NUMCIRCLES; k++){
            if (ofDist(circleX[j], circleY[j], circleX[k], circleY[k]) < 65){
                // if the circles hit going opposite directions,
                // both circles will reverse direction
                // (calculated separately for both x and y movement)
                if((velX[j] > 0 && velX[k] < 0) || (velX[j] < 0 && velX[k] > 0)){
                    velX[j] *= -1;
                    velX[k] *= -1;
                }
                if((velY[j] > 0 && velY[k] < 0) || (velY[j] < 0 && velY[k] > 0)){
                    velY[j] *= -1;
                    velY[k] *= -1;
                }
            }
        }
    }
    
    for (int i = 0; i < NUMCIRCLES; i++){

        // collision detection: circle vs. wall
        if (circleX[i] < 30 || circleX[i] > ofGetWindowWidth()-30){
            velX[i] *= -1;
        }
        if (circleY[i] < 30 || circleY[i] > ofGetWindowHeight()-30){
            velY[i] *= -1;
        }
        
        // update location of each circle
        circleX[i] += velX[i];
        circleY[i] += velY[i];
    }
}

//--------------------------------------------------------------
void testApp::draw(){
    ofBackgroundGradient(ofColor::gray,ofColor(30, 10, 30), OF_GRADIENT_CIRCULAR);
    for(int i = 0; i<NUMCIRCLES; i++)
    {
        c = ofColor::fromHsb(colorScheme, 255, (255/NUMCIRCLES+1) * (i+1));
        ofSetColor(c);
        ofFill();
        ofCircle(circleX[i], circleY[i], 35);
    }
    ofSetColor(255);
    ofDrawBitmapString("Press the r, y, g, or b keys to change color", 10, 20);
}

//--------------------------------------------------------------
void testApp::keyPressed(int key){
    if (key == 'r' || key == 'R'){
        colorScheme = 0;
    }
    if (key == 'y' || key == 'Y'){
        colorScheme = 40;
    }
    if (key == 'g' || key == 'G'){
        colorScheme = 85;
    }
    if (key == 'b' || key == 'B'){
        colorScheme = 170;
    }
}

//--------------------------------------------------------------
void testApp::keyReleased(int key){
    
}

//--------------------------------------------------------------
void testApp::mouseMoved(int x, int y){
    
}

//--------------------------------------------------------------
void testApp::mouseDragged(int x, int y, int button){
    
}

//--------------------------------------------------------------
void testApp::mousePressed(int x, int y, int button){
    
}

//--------------------------------------------------------------
void testApp::mouseReleased(int x, int y, int button){
    
}

//--------------------------------------------------------------
void testApp::windowResized(int w, int h){
    
}

//--------------------------------------------------------------
void testApp::gotMessage(ofMessage msg){
    
}

//--------------------------------------------------------------
void testApp::dragEvent(ofDragInfo dragInfo){
    
}