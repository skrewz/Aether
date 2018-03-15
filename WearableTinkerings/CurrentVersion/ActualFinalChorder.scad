switchWidth = 6.0;
switchDistance = 12.9;
switchHeight = 12.9;
switchThickness = 11;

touch_alu_tube_radius=4.0;
touch_alu_tube_radius_cutout=4.2;

touch_steel_nut_width=3.2;
touch_steel_nut_slit_length=9;

m3_radius=1.6;
m3_cap_radius=2.3;
m3_cap_clear_height=1.5;
// the width of a nut, if we're making cutouts for it:
m3_nut_width=5;

// rough (for finger rest frills) radius of your fingers:
finger_girth_radius=15;
rotate_thumb_plate_by = 5;

fingerplate_extra_length=5;
// how much the pinky should be rotated closer:
fingerplate_z_rotation=35;
// how much the fingers should be leaning forward on the plate
fingerplate_x_rotation=-20;
// how much angle the fingertips have compared to the plane of the palm
// you need hardy anything; pinky a bit higher than index, maybe
fingerplate_y_rotation=7;


// how much to lift the angled finger_disk() off the plane:
// (technically could be auto-calculated, but I haven't the breath)
necessary_lift=3;

//oops
$fa=3;

featherHoleRadius = 1;

//below are the variables used to help keep development at least semi-parametric *NOTE that the measurements are specific to my physiology
//distance across the back of the hand *when looking at your hand it goes from left to right/right to left
handWidth = 85;

//this is the distance from the bones of the wrist to below the knuckles * NOTE does not actually start at the wrist bones and instead is on the back of the hand
handHeight = 40;
//this is the height of the hand(from ground to ceiling) when palm down/up
handThickness = 38;

module compass () {
  rotate([0,0,0]) color("red") cylinder (r=0.5,h=50);
  rotate([0,270,0]) color("blue") cylinder (r=0.5,h=50);
  rotate([270,0,0]) color("green") cylinder (r=0.5,h=50);
}

module thumbSockets(){ // {{{
}

module thumbCableExits(){ // {{{
  for (i = [
      [0,0,0,0],
      [switchDistance *1.5, -2,0,-13],
      [-switchDistance *1.5, -2,0,+13],
      [-45,-20,0,57] ])
  
    translate([i[0],i[1],i[2]])
        rotate([0,0,i[3]])
        rotate([90,0,0])
        cylinder(r=2,h=40,$fn=10);
}

//part of my hand loop building process these should scale properly with updated measurements at the top of the program
module connectLoopPos(){ // {{{
  intersection(){
    cube([handWidth, handHeight+4, handThickness+6],true); 
    rotate([90,0,0]){ 
      scale([handWidth/handThickness,1,1.3]){ 
        cylinder(h = handHeight, d = handThickness, center = true, $fn = 60);
      }
    }
  }
} // }}}

//etc
module connectLoopNeg(){
  translate([0, -20, 0]){
    difference(){
      union (){
        translate([-30,-12,-25])
          cube([50,34,20]);
        translate([-59,-22,-8])
          rotate([0,45,0])
              cube([27+2+2,44,20]);

        scale([1.12, 1, 1.2]) connectLoopPos();
      }
      // battery-sized cutout
      translate([-59,-22,-8])
        rotate([0,45,0])
          translate([2,1.01,2])
            // battery needs x=27, y=45, z=10
            cube([27,44+1,10]);
      scale([1,3.1,1]) connectLoopPos();
      translate([7,0.1,-(handThickness/2)]){
        //		    cube([handWidth*.7,56,handThickness], true);

      }
    }
  }
} // }}}

