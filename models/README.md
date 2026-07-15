# Receiver Detector Model

`neutrino_receiver_detector.scad` is a parametric OpenSCAD visualization of the
receiver detector described in `../docs/design/system-design.md`.

## Contents

- A hollow cylindrical detector tank
- A support base
- Four rings of twelve inward-facing photodetectors

## Parameters

Edit the variables at the top of the `.scad` file to adjust the tank dimensions,
wall thickness, sensor-ring count, sensor count, or sensor dimensions. Units are
metres.

## Render and export

1. Open `neutrino_receiver_detector.scad` in OpenSCAD.
2. Preview with **F5** and render with **F6**.
3. Use **File → Export → Export as STL** to create a printable or interoperable
   mesh.

The model is a conceptual visualization only. It does not define structural,
material, radiation, or facility requirements.
