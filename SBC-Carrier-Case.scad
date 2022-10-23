$fn=32;

/*********************
*  board dimensions  *
*********************/

// raspberry pi 4b
sbc_x = 85;
sbc_y = 56;
sbc_screw_dia = 2.7;
sbc_screw_rim_x = 3.5;
sbc_screw_x     = 58;
sbc_screw_rim_y = 3.5;
sbc_screw_y     = 49;
sbc_screw_h     = 3;

// ups dimensions
ups_x           = 85;
ups_y           = 56;
ups_screw_dia   = 2.7;
ups_screw_rim_x = 3.5;
ups_screw_x     = 58;
ups_screw_rim_y = 3.5+5;
ups_screw_y     = 49;
ups_screw_h     = 3;

// esp32 dimensions
esp_x           = 64.47;
esp_y           = 27;
esp_screw_dia   = 2;
esp_screw_rim_x = 2.56;
esp_screw_x     = 0;
esp_screw_rim_y = 3.44;
esp_screw_y     = 22.15;


// raspberry pi zero 2W
/*
sbc_x           = 65;
sbc_y           = 30;
sbc_screw_dia   = 2.7;
sbc_screw_rim_x = 3.5;
sbc_screw_x     = 58;
sbc_screw_rim_y = 3.5;
sbc_screw_y     = 23;
sbc_screw_h     = 0.4;

// ups dimensions
ups_x           = 0;
ups_y           = 0;
ups_screw_dia   = 2.7;
ups_screw_rim_x = 3.5;
ups_screw_x     = 58;
ups_screw_rim_y = 3.5;
ups_screw_y     = 49;

// esp32 dimensions
esp_x           = 64.47;
esp_y           = 27;
esp_screw_dia   = 2;
esp_screw_rim_x = 2.56;
esp_screw_x     = 0;
esp_screw_rim_y = 3.44;
esp_screw_y     = 22.15;
*/


/********************
*  case dimensions  *
********************/

// backplane
backplane_y             = 100;
backplane_x             = 120;
backplane_wall          = 1.8;
backplane_screw_dia     = 2.7;
backplane_screw_x       = 0;
backplane_screw_rim_x   = backplane_x/2;
backplane_screw_y       = 77.5;
backplane_screw_rim_y   = (backplane_y - backplane_screw_y)/2;
backplane_slots         = 3;

// carrier
carrier_frame_x         = max(sbc_x,ups_x,esp_x);
carrier_frame_y         = max(sbc_y,ups_y,esp_y);
carrier_frame_height    = 3;
carrier_frame_addition  = 5;
carrier_screw_h         = 5;
carrier_distance        = 27.2;
carrier_gap             = 0.55;

// battery
battery_x               = backplane_x-2*backplane_wall;
battery_y               = max(60,carrier_frame_y+2*carrier_frame_addition);
battery_h               = 11;

// solar adapter
solar_x                 = 19.5;
solar_y                 = 38.5;
solar_z                 = 11.3;


mirror([1,0,0])
{
    esp_carrier();
}
//sbc_carrier();
//ups_carrier();
//case();

/************
*  modules  *
************/

module case()
{
    // main case
    difference()
    {
        cube_round([backplane_x,
                    backplane_y,
                    max(carrier_frame_y+2*carrier_frame_addition,battery_y)]
                  +[0,0,backplane_wall]);
        
        // inner cutout
        translate([backplane_wall,backplane_wall,backplane_wall])
        {
            cube_round([backplane_x,
                        backplane_y,
                        max(carrier_frame_y+2*carrier_frame_addition,
                            battery_y)]
                      -[2*backplane_wall,2*backplane_wall,0]);
        }
        // board access
        translate([0,backplane_wall,backplane_wall+carrier_frame_addition])
        {
            cube([backplane_wall,
                  min(backplane_slots*carrier_distance,
                      backplane_y-battery_h-3*backplane_wall),
                  carrier_frame_y]);
        }
        // wall cutout
        translate([backplane_wall+carrier_frame_addition-2,
                   0,
                   carrier_frame_addition+backplane_wall])
        {
            cube_round([backplane_x,backplane_y-battery_h-4*backplane_wall,300],plane="xz");
            translate([2*backplane_wall,0,0])
                cube_round([backplane_x,backplane_y-battery_h-2*backplane_wall,300],plane="yz");
        }
        // bottom cutout
        translate([carrier_frame_addition+backplane_wall+10+5+backplane_wall,
                   3*backplane_wall,
                   0])
        {
            cube_round([backplane_x/2
                        -(carrier_frame_addition+backplane_wall+10+5+backplane_wall)
                        -backplane_screw_dia/2-backplane_wall,
                         backplane_y-battery_h-7*backplane_wall,
                         backplane_wall]);
            translate([0,+battery_h/2+backplane_screw_dia/2+2*backplane_wall,0])
            {
                cube_round([carrier_frame_x-15,
                            backplane_screw_y-battery_h-backplane_screw_dia+2*backplane_wall,
                            backplane_wall]);
            }
        }
        //screw holes
        translate([0,0,backplane_wall])
        {
            screw_holes(screw_dia=backplane_screw_dia,
                    screw_rim_x=backplane_screw_rim_x,
                    screw_x=backplane_screw_x,
                    screw_rim_y=backplane_screw_rim_y,
                    screw_y=backplane_screw_y,
                    screw_h=0,
                    frame_height=backplane_wall,
                    massive=true);
        }
    }