//finger socket modules
module finger_positions(){
  cable_escape_radius = 2;
  for (i = [
      [2                   ,7  ,0,24-fingerplate_z_rotation], // middle
      [switchDistance*1.5  ,-4 ,0,26-fingerplate_z_rotation], // index
      [-switchDistance*1.5 ,2 ,0,22-fingerplate_z_rotation], // ring
      [-46                 ,-25,0,23-fingerplate_z_rotation] // pinky
  ]) {
    translate([i[0],i[1],i[2]])
      rotate([0,0,i[3]])
      {
        // TODO: This is technically wrong: the "cap width" shouldn't drill all
        // the way down to the cable escape
        translate([-touch_steel_nut_width/2,0,-touch_steel_nut_width/2])
        cube([
            touch_steel_nut_width,
            touch_steel_nut_slit_length,
            touch_steel_nut_slit_length*2]);

        translate([0,-0.0*finger_girth_radius,1.3*finger_girth_radius])
        {

          // "bent" (to exploit finger springiness) guide channel:
          rotate([80,0,0])
            translate([0,-0.15*finger_girth_radius,0])
            cylinder(r=finger_girth_radius, h=4*switchHeight);

          translate([0,-finger_girth_radius,0])
            rotate([90,0,0])
            cylinder(r=finger_girth_radius, h=4*switchHeight);

          translate([0,0,-0.15*finger_girth_radius])
            sphere(r=finger_girth_radius);
        }
        // Cable escape:
        rotate([77-fingerplate_x_rotation,0,0])
          translate([0,0,-touch_steel_nut_slit_length])
          cylinder(r=cable_escape_radius,h=80,$fn=20);
      }
  }
  //thumbCableExits();
  //translate([-45,-20, 0]) rotate([0,0,12])
  //{
  //  cube([switchWidth, switchHeight, switchThickness],true);
  //  // cable exit:
  //  //rotate([90,0,45]) cylinder(r=2,h=40,$fn=20);
  //}

    //  translate([0,-4,-10]) #cylinder(r=2,h=40,$fn=20);
    //  rotate([0,0,z_rotation]) rotate([x_rotation,0,0]) rotate([0,y_rotation,0])
    //  translate([0,-4,-10]) #cylinder(r=2,h=40,$fn=20);

} // }}}

module featherFootprint(){ // {{{
  mirror([0,0,1])
    union(){

      scale([1.3,1.3,1]){
        cube([.9*25.4,2*25.4,5],true);
      }

      translate([0,0,2.5]){
        scale([1.2,1.2,1]){
          cube([.9*25.4,2*25.4,5],true);
        }
      }

      translate([-14.5,0,-1]){
        cube([12,15,1.5], true);
      }

      translate([0,-30,-1]){
        cube([12,8,8],true);
      }
      mirror([0,1,0])
        translate([(.46*25.4),25.4-(.42*25.4),-1]){
          cube([17,10,10],true);
        }
    }
  // featherPosts();

  rotate([0,90,0]){
    scale([1,1.95,1]){
      //         cylinder(r = ( 1.3* ((.9*25.4)/2)), h = (1.3*(2*25.4)), center = true);
    }
  }

} // }}}


//this is the module for the receiving body for the switches that the index through pinky fingers rest
module CyberDiskF(){ // {{{
  difference(){
    translate([0,-0.1*handHeight,0])
    scale([1.2,.75,.80])
      sphere(handHeight);
    translate([-70,-50,.80]) cube(135);
    //translate([-70,-50,-148]) cube(135);
  }
} // }}}

