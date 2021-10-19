
outerX = 490; // Front edge of box.  
outerZ=490;
outerY=460 ; 


// plunge depth from outside of bar to bottom (how much glass needs to fill)
true_plunge = 6.1;
plunge = 4.5; // 3mm slack? 


innerX= outerX-(20*2)+(plunge*2); // was 454;
innerZ=innerX;

m3=3.1/2;
m5=5.125/2;



// Top
// top has no butted corners. 
TopX=450+ (2* plunge);
TopY=419+ 2*plunge;

// front inner (which we won't use). 

// has 4 butted corners
FrontZ=449+2*plunge;
FrontX=FrontZ;

// Left - no butted corners
SideZ=449+2*plunge;
SideY=419+2*plunge;

// Back  - 4 butted corners, same as front. 


module bigpane(){

	difference() {
		translate([outerX/2,outerZ/2])
			square([outerX-4,outerZ-4],center=true);

		// vertical holes
		L=50; 
		Rv=outerZ-50;
		for (x=[10,outerX-10]) {
			// corners

			for (z=[L,outerZ/2,Rv]) {
				translate([x,z])
					circle(r=m3);
			}

		}


	// Horizontal Holes

		for (x=[50,outerX/2,outerX-50]) {
			for (z=[10,outerZ-10]) {
				translate([x,z])
					circle(r=m3);
			}
		}
	}
}



module sidepane(){

		difference() {
	
			translate([outerY/2,outerZ/2])
				square ([outerY-4,outerZ-4],center=true); // shrink so that we can be sloppy with front & back panel overlap. 

			//  vertical mounting slots
			for (x=[10,outerY-10]) {
					for (z=[50,outerZ/2,outerZ-50]) {
						translate([x, z]) {
								circle(r=m3,$fn=20);
						}
						
					}
			}



			// horizontal mounting holes
				for (z=[10,outerZ-10]) {
					// edges
					for (y=[50,outerY/2,outerY-50]) {
							translate([y, z]) {


							hull(){
								translate([0,-m3]) 
									circle(r=m3,$fn=20);
								translate([0,m3]) 
									circle(r=m3);												
							}

								circle(r=m3);
							}
					}
				}





		if (0) {
		//  bumps seemed like good idea, but not much help in practice. 
			// vertical bumps
			for (x=[0,innerX]) {
				// edges
				for (z=[1:5]) {
						translate([x, z* innerZ/6])
							circle(r=1,$fn=20);
					}
			}


		// Horizontal Holes\
			for (y=[0,innerZ]) {
					// edges
				for (x=[1:3]) {
						translate([ x * innerZ/4,y])
							circle(r=1,$fn=20);
					}
			}
		}

		
	}

}


module 3induct (){

	// duct vent
		translate([outerX-20-95/2,outerZ-20-95/2]) {
			*square([93,93],center=true);
			circle(r=70/2);
			for(x=[10,82]){
				for(y=[10,82]) {
					translate([x-93/2,y-93/2])
						circle(r=m5);
				}

			}
		}


}

module top() { 

	difference (){
		bigpane();
		translate([outerX/2,outerZ/2+15])
			rotate(45) {
				for(x=[-210,0,210]) {
					for(y=[-15,15]) {
						translate([x,y])
									square([5.5,2],center=true);
					}
				}
				//Blazecut T150
				*square([530,25],center=true);
			}
		// smoke alarm
		Rad=20+76; // distance from edge to center
		translate([Rad,outerZ-Rad]) {
			circle(r=11); // should be a square, but then can't rotate in. 
//			circle(r=76);
				translate([0,29])
					circle(r=m5);

				translate([0,-29])
					circle(r=m5);

		}
	}
}

$fn=20;

module back() {

H=50;
xoffset=outerX/2-50;

	difference (){
		bigpane();

	hull(){
		for(x=[-25,25]) {
			translate([xoffset+x,H])
				circle(r=20.25/2);
		}
	}
		translate([xoffset,H])
			coverplateholes();
	
	}
		translate([xoffset,H,6])
			*coverplate();
}

module hingeholes(){
			
	hingeS=14; //spacing between holes		
	for(x=[10,outerX-10]) {

		for(y=[70,70+hingeS,270,270+hingeS]) { // 20 cm spool passthrough
			translate([x,y])
					circle(r=m5);
		}
	}


}

