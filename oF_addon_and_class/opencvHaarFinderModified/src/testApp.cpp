/*
 
 Modified OpenCV Haar Finder
 Jennifer Presto
 December 9, 2012
 
 CCLab Assignment:
 Use an addon and a class
 
 Modified from openFrameworks OpenCV Haar Finder example,
 incorporating code from openFrameworks VideoGrabber example.
 
 Happy and Sad faces designed by Tobias F. Wolf from
 The Noun Project.
 
 */

#include "testApp.h"

//--------------------------------------------------------------
void testApp::setup(){

	finder.setup("haarcascade_frontalface_default.xml");
	finder.findHaarObjects(img);
    ofSetVerticalSync(TRUE);
    ofSetFrameRate(30);
    ofEnableAlphaBlending();
    ofEnableSmoothing();
    
    camWidth = 640;
    camHeight = 480;
    vidGrabber.setVerbose(true);
	vidGrabber.initGrabber(camWidth,camHeight);
    
    facePos.x = ofGetWidth() * 0.5;
    facePos.y = ofGetHeight() * 0.5;
    
    face.happy = TRUE;
    face.happyFace.loadImage("happy_face.png");
    face.sadFace.loadImage("sad_face.png");
    
    instructions.loadImage("instructions.png");

}

//--------------------------------------------------------------
void testApp::update(){
    ofBackground(0, 0, 0);
    vidGrabber.update();
	videoTexture.allocate(camWidth,camHeight, GL_RGB);
    if(vidGrabber.isFrameNew()){
        img.setFromPixels(vidGrabber.getPixelsRef());
        finder.findHaarObjects(img);
        facePos = finder.blobs[0].boundingRect;
    }
    face.pos.x = facePos.x;
    face.pos.y = facePos.y;
    face.w = facePos.width;
    face.h = facePos.height;
}

//--------------------------------------------------------------
void testApp::draw(){
    vidGrabber.draw(0,0);
 	ofNoFill();
	for(int i = 0; i < finder.blobs.size(); i++) {
		ofRectangle cur = finder.blobs[i].boundingRect;
//		ofRect(cur.x, cur.y, cur.width, cur.height);
	}
    face.draw();
//    cout << face.happy; // testing boolean to see if working
    
    ofSetColor(255);
    instructions.draw(10, 20);

}

//--------------------------------------------------------------
void testApp::keyPressed(int key){
    if (key == 'h'){
        face.happy = TRUE;
    }
    if (key == 's'){
        face.happy = FALSE;
    }

}

//--------------------------------------------------------------
void testApp::keyReleased(int key){

}

//--------------------------------------------------------------
void testApp::mouseMoved(int x, int y ){

}

//--------------------------------------------------------------
void testApp::mouseDragged(int x, int y, int button){

}

//--------------------------------------------------------------
void testApp::mousePressed(int x, int y, int button){
    
    //    not able to get the boolean to switch on mousePressed
    //    tried it a couple of ways:
    
    //    if(face.happy == TRUE) {
    //        face.happy = false;
    //    }
    //    if(face.happy == FALSE){
    //        face.happy = true;
    //    }
    
    //    face.happy != face.happy;

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