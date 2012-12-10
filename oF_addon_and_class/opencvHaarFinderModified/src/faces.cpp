//
//  faces.cpp
//  opencvHaarFinderModified
//
//  Created by Jennifer Presto on 12/9/12.
//
//

#include "faces.h"


faces::faces() {
    pos.x = ofGetWidth() * 0.5;
    pos.y = ofGetHeight() * 0.5;
    radius = 30;
}

//--------------------------------------------------------------

//void faces::update(){
//    pos.x = facePos.x;
//    pos.y = facePos.y;
//}

//--------------------------------------------------------------

void faces::draw(){
    if (happy==TRUE) {
     happyFace.draw(pos, w, h);
    } else
    if (happy==FALSE){
        sadFace.draw(pos, w, h);
    }
}