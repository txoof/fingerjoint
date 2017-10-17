/*
Finger joint library for creating fingered joints between faces

*/
/* [Box Dimensions]*/
//X Dimension
xDim = 400;
//Y Dimension
yDim = 150;
//Z Dimension
zDim = 130;
//material thickness
material = 5;
//finger width
finger = 8;

/*[Features]*/
helpText = true; //[true, false]

module faceXY(center = false, text = true) {
  
  xTrans = center==true ? 0 : xDim/2;
  yTrans = center==true ? 0 : yDim/2;

  textSize = xDim>=yDim ? xDim*.1 : yDim*.1;
  zRot = xDim>=yDim ? 0 : -90;

  echo(textSize);

  translate([xTrans, yTrans, 0]) {
    difference() {
      square([xDim, yDim], center = true);

      if (text) {
        rotate([0, 0, zRot])
          text(text = "faceXY", size = textSize, halign = "center", valign = "center");
      }

      for(i=[-1,1]) {
        //+/- X edges 
        translate([0, i*yDim/2+i*-material/2, 0])
          outsideCuts(length = xDim, finger = finger, material = material, text = text,
          center = true);
        //+/- Y edges
        translate([i*xDim/2+i*-material/2, 0, 0])
          rotate([0, 0, 90])
          insideCuts(length = yDim, finger = finger, material = material, text = text,
          center = true);
      }

    }
  }
}


module faceYZ(center = false, text = true) {

  yTrans = center==true ? 0 : yDim/2;
  zTrans = center==true ? 0 : zDim/2;

  textSize = yDim>=zDim ? yDim*.1 : zDim*.1;
  zRot = yDim>=zDim ? 0 : -90;

  translate([yTrans, zTrans]) {
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
  
  xTrans = center==true ? 0 : xDim/2;
  zTrans = center==true ? 0 : zDim/2;

  textSize = xDim>=zDim ? xDim*.1 : zDim*.1;
  zRot = xDim>=zDim ? 0 : -90;

  translate([xTrans, zTrans]) {
    difference() {
      square([xDim, zDim], center = true);
      
      if (text) {
        rotate([0, 0, zRot])
          text(text = "faceXZ", size = textSize, halign = "center", valign = "center");

      }
    }
  }
}


2Dlayout();

module 2Dlayout() {
  //bottom of box (-XY face)
  translate()
    faceXY(center = true, text = helpText);
  
  //right side of box (+YZ face)
  translate([xDim/2+zDim/2+material, 0, 0])
    rotate([0, 0, -90])
    faceYZ(center = true, text = helpText);
}


module insideCuts(length = 100, finger = 8, material = 5, text = true, center = false) {
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
      translate([i*finger*2, 0, 0])
        square([finger, material]);
    }
  }

  if (text) {
    translate([uDiv*finger/2+xTrans, yTrans+material*2])
    text(text="insideCut", size = material*1.5, halign = "center");
  }

}

module outsideCuts(length = 100, finger = 8, material = 5, text = false, center = false) {

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
        translate([i*finger*2+padding, 0, 0]) 
          square([finger, material]);
      } else { // the last cut needs to be an end cut
        translate([i*finger*2+padding, 0])
          square([endCut, material]);
      }
    }
  }

  if (text) {
    translate([length/2+xTrans, yTrans+material*2])
    text(text="outsideCut", size = material*1.5, halign = "center");
  }

}
