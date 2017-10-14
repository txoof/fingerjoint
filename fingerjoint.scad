/*
Finger joint library for creating fingered joints between faces

*/

xDim = 100;
yDim = 100;
zDim = 100;

material = 5;
finger = 8;

module faceXY(center = false) {
  
  xTrans = center==true ? 0 : xDim/2;
  yTrans = center==true ? 0 : yDim/2;


  translate([xTrans, yTrans, 0]) {
    difference() {

      // +/- X Edges
      square([xDim, yDim], center = true);
      for(i=[-1,1]) {
        translate([0, i*yDim/2+i*-material/2, 0])
          #insideCuts(length = xDim, finger = finger, material = material, center = true);
      }

      // +/- Y Edges
      for(i=[-1,1]) {
        translate([i*xDim/2+i*-material/2, 0, 0])
          rotate([0, 0, 90])
          #insideCuts(length = xDim, finger = finger, material = material, center = true);
      }  
    }
  }
}

module faceYZ(center = false) {
  difference() {
  }
}



2Dlayout();

module 2Dlayout() {
  //bottom of box (-XY face)
  translate()
    faceXY(center = true);
  
  //right side of box (+YZ face)
//  translate([xDim/2+zDim/2+material, 0, 0])
//    faceYZ();
}


module insideCuts(length = 100, finger = 8, material = 5, center = false) {
  //maximum possible divisions for this length
  maxDiv = floor(length/finger);
  //number of usable divisions that fall completely within the edge
  //for this implementation the number of divisions must be odd
  uDiv = maxDiv%2==0 ? maxDiv-3 : maxDiv-2; 
  
  // number of "female cuts"
  numCuts = ceil(uDiv/2);
 
  echo("insideCuts\nmaxDiv", maxDiv, "\nuDiv", uDiv, "\nnumCuts", numCuts);

  xTrans = center==false ? 0 : -uDiv*finger/2;
  yTrans = center==false ? 0 : -material/2;
  
  translate([xTrans, yTrans]) {
    for (i=[0:numCuts-1]) {
      translate([i*finger*2, 0, 0])
        square([finger, material]);
    }
  }
}

module outsideCuts(length = 100, finger = 8, material = 5, center = false) {

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
  echo("outsideCuts\nmaxDiv", maxDiv, "\nuDiv", uDiv, "\nnumCuts", numCuts, "\nendCut", endCut);

  xTrans = center==false ? 0 : 
                            -(numCuts*2+1)*finger/2-endCut;
  yTrans = center==false ? 0 : -material/2;

//need 11 cuts




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
