/*
Finger joint library for creating fingered joints between faces

*/
/* [Box Dimensions]*/
//X Dimension
xDim = 100;
//Y Dimension
yDim = 100;
//Z Dimension
zDim = 100;
//material thickness
material = 5;
//finger width
finger = 8;

/*[Layout Type]*/
layout = "2D"; //[2D:"2D for SVG output", 3D:"3D for Visualization"]

/*[Features]*/
helpText = true; //[true, false]

/*
#Finger Joint Library
Calculate the appropriate number of finger joints for joining laser cut parts 
given an edge length, material thickness and finger joint length.

###tl;dr usage:
use </path/to/fingerjoint.scad>
insideCuts();
outsideCuts();

###Demo modules:
*Two Dimensional Layout*
- SVG EXPORT:  Render (F6), *File* > *Export* > *Export as SVG*
2DLayout();

*Three Dimensional Layout*
- For visualization only; this will not yield a proper STL for printing
3DLayout();



##module: insideCuts
  ###parameters:
    *length* (real)         length of edge
    *finger* (real)         length of finger
    *material* (real)       thickness of material
    *text* (bool)           add help text to indicate cut type (for debugging)
    *center* (bool)         center the set of fingers with respect to origin
      
##module: outsideCuts
Create a set of finger-joint cuts with an end-cut that takes up extra
  ###parameters:
    *length* (real)         length of edge
    *finger* (real)         length of finger
    *material* (real)       thickness of material
    *text* (bool)           add help text to indicate cut type (for debugging)
    *center* (bool)         center the set of fingers with respect to origin

*/
module insideCuts(length = 100, finger = 8, material = 5, text = true, center = false) {
  // overage to ensure that all cuts are completed 
  o = 0.0001;


  //maximum possible divisions for this length
  maxDiv = floor(length/finger);
  //number of usable divisions that fall completely within the edge
  //for this implementation the number of divisions must be odd
  uDiv = maxDiv%2==0 ? maxDiv-3 : maxDiv-2; 
  
  // number of "female cuts"
  numCuts = ceil(uDiv/2);
 
  //echo("insideCuts\nmaxDiv", maxDiv, "\nuDiv", uDiv, "\nnumCuts", numCuts);

  xTrans = center==false ? 0 : -uDiv*finger/2;
  yTrans = center==false ? 0 : -material/2;
  
  translate([xTrans, yTrans]) {
    for (i=[0:numCuts-1]) {
      translate([i*finger*2, -o/2, 0]) //move the cuts slightly in y plane for complete cuts
        square([finger, material+o]); //add a small amount to ensure complete cuts
    }
  }

  if (text) {
    translate([uDiv*finger/2+xTrans, yTrans+material*2])
    text(text="insideCut", size = material*1.5, halign = "center");
  }

}

module outsideCuts(length = 100, finger = 8, material = 5, text = false, center = false) {
  // overage to ensure that all cuts are completed 
  o = 0.0001;


  //maximum possible divisions for this length
  maxDiv = floor(length/finger);
  //number of usable divisions that fall completely within the edge
  //for this implentation the number of divisions must be odd
  uDiv = maxDiv%2==0 ? maxDiv-3 : maxDiv-2;
  
  // number of "female cuts"
  numCuts = floor(uDiv/2);

  //length of cut at either end
  endCut = (length-uDiv*finger)/2;

  padding = endCut + finger;
  //echo("outsideCuts\nmaxDiv", maxDiv, "\nuDiv", uDiv, "\nnumCuts", numCuts, "\nendCut", endCut);

  xTrans = center==false ? 0 : 
                            -(numCuts*2+1)*finger/2-endCut;
  yTrans = center==false ? 0 : -material/2;

  translate([xTrans, yTrans]) {
    // add the "endcut" for a standard width cut plus any residual
    square([endCut, material]);
    //create the standard fingers
    for (i=[0:numCuts]) {
      if(i < numCuts) {
        translate([i*finger*2+padding, -o/2]) //move the cuts slightly in y plane for overage
          square([finger, material+o]); //add a tiny amount to the material thickness 
      } else { // the last cut needs to be an end cut
        translate([i*finger*2+padding, -o/2])
          square([endCut, material+o]);
      }
    }
  }

  if (text) {
    translate([length/2+xTrans, yTrans+material*2])
    text(text="outsideCut", size = material*1.5, halign = "center");
  }

}
module faceXY(center = false, text = true) {
  //create the YZ face

  //calculate the position of the X and Z displacement 
  xTrans = center==true ? 0 : xDim/2;
  yTrans = center==true ? 0 : yDim/2;

  // calculate the text size and rotation based on the dimensions
  textSize = xDim>=yDim ? xDim*.1 : yDim*.1;
  zRot = xDim>=yDim ? 0 : -90;

