
outerX = 490; // Front edge of box.  
outerZ=475;
outerY=outerZ ; 


innerX=454;
innerZ=innerX;

m3=3.1/2;
m5=5.125/2;

// Top




module bigpane(){

	difference() {
		square ([outerX,outerZ]);

		// vertical holes
		L=50; 
		Rv=outerZ-50;
		for (x=[10,outerX-10]) {
			// corners

			for (z=[L,Rv]) {
				translate([x,z])
					circle(r=m3);
			}
			// edges
			for (z=[1:3]) {
					translate([x, L+ z* (Rv-L)/4])
						circle(r=m3);
				}
		}


	// Horizontal Holes
		Rh=outerX-50;
		for (y=[10,outerZ-10]) {
			// corners

			for (x=[L,Rh]) {
				translate([x,y])
					circle(r=m3);
			}
			// edges
			for (x=[1:3]) {
					translate([L+ x * (Rh-L)/4,y])
						circle(r=m3);
				}
		}


	}
}



module sidepane(){

	union() {
		square ([innerX,innerZ]);

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
			for(x=[2,19]){
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
	H=50;
	xoffset=110;
	difference (){
		sidepane();
		// DIN for power
		

		translate([xoffset,H]) {
			
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
//front();
//frontdoor();
//slotplate();

hingespacer(); // 2x