module hingespacer(){
	difference(){
		hull(){
			for(x=[2,16]){
				for(y=[-20,20])
					translate([x,y])
						circle(r=2);
			}
		}
		for(y=[-14/2,14/2]) { // 20 cm spool passthrough
				translate([10,y])
						circle(r=m5);
			}
	}	
	
}

module frontdoor(){

difference(){
	hull() {
		for(x=[ 60,outerX-10-20-2]) {
			for(y=[20+6,300]) { // 20 cm spool passthrough
				translate([x,y])
					circle(r=10);
			}
		}
	}
	
	translate([-20-10,70])
		circle(r=m5);

	translate([-19.5,0])
		hingeholes();
	

	// for attaching double thickness
	gasket_holes();

	// handle
	handle(70,m5);

	}
}


module handle(lX,lR) {
	translate([lX,10+300/2]) {
		for(y=[-90/2,90/2])
			translate([0,y])
				circle(r=lR);
	}
// mounting holes for magnets, closeish to hinge location if I want to add latches
	for (bigY=[-30-300/2+70,-27-300/2+255]) {
		translate([lX,bigY+25+300/2]) {
			for(y=[0,20])
				translate([0,y])
					circle(r=m3);
		}

	}
}


module front() {
	difference (){
		bigpane();

		3induct();
		
		translate([outerX/2,40])
			hull() {
				for(x=[-140,180]) {
					for(y=[0,240]) { // 20 cm spool passthrough
						translate([x,y])
								circle(r=10);
					}
				}
			}
		hingeholes();
	

		handle(70,8/2);
	}

// screw holes for door layer connection
	gasket_holes();

	// hollow out gasket so we can reuse plastic

	translate([outerX/2,40])
			hull() {
				for(x=[20-140,180-20]) {
					for(y=[20,240-20]) { // 20 cm spool passthrough
						translate([x,y])
								circle(r=10);
					}
				}
			}
}


module gasket_holes(){
	translate([outerX/2,40])
		for(x=[-140,(140+180)/2-140,180]) {
			for(y=[0,240]) { // 20 cm spool passthrough
				translate([x,y])
						circle(r=m3);
			}
		}
}


module slotplate (){
	difference(){
		coverplate();

	for(x=[-40]) {
		hull(){
			for(y=[0,plateY]) {
				translate([x,y])
					circle(r=8/2);
			}
		}
	}


	for(x=[-5,20,45]) {
		hull(){
			for(y=[0,plateY]) {
				translate([x,y])
					circle(r=2); // USB cable sized. 
			}
		}
	}

	}
}



module left() {
	H=50; // where to put our access plate. Z axis
	yoffset=120;  // access plate Y access 



	difference (){
		sidepane();
		// DIN for power
		

		translate([yoffset,H]) {
			
			translate([-40,0])
				circle(r=20.25/2);



			// usb (power)
			translate([-5,0])
				circle(r=12/2);
			

			// 12V (power)
			translate([+20,0])
				circle(r=12/2);

			// usb (data)
			translate([+45,0])
				circle(r=12/2);

				coverplateholes();
		}


		translate([outerY-50,70+50])
			rotate(90) {

				coverplateholes();
				// usb (power)
					translate([-5,0])
						circle(r=12/2);
		
				translate([20,0])
					circle(r=12/2);
				
		
			}

	}
}

	

module coverplateholes(){
	// cover plate screw holes
		for (x=[-plateX/2+8,plateX/2-8]){ 
			for(y=[-plateY/2+8,plateY/2-8]) {
			translate([x,y])
				circle(r=m3);
			}
		}	
}


module coverplate(){
	rad=2.5;
	difference(){
		hull(){
			for(x=[-plateX/2+rad,plateX/2-rad]) {
				for(y=[-plateY/2+rad+1,plateY/2-rad]) {
					translate([x,y])	
						circle(r=2.5);
				}
			}
		}	

			coverplateholes();
	}
}




	// plate is 150mm x 35
	plateX=150;
	plateY=35;

//back();
//left(); // 2x, one is right
//coverplate();
front(); // get plastic blank at 50cm /20 inch square, then cut shape out. 
//top(); // 460x490, get cut to fix & then freehand the holes using a template. 

//translate([0,0,-1])
//	color("green")
//		frontdoor();

//translate([outerX-20,77.5,-1])
//hingespacer();
//slotplate();

//hingespacer(); // 2x