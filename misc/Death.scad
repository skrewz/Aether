foreheadWidth = 130;
InterPupiDist = ???;


//TODO make module for the fancy eye shape of the Death mask
//TODO nab Interpupilary...
//TODO design spikes
//Find out how the F to plate this sumbitch




rotate([180,0,0]){
     difference() {
	  scale([1,1,.5]) sphere(r = (foreheadWidth + 10)/2, h = 60, $fn = 60);
	  scale([1,1,.3]) sphere(r = (foreheadWidth + 10)/2, h = 60, $fn = 60);
	 
	  translate([-75,-75,0]) cube([150,150,70]);
     }
}
