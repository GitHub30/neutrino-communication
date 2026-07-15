# neutrino-communication

## Concrete implementation (English)

This project models a practical neutrino communication system as a one-way deep-space link.

### 1. Message preparation
- Convert application data into fixed-size binary frames.
- Add frame metadata: `frame_id`, `timestamp`, and `payload_length`.
- Add forward error correction (FEC) parity blocks to each frame because neutrino interactions are rare and noisy.

### 2. Transmitter side
- Generate a high-energy proton beam and collide it with a target to produce pions.
- Let pions decay into a directed neutrino beam.
- Use on/off beam bursts (pulse-position or time-slot modulation) to encode each frame bitstream.
- Repeat each encoded frame multiple times to increase decode probability at long range.

### 3. Propagation
- The neutrino beam passes through matter almost without attenuation, so no relay satellite is required.
- Propagation delay is determined by distance and near-light-speed travel.

### 4. Receiver side
- Detect neutrino interaction events in a large detector volume.
- Convert detected event times into symbol slots.
- Reconstruct candidate bitstreams from event timing patterns.
- Apply FEC decoding and majority vote across repeated transmissions.
- Validate integrity using checksum/CRC and reorder by `frame_id`.

### 5. Link-layer reliability
- If uplink is available, use delayed ACK/NACK windows due to large propagation delay.
- If no return channel exists, use rateless/redundant forward transmission with sequence checkpoints.
- Drop corrupted frames that fail integrity checks after FEC retries.

### 6. Reference software flow
1. `encode(payload) -> framed_bits`
2. `beam_modulate(framed_bits) -> burst_schedule`
3. `detect_events() -> event_stream`
4. `demodulate(event_stream) -> soft_bits`
5. `fec_decode(soft_bits) -> frame`
6. `reassemble(frames) -> original_message`

This implementation emphasizes robustness over throughput, which matches current neutrino communication constraints.

## Design assets

- [System design](docs/design/system-design.md): link architecture, interfaces, data flow, and operating assumptions.
- [Design parameters](docs/design/design-parameters.csv): editable reference values for the conceptual link.
- [Receiver detector model](models/neutrino_receiver_detector.scad): a parametric OpenSCAD model of the conceptual receiver.
- [Model guide](models/README.md): rendering and export instructions.