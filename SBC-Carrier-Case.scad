$fn=32;

/**************************
*  select what to render  *
**************************/

// set true for objects you want to render
select_case     = true;
select_ups      = false;
select_sbc      = false;
select_sbc2     = false;
select_esp      = false;
select_solar    = true;
select_battery  = true;

/*******************
*  render options  * 
*******************/

// render selected objects mirrored
option_mirrored = false;

/********************
* important values  *
********************/

// case length
case_x              = 120;
// case_width
case_y              = 100;
// case wall thickness
case_wall           = 1.8;
// case screw diameter
case_screw          = 3;
// case screw distance (they will always be aligned to the middle)
case_screw_distance = 77.5;
// number of slots
slots               = 3;
// distance between slots
slot_distance       = 27.2;



/*********************
*  board dimensions  *
*********************/

// these values are used for the board carrier
// rpi4b length
sbc_x = 85;
// rpi4b width
sbc_y = 56;
// rpi4b screw diameter
sbc_screw_dia = 2.7;
// rpib4 screw distance x from lower left corner
sbc_screw_rim_x = 3.5;
// rpi4b screw distance x between left and right screws 
sbc_screw_x     = 58;
// rpib4 screw distance y from lower bottom corner
sbc_screw_rim_y = 3.5;
// rpi4b screw distance y between top and bottom screws
sbc_screw_y     = 49;
// height of screwhole on top of rpi4b carrier
sbc_screw_h     = 3;

// ups dimensions
// ups length
ups_x           = 85;
// ups width
ups_y           = 56;
// ups screw diameter
ups_screw_dia   = 2.7;
// ups screw distance x from lower left corner
ups_screw_rim_x = 3.5;
// ups screw distance x between left and right screws 
ups_screw_x     = 58;
// rpi4b screw distance y from lower bottom corner
ups_screw_rim_y = 3.5+5;
// ups screw distance y between top and bottom screws
ups_screw_y     = 49;
// height of screwhole on top of ups carrier
ups_screw_h     = 3;

// esp32 dimensions
// TTGO esp32 lora module length
esp_x           = 64.47;
// TTGO esp32 lora module width
esp_y           = 27;
// TTGO esp32 lora module screw diameter
esp_screw_dia   = 2.5;
// TTGO esp32 lora module screw distance x from lower left corner
esp_screw_rim_x = 2.56;
// TTGO esp32 lora module screw distance x between left and right screws 
esp_screw_x     = 0;
// rpi4b screw distance y from lower bottom corner
esp_screw_rim_y = 3.44;
// TTGO esp32 lora module screw distance y between top and bottom screws
esp_screw_y     = 22.15;
// height of screwhole on top of TTGO esp32 lora module carrier
esp_screw_h     = 6;

// battery dimensions
// battery lenght
// battery width
battery_w               = 60;
// battery height
battery_h               = 11;

// solar adapeter -> USB
// solar -> usb adapter width
solar_x                 = 19.6;
// solar -> usb adpater length
solar_y                 = 20;
// solar -> usb adapter height
solar_z                 = 11.3;

// raspberry pi zero 2W
// bPizero length
sbc2_x           = 65;
// bPizero width 
sbc2_y           = 30;
// bPizero screw diameter
sbc2_screw_dia   = 2.7;
// bPizero screw distance x from lower left corner
sbc2_screw_rim_x = 3.5;
// bPizero screw distance x between left and right screws
sbc2_screw_x     = 58;
// bPizero screw distance y from lower bottom corner
sbc2_screw_rim_y = 3.5+25;
// bPizero screw distance y between top and bottom screws
sbc2_screw_y     = 23;
// height of screwhole on top of bPizero carrier
sbc2_screw_h     = 3;


/********************
*  case dimensions  *
********************/

// case dimension
backplane_y             = case_y;
backplane_x             = case_x;
backplane_wall          = case_wall;
backplane_screw_dia     = case_screw;
backplane_screw_x       = 0;
backplane_screw_rim_x   = backplane_x/2;
backplane_screw_y       = case_screw_distance;
backplane_screw_rim_y   = (backplane_y - backplane_screw_y)/2;
backplane_slots         = slots;

// carrier values
carrier_frame_x         = max(sbc_x,ups_x,esp_x);
carrier_frame_y         = max(sbc_y,ups_y,esp_y);
// carrier height
carrier_frame_height    = 3;
// carrier addition
carrier_frame_addition  = 5;
// default carrier screw height on top of carrier
carrier_screw_h         = 5;
// change this value to adjust the distance between the boards
carrier_distance        = slot_distance;
// change this value for tighter or looser fitting of the board carrier
carrier_gap             = 0.55;

// calculate battery size
battery_x               = backplane_x-2*backplane_wall;
battery_y               = max(battery_w,carrier_frame_y+2*carrier_frame_addition);


/************************
*  main render section  *
************************/

if(select_esp)
{
    if(option_mirrored)
    {
        mirror([1,0,0])
        {
            esp_carrier();
        }
    }
    else
    {
        esp_carrier();
    }
}

if(select_sbc)
{
    if(option_mirrored)
    {
        mirror([1,0,0])
        {
            sbc_carrier();
        }
    }
    else
    {
        sbc_carrier();
    }
}

if(select_sbc2)
{
    if(option_mirrored)
    {
        mirror([1,0,0])
        {
            sbc2_carrier();
        }
    }
    else
    {
        sbc2_carrier();
    }
}
    
if(select_ups)
{
    if(option_mirrored)
    {
        mirror([1,0,0])
        {
            ups_carrier();
        }
    }
    else
    {
        ups_carrier();
    }
}

if(select_case)
{
    if(option_mirrored)
    {
        mirror([1,0,0])
        {
            case();
        }
    }
    else
    {
        case();
    }
}


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
    if(select_battery)
    {
        translate([0,backplane_y-2*backplane_wall-battery_h,backplane_wall])
        {
            battery_box(x=battery_x,
                        y=battery_y,
                        h=battery_h,
                        wall=backplane_wall);
        }
    }
    
    // solar box
    if(select_solar)
    {
        translate([backplane_x-solar_x-2*backplane_wall,2*carrier_distance,0])
        {
            solar(x=solar_x,
                  y=solar_y,
                  z=solar_z,
                  wall=backplane_wall);
        }
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
    overhang = 0;
    
    difference()
    {
        cube_round([x,y,z]+[2*wall,0-overhang,2*wall],mki=2);
        translate([wall,0,wall])
        {
            cube([x,y+wall-overhang,z]);
        }
        translate([wall,-overhang,wall])
        {
            cube([x,y-overhang,3.2]);
        }
    }
    /*translate([wall,y+wall-overhang,wall])
    {
        cube([x,wall,3.2]);
    }
    translate([wall,y-wall-overhang,wall])
    {
        cube([x,2*wall,1.3]);
    }*/
    /*translate([wall+x/2-5/2,0,wall])
    {
        #cube([5,2*wall,1.3]);
    }*/
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
module sbc2_carrier()
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
                    screw_rim_x=sbc2_screw_rim_x,
                    screw_x=sbc2_screw_x,
                    screw_rim_y=sbc2_screw_rim_y,
                    screw_y=sbc2_screw_y,
                    screw_h=sbc2_screw_h,
                    screw_dia=sbc2_screw_dia,
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