  // position the entire piece
  translate([xTrans, yTrans, 0]) {
    color("royalblue")
    // difference the fingers and text from the basic square
    difference() {
      square([xDim, yDim], center = true);

      if (text) {
        rotate([0, 0, zRot])
          text(text = "faceXY", size = textSize, halign = "center", valign = "center");
      }

      for(i=[-1,1]) {
        //+/- X edges fingers
        translate([0, i*yDim/2+i*-material/2, 0])
          outsideCuts(length = xDim, finger = finger, material = material, text = text,
          center = true);
        //+/- Y edges fingers
        translate([i*xDim/2+i*-material/2, 0, 0])
          rotate([0, 0, 90])
          insideCuts(length = yDim, finger = finger, material = material, text = text,
          center = true);
      }

    }
  }
}


module faceYZ(center = false, text = true) {
  //create the YZ face

  //calculate the position of the X and Z displacement 

  yTrans = center==true ? 0 : yDim/2;
  zTrans = center==true ? 0 : zDim/2;

  // calculate the text size and rotation based on the dimensions
  textSize = yDim>=zDim ? yDim*.1 : zDim*.1;
  zRot = yDim>=zDim ? 0 : -90;

 // position the entire piece
 translate([yTrans, zTrans]) {
    color("darkorange")
    difference() {
 
      square([yDim, zDim], center = true);


      if (text) {
        rotate([0, 0, zRot])
          text(text = "faceYZ", size = textSize, halign = "center", valign = "center");
      }

      for(i=[-1,1]) {
        //+/- Y edges
        translate([0, i*zDim/2+i*-material/2])
          outsideCuts(length = yDim, finger = finger, material = material, text = text, 
                      center = true);

        //+/- Z edges
        translate([i*yDim/2+i*-material/2, 0])
          rotate([0, 0, 90])
          outsideCuts(length = zDim, finger = finger, material = material, text = text, 
                      center = true);
      }
    }
  }
}

module faceXZ(center = false, text = true) {
  //create the XZ face

  //calculate the position of the X and Z displacement 
  xTrans = center==true ? 0 : xDim/2;
  zTrans = center==true ? 0 : zDim/2;


  // calculate the text size and rotation based on the dimensions
  textSize = xDim>=zDim ? xDim*.1 : zDim*.1;
  zRot = xDim>=zDim ? 0 : -90;

  // position the entire piece
  translate([xTrans, zTrans]) {
    color("firebrick")
    difference() {
      square([xDim, zDim], center = true);
      
      if (text) {
        rotate([0, 0, zRot])
          text(text = "faceXZ", size = textSize, halign = "center", valign = "center");

      for(i=[-1,1]) {
        //+/- X edges
        translate([0, i*zDim/2+i*-material/2])
          insideCuts(length = xDim, finger = finger, material = material, text = text,
                    center = true);

        translate([i*xDim/2+i*-material/2, 0]) 
          rotate([0, 0, 90])
          insideCuts(length = zDim, finger = finger, material = material, text = text,
                    center = true);
      }

      }
    }
  }
}


module 2Dlayout() {
  //bottom of box (-XY face)
  translate()
    faceXY(center = true, text = helpText);
  
  for (i=[-1,1]) {
    //right and left side of box (+/-YZ face)
    translate([i*(xDim/2+zDim/2+material), 0, 0])
      rotate([0, 0, i*-90])
      faceYZ(center = true, text = helpText);

    //front and back of box (+/-XZ face)
    translate([0, i*(yDim/2+zDim/2+material)])
      rotate()
      faceXZ(center = true, text = helpText);
  }

  //top of box (+XY face)
  translate([0, yDim+zDim+2*material])
    faceXY(center = true, text = helpText);
}

module 3Dlayout(dim = [100, 100, 100]) {
  //bottom of box
  for( i=[-1,1]) {

    //rotatation for faces to make the text readable
    r = i<=0 ? 180 : 0;
    translate([0, 0, i*dim[0]/2+i*-material/2])
      rotate([r, 0, 0])
      color("royalblue")
        linear_extrude(height = material, center = true) {
          faceXY(center = true);
        }
  }

  //front and back of box
  color("firebrick")
    for (i=[-1,1]) {
      //rotatation for faces to make the text readable
      r = i>=0 ? 180 : 0;

      translate([0, i*dim[1]/2+i*-material/2, 0])
        rotate([90, 0, r])
        linear_extrude(height = material, center = true) {
          faceXZ(center = true);
      }
    }


  color("darkorange")
    for(i=[-1,1]) {
      //rotatation for faces to make the text readable
      r = i>=0 ? 180 : 0;
    }
}


//2Dlayout();

3Dlayout();


