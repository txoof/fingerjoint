/*
Finger joint library for creating fingered joints between faces

*/

xDim = 168;
yDim = 207;
zDim = 309;

material = 5;

module faceXY() {
  difference() {
    square([xDim, yDim], center = true);
    // add finger joints that fall completely within edge at +/- Y edge 
    for (i=[-1,1]) {
      translate([0, i*yDim/2+i*-material/2])
        insideCuts(length = xDim, center = true, material = material);
    }

    // add finger joints that fall completely within edge at +/- X edge 
    for (i=[-1,1]) {
      translate([i*xDim/2+i*-material/2, 0])
        rotate([0, 0, 90])
        insideCuts(length = yDim, center = true, material = material);
    }
    
  }
}

module faceYZ() {
  difference() {
    square([zDim, yDim], center = true);

    for (i=[-1,1]) {
      translate([0, i*yDim/2-i*material/2])
        insideCuts(length = zDim, center = true, material = material);
    }

    for (i=[-1,1]) {
      translate([i*zDim/2-i*material/2, 0, 0])
        rotate([0, 0, 90])
        #outsideCuts(length = yDim, center = true, material = material);
    }

  }
}


2Dlayout();

module 2Dlayout() {
  //bottom of box (-XY face)
  translate()
    faceXY();
  
  //right side of box (+YZ face)
  translate([xDim/2+zDim/2+material, 0, 0])
    faceYZ();
}


module insideCuts(length = 100, finger = 10, material = 5, center = false) {
  //maximum possible divisions for this length
  maxDiv = floor(length/finger);
  //number of usable divisions that fall completely within the edge
  //for this implementation the number of divisions must be odd
  uDiv = maxDiv%2==0 ? maxDiv-3 : maxDiv-2; 
  
  // number of "female cuts"
  numCuts = ceil(uDiv/2);
  
  xTrans = center==false ? (length-(numCuts*2+1)*finger)/2 : -(numCuts*2+1)*finger/2;
  yTrans = center==false ? 0 : -material/2;
  
  translate([xTrans, yTrans]) {
    for (i=[0:numCuts]) {
      translate([i*finger*2, 0, 0])
        square([finger, material]);
    }
  }
}


module outsideCuts(length = 100, finger = 10, material = 5, center = false) {

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

  xTrans = center==false ? (length-(numCuts*2+1)*finger)/2 : 
                            -(numCuts*2+1)*finger/2-endCut;
  yTrans = center==false ? 0 : -material/2;



  translate([xTrans, yTrans]) {
    square([endCut, material]);
    for (i=[0:numCuts]) {
      if(i < numCuts) {
        translate([i*finger*2+padding, 0, 0]) 
          square([finger, material]);
      } else {
        translate([i*finger*2+padding, 0])
          square([endCut, material]);
      }
    }
  }

}
