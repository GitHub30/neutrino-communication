# Neutrino Communication System Design

## Scope

This is a conceptual, one-way deep-space neutrino communication link. It defines
the information flow and a receiver-detector layout suitable for simulation,
visualization, and future engineering refinement. It is not a construction-ready
accelerator or detector specification.

## System architecture

```text
Application payload
       |
       v
Frame builder --> FEC encoder --> Burst scheduler --> Proton target --> Neutrino beam
                                                                         |
                                                                         v
Application output <-- Frame reassembler <-- FEC decoder <-- Event demodulator
                                                              ^
                                                              |
                                                     Receiver detector
```

## Functional blocks

| Block | Input | Output | Responsibility |
| --- | --- | --- | --- |
| Frame builder | Application payload | Sequenced frames | Adds identifiers, timestamps, lengths, and checksums. |
| FEC encoder | Frames | Protected bitstream | Adds parity so sparse detector events can be recovered. |
| Burst scheduler | Protected bitstream | Timed beam commands | Maps symbols to on/off pulse slots and repetition windows. |
| Proton target | Beam commands | Neutrino pulses | Produces a directed neutrino source through pion decay. |
| Receiver detector | Neutrino interactions | Timestamped events | Records candidate interactions and detector health data. |
| Event demodulator | Timestamped events | Soft bits | Associates events with symbol slots and estimates confidence. |
| FEC decoder | Soft bits | Valid frames | Corrects recoverable loss and rejects invalid frames. |
| Frame reassembler | Valid frames | Application payload | Orders frames and reconstructs the original message. |

## Interfaces

| Interface | Format | Required fields |
| --- | --- | --- |
| Frame builder to FEC encoder | Binary frame | `frame_id`, `timestamp`, `payload_length`, `payload`, `crc` |
| FEC encoder to burst scheduler | Protected bitstream | `frame_id`, encoded bits, code rate, repetition count |
| Burst scheduler to source | Timed command sequence | slot start, slot duration, beam enabled |
| Detector to demodulator | Event stream | event time, detector channel, energy estimate, quality flags |
| Decoder to reassembler | Validated frame | `frame_id`, payload, decode confidence |

## Operating sequence

1. Segment a message into frames and append integrity metadata.
2. Apply forward error correction and select a repetition count.
3. Schedule beam bursts in fixed-duration symbol slots.
4. Record receiver interactions using a shared or estimated time reference.
5. Convert event counts and timing into soft symbol decisions.
6. Decode frames, validate their CRCs, and reassemble the payload.

## Reliability and safety boundaries

- The design is forward-error-correction first: a return channel is optional.
- Missing or CRC-invalid frames are never delivered to the application layer.
- Timing and detector-quality metadata are retained to support offline analysis.
- Beam production, radiation shielding, target engineering, detector siting, and
  regulatory approval are outside this conceptual design and require qualified
  facility-specific engineering.

## Related assets

- `design-parameters.csv` contains editable conceptual values.
- `../../models/neutrino_receiver_detector.scad` provides the receiver-detector
  visualization corresponding to this architecture.
