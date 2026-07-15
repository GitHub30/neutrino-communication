# Receiver Hardware Design Specification

## 1. Purpose and status

This document defines a **conceptual** hardware baseline for the neutrino
receiver shown in `../../models/neutrino_receiver_detector.scad`. It supports
simulation, layout studies, interface planning, and requirements traceability.
It is not a construction package, safety analysis, procurement specification, or
authorization to build or operate a particle-physics facility.

All values labelled *baseline* are editable design assumptions. They must be
replaced by validated, site-specific values before implementation.

## 2. Design boundary

The receiver begins at the detector vessel and ends at the validated event-data
stream delivered to the demodulator. Beam generation, target engineering,
radiation shielding, excavation, pressure-vessel design, and regulatory
approval are out of scope.

```text
Detector medium --> Photosensors --> Front-end electronics --> Timing / trigger
                                                                  |
                                                                  v
Monitoring <---- Slow-control unit <---- Data acquisition <---- Event-data link
```

## 3. Hardware baseline

| Property | Baseline | Rationale |
| --- | --- | --- |
| Detector geometry | 12 m high × 12 m inner diameter cylinder | Matches the current parametric visualization. |
| Active medium | Water or another qualified interaction medium | Provides a configurable conceptual detection volume. |
| Photosensor layout | 4 rings × 12 channels | Matches the current visualization and permits channel mapping exercises. |
| Readout topology | One front-end channel per photosensor | Preserves independent timing and health information. |
| Event timestamp resolution | 10 ns target | Supports correlation of sparse events with symbol slots. |
| Timing reference | GNSS-disciplined clock with local holdover | Provides a traceable time base when external timing is available. |
| Data path | Buffered event records over Ethernet | Separates acquisition from offline decode and monitoring. |
| Operating mode | Forward-error-correction-first, one-way link | Matches the system-level architecture. |

## 4. Subsystem requirements

### 4.1 Detector vessel and medium

| ID | Requirement |
| --- | --- |
| HWD-VES-001 | The conceptual vessel shall provide an inner radius of 6 m and an inner height of 12 m. |
| HWD-VES-002 | The vessel design shall expose mounting positions for four equally spaced sensor rings. |
| HWD-VES-003 | The vessel and medium subsystem shall report fill level, temperature, and quality status to slow control. |
| HWD-VES-004 | Any physical vessel implementation shall be engineered and certified for its site-specific structural, containment, and safety loads. |

### 4.2 Photosensor array

| ID | Requirement |
| --- | --- |
| HWD-SEN-001 | The baseline array shall contain 48 independently addressable photosensor channels. |
| HWD-SEN-002 | Each channel shall provide a unique `channel_id` stable across acquisition runs. |
| HWD-SEN-003 | Each channel shall report a health state of `enabled`, `disabled`, `degraded`, or `fault`. |
| HWD-SEN-004 | Calibration data shall associate each `channel_id` with position, gain, timing offset, and calibration revision. |

### 4.3 Front-end electronics

| ID | Requirement |
| --- | --- |
| HWD-FE-001 | The front end shall digitize a detected pulse into amplitude, leading-edge time, width or charge proxy, and quality flags. |
| HWD-FE-002 | Each event record shall retain the source `channel_id` and acquisition-clock timestamp. |
| HWD-FE-003 | Front-end overflow, loss of synchronization, and calibration-invalid conditions shall be represented as quality flags. |
| HWD-FE-004 | The front end shall support an external calibration trigger without interrupting health monitoring. |

### 4.4 Timing and trigger

| ID | Requirement |
| --- | --- |
| HWD-TIM-001 | The timing subsystem shall distribute a common acquisition epoch to all front-end modules. |
| HWD-TIM-002 | The timing subsystem shall report reference lock, holdover state, and estimated timing uncertainty. |
| HWD-TIM-003 | Trigger decisions shall record the trigger source and a monotonic event sequence number. |
| HWD-TIM-004 | A timing-quality transition shall be emitted whenever the receiver changes between locked and holdover operation. |

### 4.5 Data acquisition and slow control

| ID | Requirement |
| --- | --- |
| HWD-DAQ-001 | The data-acquisition unit shall package events into a versioned event record before transmission. |
| HWD-DAQ-002 | The data-acquisition unit shall retain bounded local buffering and report buffer occupancy and dropped-event counts. |
| HWD-CTL-001 | Slow control shall poll or receive vessel, power, temperature, timing, and sensor-health telemetry. |
| HWD-CTL-002 | Slow control commands shall be authenticated and recorded in an audit log. |
| HWD-CTL-003 | Safety-critical interlocks shall fail to a non-operating state and shall not depend on the data network. |

## 5. Event record

The event-data link uses a versioned logical record. Physical encoding may be
binary, but these fields are required:

| Field | Type | Description |
| --- | --- | --- |
| `format_version` | unsigned integer | Event schema version. |
| `event_id` | unsigned integer | Monotonic identifier assigned by the DAQ. |
| `timestamp_ns` | unsigned integer | Acquisition time relative to the declared epoch. |
| `channel_id` | unsigned integer | Source photosensor channel. |
| `amplitude` | unsigned integer | Digitized pulse amplitude or calibrated proxy. |
| `charge_proxy` | unsigned integer | Integrated or width-derived charge estimate. |
| `quality_flags` | bit field | Trigger, synchronization, saturation, and health indicators. |
| `timing_quality` | enumeration | `locked`, `holdover`, or `invalid`. |
| `calibration_revision` | string | Calibration data version used by the front end. |

The DAQ shall reject records with unsupported `format_version` values and shall
never silently rewrite event timestamps.

## 6. Calibration and operations

1. Load a signed and versioned channel map and calibration set.
2. Verify timing-reference state and establish the acquisition epoch.
3. Record a baseline health snapshot before enabling event capture.
4. Perform a controlled calibration trigger sequence and store its revision.
5. Begin normal acquisition, continuously publishing telemetry and data-loss
   counters.
6. On timing, power, medium-quality, or interlock fault, mark data with the
   applicable quality state and transition according to the site safety plan.

## 7. Verification matrix

| Requirement group | Verification method | Evidence |
| --- | --- | --- |
| Vessel geometry and sensor positions | Model inspection | Rendered OpenSCAD model and measured dimensions. |
| Channel identity and calibration | Configuration test | Channel-map and calibration-revision export. |
| Event-record completeness | Interface test | Captured records checked against Section 5. |
| Timestamp and trigger behavior | Timing test | Reference-lock and holdover transition logs. |
| Buffer and loss reporting | Fault-injection simulation | Telemetry showing occupancy and loss counters. |
| Interlock independence | Safety review | Site-specific engineering and safety evidence. |

## 8. Related files

- `receiver-bom.csv` lists conceptual hardware line items and traceability.
- `receiver-interfaces.csv` defines the boundaries between hardware subsystems.
- `../design/design-parameters.csv` defines shared geometry and link assumptions.
- `../../models/neutrino_receiver_detector.scad` provides the matching 3D layout.