module thumb_plate(){ // {{{
  difference(){
    union()
    {
      scale([1,1,1.4])
      {
        translate([-15,-70,10])
          rotate([270,0,0])
          cylinder(h=90,r1=10,r2=20);
        translate([-15,20,10])
          sphere(r=20);
      }
    }
    //cube([30,70,20]);
    //scale([1.5,1.3,1])
    //  cylinder(h=1.5*switchHeight,d=48);
    // bottom cut-out:
    //translate([-50,-106,-50]) cube([100,100,100]);

    //this is the "footprint" of where the thumb switches will reside.
    translate ([-15,8,10])
    {
      // Finger hole:
      translate([0,0.5*finger_girth_radius,1.5*finger_girth_radius])
      {
        rotate([90,0,0])
          cylinder(r1=finger_girth_radius, r2=1.2*finger_girth_radius, h=60);
        sphere(r=finger_girth_radius);
      }
      cable_escape_radius = 2;
      for (i = [
          //[ 35,9,-15,-20,0],
          // as looking down on your nail:
          // [rotation ccw, lift, axial rotation of nut, push away from nail,nut rotation from viewpoint ]
          [-35,10,20,-27,-30],
          [ 35,10,20,-25,30],
          [  0,-3,0,-15,0]])
      {
        rotate([0,0,i[0]])
          translate([0,0,20/2])
          {
            // basic cable escape holes:
            translate([0,15,i[1]])
              rotate([180+70,0,-i[0]])
              cylinder(r=cable_escape_radius, h=5*touch_steel_nut_slit_length,$fn=15);
            //translate([0,0,-cable_escape_radius])
            //  cylinder(r=touch_alu_tube_radius_cutout, h=switchHeight,$fn=25);
            translate([-touch_steel_nut_width/2,0,-5+i[1]])
              rotate([90,0,0])
              translate([0,0,i[3]])
              rotate([i[2],i[4],0])
              cube([
                  touch_steel_nut_width,
                  touch_steel_nut_slit_length,
                  touch_steel_nut_slit_length]);
          }
      }
    }
    // bottom cut-out
    translate([-100,-100,-20])  cube([200,200,20]);
    // rotate the screwholes and glove() cut-out (thumb faces away from palm):
    rotate([0,0,rotate_thumb_plate_by])
    {
      // left cut-out (to ensure glove() fits):
      translate([-70,-50,-20])  cube([50,38,60]);
      // the chamfer towards the palm side:
      translate([-40,-57,0])
        rotate([0,90,0])
        rotate([0,0,30])
        translate([-35,-100,-100])
        cube([40,200,200]);

      // the screw holes to mount it onto the glove:
      translate([-15,0,0])
        for(i = [[0,-20,0],[0,-40,0]])
          translate(i)
          {
            translate([0,0,-1]) cylinder(r=1.7,h=4*switchHeight,$fn=20);
            // countersink for screws:
            translate([0,0,1]) cylinder(r=3,h=switchHeight,$fn=20);
          }
    }
  }
} // }}}
//another module  this one is the *complete loop module that describes all of the intricacies.
//lots of holes punched into the design for a future cover mechanism I plan to develop *will be held to the main body with mechanical-elastic force
module connectLoopThumb(){ // {{{
  difference(){
    // The main body of the handle:
    connectLoopNeg();
    //orig:
    // translate([47,-28,-6]) rotate([90,0,-45]) cylinder(h = 70, d = 32, center = true, $fn=20);
    translate([27,-23,-4]) rotate([90,0,-75]) cylinder(h = 70, d = 20, center = true, $fn=20);

    translate([47,-28,-6]) rotate([90,0,-45]) cylinder(h = 200, d = 32, center = true, $fn=20);
    translate([47,-26,-13]) rotate([90,0,-45]) cylinder(h = 200, d = 32, center = true, $fn=20);
    translate([40,-25,-30]) rotate([90,0,-70]) cube([10,20,70]);


    // four through-holes through the handle:
    //translate([-40,-4,0]) cylinder(h=200,d=4,center = true, $fn=20);
    //mirror(0,1,0) translate([-40,-4,0]) cylinder(h=200,d=4,center = true);    
    //mirror(0,1,0) translate([-38,-38,0]) cylinder(h=200,d=4,center = true);
    //translate([-40,-38,0]) cylinder(h=200,d=4,center = true);

    // the Feather's position
    //mirror([0,0,0]) translate([-15,-20,24]) rotate([10,0,-90]) featherFootprint();

    //Core of the radial mount
    //#translate([28,-14,-20]) rotate([-102,20,0]) cylinder(h=80,d=4);
  }
} // }}}