    // battery box
    translate([0,backplane_y-2*backplane_wall-battery_h,backplane_wall])
    {
        battery_box(x=battery_x,
                    y=battery_y,
                    h=battery_h,
                    wall=backplane_wall);
    }
    
    // solar box
    translate([backplane_x-solar_x-2*backplane_wall,5,0])
    {
        solar(x=solar_x,
              y=solar_y,
              z=solar_z,
              wall=backplane_wall);
    }

    // carrier holder
    carrier_holder(height1=carrier_frame_y+2*carrier_frame_addition,
                   height2=carrier_frame_addition,
                   wall=backplane_wall,
                   carrier_frame_height=carrier_frame_height,
                   carrier_frame_addition=carrier_frame_addition,
                   carrier_frame_x=carrier_frame_x+2*carrier_frame_addition);
}




// battery box
module battery_box(x,y,h,wall)
{
    // location of cable opening
    cable_loc_x = 80;
    cable_dim_x = 10;
    cable_dim_y = 10;
    airgap      = 5;
    
    difference()
    {
        cube_round([x,h,y]
                  +[2*wall,2*wall,0]);
        
        // inner cutout
        translate([wall,wall,0])
        {
            cube_round([x,h,y]);
        }
        
        // cable opening
        translate([cable_loc_x,0,-wall])
        {
            cube_round([cable_dim_x,wall,cable_dim_y],plane="xz");
        }
        
        // air gaps
        for(i=[airgap:2*airgap:backplane_x-2*airgap])
        {
            translate([wall+i,0,cable_dim_y+airgap])
            {
                cube_round([airgap,wall,y-2*airgap-cable_dim_y],mki=airgap-1,plane="xz");
            }
        }
    }
}

// solar box
module solar(x,y,z,wall)
{
    difference()
    {
        cube_round([x,y,z]+[2*wall,2*wall-5,wall],mki=2);
        translate([wall,wall,wall])
        {
            cube([x,y+wall-5,z]);
        }
        translate([wall,-5,wall])
        {
            cube([x,y-5,3.2]);
        }
    }
    translate([wall,y+wall-5,wall])
    {
        cube([x,wall,3.2]);
    }
    translate([wall,y-wall-5,wall])
    {
        cube([x,2*wall,1.3]);
    }
    translate([wall+x/2-5/2,0,wall])
    {
        cube([5,2*wall,1.3]);
    }
}

// esp carrier
module esp_carrier()
{
    translate([backplane_wall,
               backplane_wall+carrier_frame_addition-2,
               backplane_wall+carrier_frame_y+2*carrier_frame_addition-0.8])
    {
        rotate([270,0,0])
        {
            carrier(x=carrier_frame_x,
                    y=carrier_frame_y,
                    frame_height=carrier_frame_height-carrier_gap,
                    frame_addition=carrier_frame_addition-carrier_gap,
                    screw_rim_x=esp_screw_rim_x,
                    screw_x=esp_screw_x,
                    screw_rim_y=esp_screw_rim_y,
                    screw_y=esp_screw_y,
                    screw_h=carrier_screw_h,
                    screw_dia=esp_screw_dia,
                    cut_sides="xy");
        }
    }
}

// sbc carrier
module sbc_carrier()
{
    translate([backplane_wall,
               backplane_wall+carrier_distance+carrier_frame_addition-2,
               backplane_wall+carrier_frame_y+2*carrier_frame_addition-0.8])
    {
        rotate([270,0,0])
        {
            carrier(x=carrier_frame_x,
                    y=carrier_frame_y,
                    frame_height=carrier_frame_height-carrier_gap,
                    frame_addition=carrier_frame_addition-carrier_gap,
                    screw_rim_x=sbc_screw_rim_x,
                    screw_x=sbc_screw_x,
                    screw_rim_y=sbc_screw_rim_y,
                    screw_y=sbc_screw_y,
                    screw_h=sbc_screw_h,
                    screw_dia=sbc_screw_dia,
                    cut_sides="xy");
        }
    }
}

