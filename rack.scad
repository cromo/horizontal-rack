rack_type = "19\"";
oem = "Dell";
u_capacity = 5;
clearance = 6;

outer_width = rack_outer_width(standard=rack_type);
inner_width = rack_inner_width(standard=rack_type);
u = rack_u_height(standard=rack_type);

rack(u_capacity, clearance, server_depth=standard_depth(oem));

// https://en.wikipedia.org/wiki/Lumber#North_American_softwoods
function board(nominal_in) =
  nominal_in ==  1 ?      3 / 4 :
  nominal_in ==  2 ?  1 + 1 / 2 :
  nominal_in ==  3 ?  2 + 1 / 2 :
  nominal_in ==  4 ?  3 + 1 / 2 :
  nominal_in ==  6 ?  5 + 1 / 2 :
  nominal_in ==  8 ?  7 + 1 / 4 :
  nominal_in == 10 ?  9 + 1 / 4 :
  nominal_in == 12 ? 11 + 1 / 4 :
  undef;

// https://en.wikipedia.org/wiki/19-inch_rack#/media/File:Dimensions_19-inch_ETSI_rack.png
function rack_outer_width(standard="19\"") =
  standard == "19\"" ? 19 :
  standard == "ETSI" ? 21 :
  undef;
function rack_inner_width(standard="19\"") =
  standard == "19\"" ? 17.75 :
  standard == "ETSI" ? 19.68 :
  undef;
function rack_u_height(standard="19\"") =
  standard == "19\"" ? 1.75 :
  standard == "ETSI" ? 1 :
  undef;

// https://www.server-racks.com/rack-mount-depth.html
function standard_depth(oem="Dell") =
  oem == "Dell" ? 28 + 7 / 8 :
  oem == "HP" ?   29 + 1 / 8 :
  oem == "IBM" ?  28 + 1 / 2 :
  undef;

support_ring_height = board(nominal_in=4);
support_ring_side_width = board(nominal_in=2);
support_ring_cross_beam_thickness = board(nominal_in=2);
leg_width = board(nominal_in=2);
leg_thickness = board(nominal_in=4);
handle_height = board(nominal_in=2);
handle_width = board(nominal_in=2);

module rack(u_capacity=1, clearance=6, server_depth=standard_depth(oem))
{
  translate([leg_width + support_ring_side_width, support_ring_cross_beam_thickness, server_depth + clearance])
    rotate([-90, 0, 0])
      %rackmount_unit(u_capacity, depth=server_depth);

  for(z = [clearance, clearance + server_depth - support_ring_height])
    translate([leg_width, 0, z])
      support_ring(u_capacity);
  for(x = [0, inner_width + 2 * support_ring_side_width + leg_width])
    translate([x, 0, 0])
      side(u_capacity, clearance, server_depth);
}

module side(u_capacity, clearance, server_depth)
{
  for(y = [0, u_capacity * u + 2 * support_ring_cross_beam_thickness - leg_thickness])
    translate([0, y, 0])
      color([0.8, 0.8, 0])
	leg();

  translate([0, 0, server_depth + 2 * clearance - handle_height])
    color([1, 1, 0])
      handle();

  module handle()
    difference()
    {
      cube([handle_width, u * u_capacity + 2 * support_ring_cross_beam_thickness, handle_height]);
      for(y = [-0.1, u_capacity * u + 2 * support_ring_cross_beam_thickness - 2 + 0.1])
	translate([-0.1, y, handle_height / 2])
	  cube([handle_width + 0.2, 2 + 0.1, handle_height / 2 + 0.1]);
    }

  module leg()
    cube([leg_width, leg_thickness, server_depth + 2 * clearance - handle_height]);
}

module support_ring(u_capacity=1)
{
  for(x = [0, support_ring_side_width + inner_width])
    translate([x, 0, 0])
      color([0.6, 0.6, 0])
        depth_beam();
  for(y = [0, u_capacity * u + support_ring_side_width])
    translate([support_ring_side_width, y, 0])
      color([0.4, 0.4, 0])
        cross_beam();

  module depth_beam()
    cube([support_ring_side_width, u_capacity * u + 2 * support_ring_cross_beam_thickness, support_ring_height]);
  module cross_beam()
    cube([inner_width, support_ring_cross_beam_thickness, support_ring_height]);
}

module rackmount_unit(u_size=1, depth=standard_depth(oem))
{
  height = u * u_size;
  // The main body of the chassis.
  cube([inner_width, depth, height]);
  // The front panel, including ears.
  translate([-(outer_width - inner_width) / 2, -1 / 8, 0])
    cube([outer_width, 1 / 8, height]);
}