//two separate "mounting brackets" these essentially provide the support structure necessary for a 2part design
module BraceMounts(){ // {{{

  //Ulnal Side differences
  difference(){
    translate([-46,-39,0]) rotate([-115,0,0]) scale([1,1.5,1]) cylinder(h=89,d=8,$fn=10);
    translate([-46,-44,0]) rotate([-115,0,0]) cylinder(h=100,d=4);
    // translate ([-55,10,-50]) rotate([0,0,11]) cube([150,100,100]);

    //radial side
    //translate([28,-14,-20]) rotate([-102,20,0]) cylinder(h=80,d=8);
  }


  //Everything below this is what is being actively rendered by the openSCAD program

  // end of above difference
  translate([-13,-22,16]){
    rotate([-194,0,90]){
      translate([(0.45*25.4),-(0.9*25.4),-4]){cylinder(h = 8 ,r = featherHoleRadius, center = true,$fn = 20);}
      //bottom left
      translate([-(0.25*25.4),-(0.9*25.4),-4]){cylinder(h = 8 ,r = featherHoleRadius, center = true,$fn = 20);}
      //top right
      translate([(0.45*25.4),(0.9*25.4),0]){cylinder(h = 6 ,r = featherHoleRadius, center = true,$fn = 20);}
      //top left
      translate([-(0.25*25.4),(0.9*25.4),0]){cylinder(h = 6 ,r = featherHoleRadius, center = true,$fn = 20);}
    }
  }


} // }}}

//CYBERDISK F DIFF

module finger_disk()
{ // {{{

translate([0,-40,-0.75])
  rotate([45,12,fingerplate_z_rotation-(45+11)])
    difference(){
      translate([-3,40, -21])  rotate([-46,-6,11]) CyberDiskF();
      translate([14,43,-25.5])  rotate([-45,-14,3]) finger_positions();
      //cascade transformations are translate(0,5,-10) rotate(0,0,8)

      //translate([12,10,-20]) rotate([-46,-10,11])  scale([3.5,1.5,.75]) translate ([0,0,-handHeight]) cylinder(h = 2*handHeight, d =20, $fn=40 );

      //translate([35,22,-12]) rotate([90,90,30]) cylinder(h=20,d=5,center=true, $fn=20);
      // through-going wire hole
      //translate([-35,30,-25]) rotate([0,90,10]) cylinder(h=70, d=5, $fn=20);

      //Core excavation for the ulnal side bracemount
      //translate([-46,-42,0]) rotate([-115,0,0]) cylinder(h=92,d=4, $fn=20);
      //translate([48,-9,0]) rotate([-110,20,0])  cylinder(h=62,d=4, $fn=20);
      //translate([20,-12,22]) rotate([-180,-65,55])  cylinder(h=60,d=4, $fn=20);
      //Core of the radial mount
      //translate([28,-14,-20]) rotate([-102,20,0]) cylinder(h=80,d=4, $fn=20);
//translate([8,28,-30]) rotate([-70,20,0]) cylinder(h=30,d=4, $fn=20);
      //translate ([-55,10,-50]) rotate([0,0,11]) cube([150,100,100]);
      //translate ([-55,-92,-50]) rotate([0,0,11]) cube([150,100,100]);

    }
} // }}}

module finger_plate(x_rotation,y_rotation,z_rotation,plate_lift,fingerplate_extra_length)
{ // {{{
  // TODO: make cable canal up top.
  // TODO: make feather cutout up top (half indentation, bulky with cable
  //       headers).
  offset = fingerplate_extra_length;

