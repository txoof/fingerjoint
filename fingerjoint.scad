/*
Finger joint library for creating fingered joints between faces

*/

xDim = 168;
yDim = 207;
zDim = 77;

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
      // add finger joints that fall completely within edge at +/- Y edge 
    for (i=[-1,1]) {
      translate([0, i*yDim/2+i*-material/2])
        insideCuts(length = xDim, center = true, material = material);
    }

    // add finger joints that fall completely within edge at +/- X edge 
    for (i=[-1,1]) {
      translate([i*zDim/2+i*-material/2, 0])
        rotate([0, 0, 90])
        insideCuts(length = yDim, center = true, material = material);
    }}
}

2Dlayout();

module 2Dlayout() {
  //bottom of box (-XY face)
  translate()
    faceXY();
  
  //right isde of box (+YZ face)
  *translate()
    *faceYZ();
}
module outsideCuts(length = 100, finger = 10, material = 5, center = false) {
  //maximum possible divisions for this length
  maxDiv = floor(length/finger);
  //number of usable divisions that fall completely within the edge
  //for this implementation the number of divisions must be odd
  uDiv = maxDiv%2==0 ? maxDiv-3 : maxDiv-2; 
  
  // number of "female cuts"
  numCuts = ceil(uDiv/2);
  
  xTrans = center==false ? (length-(numCuts*2+1)*finger)/2 : -(numCuts*2+1)*finger/2;
  yTrans = center==false ? 0 : -material/2;


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


module outsideCuts() {

}
