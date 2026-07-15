/*
 * Conceptual neutrino receiver detector.
 * Units are metres. This is a visualization model, not a construction drawing.
 */

$fn = 96;

tank_radius = 6;
tank_height = 12;
wall_thickness = 0.3;
sensor_rings = 4;
sensors_per_ring = 12;
sensor_radius = 0.16;
sensor_depth = 0.08;

module detector_tank() {
    difference() {
        cylinder(h = tank_height, r = tank_radius, center = true);
        cylinder(h = tank_height + 0.02, r = tank_radius - wall_thickness, center = true);
    }
}

module support_base() {
    cylinder(h = 0.4, r = tank_radius + 0.8, center = true);
}

module photodetector_ring(z_position) {
    for (index = [0 : sensors_per_ring - 1]) {
        angle = 360 * index / sensors_per_ring;
        rotate([0, 0, angle])
            translate([tank_radius - wall_thickness - sensor_depth / 2, 0, z_position])
                rotate([0, 90, 0])
                    cylinder(h = sensor_depth, r = sensor_radius, center = true);
    }
}

module receiver_detector() {
    color([0.55, 0.75, 0.9, 0.35])
        detector_tank();

    color([0.25, 0.25, 0.28])
        translate([0, 0, -tank_height / 2 - 0.2])
            support_base();

    color([0.95, 0.8, 0.2])
        for (ring = [0 : sensor_rings - 1]) {
            z_position = -tank_height / 2
                + tank_height * (ring + 1) / (sensor_rings + 1);
            photodetector_ring(z_position);
        }
}

receiver_detector();
