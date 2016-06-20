inner_width = 17.75;
outer_width = 19;
// https://www.server-racks.com/rack-mount-depth.html
dell_standard_depth = 28 + 7 / 8;
u = 1.75;
board_2_in = 2 - 0.25;
board_4_in = 4 - 0.25;

rack(u_capacity=5, clearance=6);

module rack(u_capacity=1, clearance=6)
{
  translate([board_2_in, 0, dell_standard_depth + clearance])
  {
    translate([0, 0, -board_4_in])
    {
      translate([board_2_in, board_2_in, board_4_in]) rotate([-90, 0, 0])
        %rackmount_unit(u_capacity);
      
      support_ring(u_capacity);
      translate([0, 0, -(dell_standard_depth - board_4_in)])
        support_ring(u_capacity);
    }
  
    translate([-board_2_in, 0, -(dell_standard_depth + clearance)])
      side(u_capacity, clearance);
    translate([inner_width + 2 * board_2_in, 0, -(dell_standard_depth + clearance)])
      side(u_capacity, clearance);
  }
}

module side(u_capacity, clearance)
{
  handle_height = board_2_in;
  color([0.8, 0.8, 0])
  {
    leg();
    translate([0, u * u_capacity  + 2 * board_2_in - board_4_in, 0])
      leg();
  }

  color([1, 1, 0])
    handle();

  module handle()
  {
    translate([0, 0, dell_standard_depth + 2 * clearance - handle_height])
    {
      difference()
      {
        cube([board_2_in, u * u_capacity + 2 * board_2_in, handle_height]);
        translate([-0.1, -0.1, handle_height / 2])
          cube([board_2_in + 0.2, 2 + 0.1, handle_height / 2 + 0.1]);
        translate([-0.1, u * u_capacity + 2 * board_2_in - 2 + 0.1, handle_height / 2])
          cube([board_2_in + 0.2, 2 + 0.1, handle_height / 2 + 0.1]);
      }
    }
  }

  module leg()
  {
    cube([board_2_in, board_4_in, dell_standard_depth + 2 * clearance - handle_height]);
  }
}

module support_ring(u_capacity=1)
{
  color([0.6, 0.6, 0])
  cube([board_2_in, u_capacity * u + 2 * board_2_in, board_4_in]);
  color([0.6, 0.6, 0])
  translate([board_2_in + inner_width, 0, 0])
    cube([board_2_in, u_capacity * u + 2 * (board_2_in), board_4_in]);
  color([0.4, 0.4, 0])
  translate([board_2_in, 0, 0])
    cube([inner_width, board_2_in, board_4_in]);
  color([0.4, 0.4, 0])
  translate([board_2_in, u_capacity * u + board_2_in, 0])
    cube([inner_width, board_2_in, board_4_in]);
}

module rackmount_unit(u_size=1)
{
  height = u * u_size;
  cube([inner_width, dell_standard_depth, height]);
  translate([-(outer_width - inner_width) / 2, -1 / 8, 0])
    cube([outer_width, 1 / 8, height]);
}

module board(nominal_width, nominal_height, depth)
{
  width = nominal_width - 0.25;
  height = nominal_height - 0.25;
  cube([height, depth, width]);
}