  // Add a switch container (sort of after everything).
  translate([12,-42-offset,0])
  {
    difference()
    {
      cube([18,25,15]);
      translate([3,2,0])
        cube([13,19,15+0.01]);
      translate([8,5,5])
        rotate([90,0,0])
        cylinder(r=3,h=10,$fs=1);
    }
  }
  difference() {
    union(){
      {
      translate([0,0,plate_lift])
        rotate([0,0,z_rotation]) rotate([x_rotation,0,0]) rotate([0,y_rotation,0])
          finger_disk();
      }

      difference()
      {
        union() {
          rotate([0,0,z_rotation])
            translate([-20,-30,0])
              translate([25,25,0]) cylinder(r=25,h=switchHeight);
          translate([-18,-47-50-offset,0])
          {
            cube([50,95+offset,switchHeight]);

            /*
            translate([0,0,switchHeight/2])
            minkowski()
            {
            cube([50,95+offset,switchHeight/2]);
            sphere(r=switchHeight/4);
            }
            */
          }
        }

        // cut-off for this shape and the finger_disk() (0.01 added)
        translate([0,0,plate_lift])
          rotate([0,0,z_rotation]) rotate([x_rotation,0,0]) rotate([0,y_rotation,0])
          translate([-100,-100,0.01])
          cube([200,200,30]);


        // holes for mounting to glove()
        translate([-7,-80-offset,0])
        for (i = [ [-5,0,0], [20,0,0]])
          translate(i)
            translate([0,0,-1.1*switchHeight])
            {
              cylinder(r=1.7,h=3*switchHeight,$fn=20);
              //translate([0,0,5]) cylinder(r=5.5/2*1.3/*engorgement factor*/,h=switchHeight,$fn=6);
              translate([0,0,5]) cylinder(r=4,h=switchHeight,$fn=20);
              //cylinder(r=2,h=3*switchHeight,$fn=20);
            }
        translate([0,-70-offset,0.5*switchHeight])
          for(i = [[0,0,0],[0,-20,0]])
            rotate([0,90,0])
              translate(i)
              {
                cylinder(r=1.8,h=4*switchHeight,$fn=20);
                translate ([-26,-5,5]) cube([30,10,20]);
              }
      }
    }
    // cut-out for the Feather to fit into
    translate([-15,-80,2])
      cube([45,58,switchHeight-2+0.01]);
    translate([-7,-120,0.3*switchHeight])
      cube([10,55,20]);
    // battery cable hole
    translate([-20,-65,7])
      rotate([90,0,90])
      cylinder(r=3,h=10,$fs=1);
    // cable wiring hole:
    //translate([0,0,0])
    //  rotate([0,0,z_rotation]) rotate([x_rotation,0,0]) rotate([0,y_rotation,0])
    //  translate([0,-4,-10]) #cylinder(r=2,h=40,$fn=20);

    // cut off anythnig below floor level
    translate([-100,-100,-20+0.01])
      cube ([200,200,20]);
  }
} // }}}

module glove()
{ // {{{

  difference(){
    connectLoopThumb();
    //!CyberDiskF();
    //	    translate ([-55,10,-50]) rotate([0,0,11]) cube([150,100,100]);
    //translate ([-55,10,-50]) cube([150,100,100]);
    //Core excavation for the ulnal side bracemount
    //translate([-46,-44,0]) rotate([-115,0,0]) cylinder(h=94,d=4);
    //	      	    translate ([-55,10,-50]) rotate([0,0,11]) cube([150,100,100]);
    //translate ([-55,-92,-50]) rotate([0,0,11]) cube([150,100,100]);

    // screw holes for mounting finger_plate():
    // pretty hacked up placement. Add a # and try to make it work, I guess.
    translate([-0.224*handWidth,-15,-handHeight])
      for (i = [ [-5,0,0], [20,0,0]])
        translate(i)
        {
          cylinder(r=1.7,h=3*switchHeight,$fn=20);
          //translate([0,0,17]) cylinder(r=4,h=switchHeight,$fn=20);
          translate([0,0,17]) cylinder(r=5.5/2*1.3/*engorgement factor*/,h=switchHeight,$fn=6);
        }

    gnd_connector_radius = 2.5;
    // GND connector to flesh:
    translate([handWidth/2-10,-5,0])
      rotate([0,45+90,0])
    {
      cylinder(r=1.7,h=3*switchHeight,$fn=20);
      translate([0,0,-1])
        cylinder(r=touch_alu_tube_radius_cutout,h=switchHeight,$fn=20);
    }
    // cut out for Feather
    translate([-27,-10,-30])
    cube([40,20,20]);
  }
} // }}}