// ups carrier
module ups_carrier()
{
    translate([backplane_wall,
               backplane_wall+2*carrier_distance+carrier_frame_addition-2,
               backplane_wall+carrier_frame_y+2*carrier_frame_addition-0.8])
    {
        rotate([270,0,0])
        {
            carrier(x=carrier_frame_x,
                    y=carrier_frame_y,
                    frame_height=carrier_frame_height-carrier_gap,
                    frame_addition=carrier_frame_addition-carrier_gap,
                    screw_rim_x=ups_screw_rim_x,
                    screw_x=ups_screw_x,
                    screw_rim_y=ups_screw_rim_y,
                    screw_y=ups_screw_y,
                    screw_h=ups_screw_h,
                    screw_dia=ups_screw_dia,
                    cut_sides="x");
        }
    }
}





// carrier holder
module carrier_holder(height1,
                      height2=10,
                      wall,
                      carrier_frame_height,
                      carrier_frame_addition,
                      carrier_frame_x)
{

    for(dist=[wall
             :carrier_distance
             :min(backplane_y-battery_h-3*wall-carrier_distance,
                  backplane_slots*carrier_distance)])
    {
        translate([0,dist,0])
        {
            cube([wall,2*(carrier_frame_addition-2)+carrier_frame_height,height1]);
            holder(depth=carrier_frame_addition-2,
                   width=carrier_frame_addition-2,
                   height=height1,
                   wall=wall,
                   carrier_frame_height=carrier_frame_height);

            translate([carrier_frame_x-carrier_frame_addition+2,0,0])
            {
                holder(depth=carrier_frame_addition-2,
                       width=carrier_frame_addition-2,
                       height=height2,
                       wall=wall,
                       carrier_frame_height=carrier_frame_height);
            }
            // clip
            translate([carrier_frame_addition+wall+10,1,wall])
            {
                clip();
            }
        }
    }
    // low wall
    translate([wall+carrier_frame_x,wall,wall])
    {
        cube([wall,
              min(backplane_y-battery_h-carrier_distance+2,
                  (backplane_slots-1)*carrier_distance+2*(carrier_frame_addition-2)+carrier_frame_height),
              height2]);
    }
}


// holder element
module holder(depth,width,height,wall,carrier_frame_height)
{
    //cube([wall,2*width+carrier_frame_height,height]);
    translate([wall,0,wall])
    {
        cube([depth,width,height]);
        translate([0,width+carrier_frame_height,0])
        {
            cube([depth,width,height]);
        }
    }
}


module carrier(x,
               y,
               frame_height,
               frame_addition,
               screw_rim_x,
               screw_x,
               screw_rim_y,
               screw_y,
               screw_h,
               screw_dia,
               screw_h=5,
               cut_sides)
{
    difference()
    {
        carrier_frame(x=x,
                      y=y,
                      frame_height=frame_height,
                      frame_addition=frame_addition,
                      screw_rim_x=screw_rim_x,
                      screw_rim_y=screw_rim_y,
                      cut_sides=cut_sides);
        translate([frame_addition,frame_addition,frame_height])
        {
            screw_holes(screw_dia=screw_dia,
                        screw_rim_x=screw_rim_x,
                        screw_x=screw_x,
                        screw_rim_y=screw_rim_y,
                        screw_y=screw_y,
                        screw_h=screw_h,
                        frame_height=frame_height,
                        massive=true);
        }
        // gap for clip
        translate([carrier_frame_addition+10-0.6,y-1,0]){
            cube([5+2*0.6,frame_addition-1,2]);
        }
        //translate([-(5+2*0.6+1)+x-carrier_frame_addition,carrier_frame_addition+2,0]){
        //    #cube([7+2*0.6,frame_addition-1,2]);
        //}
        translate([carrier_frame_addition+10-0.6,frame_addition+2,0]){
            #cube([5+2*0.6,frame_addition-1,2]);
        }
    }
    translate([frame_addition,frame_addition,frame_height])
    {
        screw_holes(screw_dia=screw_dia,
                        screw_rim_x=screw_rim_x,
                        screw_x=screw_x,
                        screw_rim_y=screw_rim_y,
                        screw_y=screw_y,
                        screw_h=screw_h,
                        frame_height=frame_height,
                        massive=false);
    }
}


