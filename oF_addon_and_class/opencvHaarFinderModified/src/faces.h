//
//  faces.h
//  opencvHaarFinderModified
//
//  Created by Jennifer Presto on 12/9/12.
//
//

#ifndef __opencvHaarFinderModified__faces__
#define __opencvHaarFinderModified__faces__

#include <iostream>
#include "ofMain.h"

class faces {
public:
    faces();
    void draw();
    
    ofPoint pos;
    float w;
    float h;
    float radius;
    
    ofImage happyFace;
    ofImage sadFace;
    
    bool happy;

};

#endif /* defined(__opencvHaarFinderModified__faces__) */