module whole_thing()
{
// skrewz@20161214: this expresses the connector piece under the index finger.
/*
difference(){

  // skrewz@20161214: The bottommost connector piece:
  translate([28,-14,-20]) rotate([-104,20,0]) scale([1,1.5,1]) cylinder(h=75,d=8,$fn=40);
  //Core of the radial mount
  translate([28,-14,-20]) rotate([-102,20,0]) cylinder(h=80,d=4);
  // skrewz@20161214: cuts out the thumb sockets from the connector piece:
  translate([44,10,-15]) rotate([0,125,0]) thumbSockets();
  translate([14,43,-25.5])  rotate([-45,-14,3]) finger_positions();
  //translate ([-55,10,-50]) rotate([0,0,11]) cube([150,100,100]);
}
*/


//extra_length=0;
//translate([-12,65+extra_length,-38])
//  finger_plate(fingerplate_x_rotation,fingerplate_y_rotation,fingerplate_z_rotation,necessary_lift,extra_length);

extra_length=5;
translate([-12,65+extra_length,-38])
  finger_plate(fingerplate_x_rotation,fingerplate_y_rotation,45,necessary_lift,extra_length);


translate([20,15,-46])
  rotate([0,90,0])
  rotate([0,0,-rotate_thumb_plate_by])
  thumb_plate();

glove();

//difference(){
/*color("red")
BraceMounts();
*/
//	    translate ([-55,10,-50]) rotate([0,0,11]) cube([150,100,100]);
//translate ([-55,10,-50]) cube([150,100,100]);
//translate ([-55,-92,-50]) rotate([0,0,11]) cube([150,100,100]);

//}

//hint* you totally have to go into each module above and make sure to uncomment/add the proper differences as posted below
//uncomment to remove the farthest piece
//	    translate ([-55,10,-50]) rotate([0,0,11]) cube([150,100,100]);

//uncomment to remove the base pieces
//translate ([-55,-92,-50]) rotate([0,0,11]) cube([150,100,100]);


/*
color("cyan")
difference(){
  translate([44,23,-12]) rotate([-105,0,9]) difference(){
    cylinder(h=16, d=10,$fn=40);
    cylinder(h=18,d=5);

  }
  translate([14,43,-25.5])  rotate([-45,-14,3]) finger_positions();
  //			    //translate ([-55,10,-50]) rotate([0,0,11]) cube([150,100,100]);
  //translate ([-55,-92,-50]) rotate([0,0,11]) cube([150,100,100]);
}
*/
}

//render_part="glove";
//render_part="finger_plate";
//render_part="thumb_plate";
render_part="whole_thing";


//translate ([-55,7,42]) rotate([90,0,-13])
{
  if ("whole_thing" == render_part)
  {
    //translate ([-55,7,42]) rotate([90,0,-13])
    whole_thing();
  }
  if ("glove" == render_part)
  {
    translate([0,0,2])
      rotate([270,0,0])
        glove();
  }
  if ("finger_plate" == render_part)
  {
      finger_plate(fingerplate_x_rotation,fingerplate_y_rotation,fingerplate_z_rotation,necessary_lift,fingerplate_extra_length);
  }
  if ("thumb_plate" == render_part)
  {
      thumb_plate();
  }
}