// carrier_frame frame module
module carrier_frame(x,
                     y,
                     frame_height,
                     frame_addition,
                     screw_rim_x,
                     screw_rim_y,
                     cut_sides="x")
{
    difference()
    {
        cube_round([x+2*frame_addition,y+2*frame_addition,frame_height]);
        // center cutout
        translate([2*frame_addition+screw_rim_x,
                   2*frame_addition+screw_rim_y,
                   0])
        {
            cube_round([x-2*(frame_addition+screw_rim_x),
                   y-2*(frame_addition+screw_rim_y),
                   frame_height]);
        }
        // side cutouts
        if(cut_sides == "y" || cut_sides == "xy")
        {
            translate([2*frame_addition+screw_rim_x,0,0])
            {
                cube([x-2*(frame_addition+screw_rim_x),
                      frame_addition,
                      frame_height]);
            }
            translate([2*frame_addition+screw_rim_x,y+frame_addition,0])
            {
                cube([x-2*(frame_addition+screw_rim_x),
                      frame_addition,
                      frame_height]);
            }
        }
        if(cut_sides == "x" || cut_sides == "xy")
        {
            translate([0,2*frame_addition+screw_rim_y,0])
            {
                cube([frame_addition,
                       y-2*(frame_addition+screw_rim_y),
                       frame_height]);
            }
            translate([x+frame_addition,2*frame_addition+screw_rim_y,0])
            {
                cube([frame_addition,
                       y-2*(frame_addition+screw_rim_y),
                       frame_height]);
            }
        }
    }
}


module screw_holes(screw_dia,
                   screw_rim_x,
                   screw_x,
                   screw_rim_y,
                   screw_y,
                   screw_h,
                   frame_height,
                   massive=false)
{
    translate([screw_rim_x,screw_rim_y,0])
    {
        screw_hole(dia=screw_dia,
                   height=screw_h,
                   depth=frame_height,
                   massive=massive);
    }
    translate([screw_rim_x,screw_rim_y+screw_y,0])
    {
        screw_hole(dia=screw_dia,
                   height=screw_h,
                   depth=frame_height,
                   massive=massive);
    }
    translate([screw_rim_x+screw_x,screw_rim_y+screw_y,0])
    {
        screw_hole(dia=screw_dia,
                   height=screw_h,
                   depth=frame_height,
                   massive=massive);
    }
    translate([screw_rim_x+screw_x,screw_rim_y,0])
    {
        screw_hole(dia=screw_dia,
                   height=screw_h,
                   depth=frame_height,
                   massive=massive);
    }
}

module screw_hole(dia,height,depth,massive=false)
{
    d1=4;
    d2=2;
    
    if(massive){
        cylinder(h=height,d1=dia+d1,d2=dia+d2);
        translate([0,0,-depth])
        {
            cylinder(h=height+depth,d=dia);
        }
    }
    else
    {
        difference(){
            cylinder(h=height,d1=dia+d1,d2=dia+d2);
            translate([0,0,-depth])
            {
                cylinder(h=height+depth,d=dia);
            }
        }
    }
}


module clip(width=5,thickness=2)
{
    cube([width,thickness,carrier_frame_addition+2]);
    
    translate([0,0,carrier_frame_addition+2])
    {
        difference()
        {
            cube([width,3,5]);
            translate([0,5,0])
            {
                rotate([45,0,0])
                {
                    cube([width,5,10]);
                }
            }
        }
    }
}


module cube_round(dim,mki=5,plane="xy"){
    if(mki<=0)
    {
        cube(dim);
    }
    else
    {
        if(plane=="xy")
        {
            translate([mki/2,mki/2,0])
            {
                linear_extrude(dim[2])
                {
                    minkowski()
                    {
                        square([dim[0]-mki,dim[1]-mki]);
                        circle(d=mki);
                    }
                }
            }
        }
        if(plane=="yz")
        {
            translate([0,mki/2,dim[2]-mki/2])
            {
                rotate([0,90,0])
                {
                    linear_extrude(dim[0])
                    {
                        minkowski()
                        {
                            square([dim[2]-mki,dim[1]-mki]);
                            circle(d=mki);
                        }
                    }
                }
            }
        }
        if(plane=="xz")
        {
            translate([mki/2,dim[1],mki/2])
            {
                rotate([90,0,0])
                {
                    linear_extrude(dim[1])
                    {
                        minkowski()
                        {
                            square([dim[0]-mki,dim[2]-mki]);
                            circle(d=mki);
                        }
                    }
                }
            }
        }
    }
}