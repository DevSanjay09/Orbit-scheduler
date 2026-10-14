# 🛰️ Orbit Scheduler

**Autonomous Orbital Compute Workload Orchestrator & Constellation Scheduler**  
*Built with Serverpod (Dart), Flutter, Keplerian Astrodynamics, and Google Gemini AI.*

[![Serverpod](https://img.shields.io/badge/Serverpod-3.4%20%7C%204.0-00B0FF?style=flat&logo=dart)](https://serverpod.dev)
[![Flutter](https://img.shields.io/badge/Flutter-3.47+-02569B?style=flat&logo=flutter)](https://flutter.dev)
[![Serverpod Cloud](https://img.shields.io/badge/Hosted_on-Serverpod_Cloud-00E5FF?style=flat)](https://orbit-scheduler.serverpod.space)
[![Google Gemini](https://img.shields.io/badge/AI-Google_Gemini-4285F4?style=flat&logo=google)](https://ai.google.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## 🌐 Live Production Links

Orbit Scheduler is deployed and running live on **Serverpod Cloud**:

| Service | Public URL | Description |
| :--- | :--- | :--- |
| **🚀 Mission Control Web App** | [https://orbit-scheduler.serverpod.space/app/](https://orbit-scheduler.serverpod.space/app/) | Full interactive 3D Globe & Mission Control Dashboard |
| **⚡ Serverpod Cloud API** | [https://orbit-scheduler.api.serverpod.space/](https://orbit-scheduler.api.serverpod.space/) | Live Serverpod backend endpoints & WebSocket stream |
| **🔍 Cloud Insights Console** | [https://orbit-scheduler.insights.serverpod.space/](https://orbit-scheduler.insights.serverpod.space/) | Server telemetry, database migrations, and health checks |
| **🐙 GitHub Repository** | [https://github.com/DevSanjay09/Orbit-scheduler](https://github.com/DevSanjay09/Orbit-scheduler) | Complete source code repository |

---

## 🔴 The Problem

Next-generation Low Earth Orbit (LEO) megaconstellations (e.g. Starlink, Project Kuiper, earth observation satellites) are deploying high-density compute payloads directly in orbit. However, executing demanding compute workloads (e.g., on-orbit AI model training, hyperspectral image analysis, distributed synthetic aperture radar processing) faces extreme physical constraints that traditional cloud schedulers (like Kubernetes, Slurm, or Nomad) are fundamentally unequipped to handle:

1. **Strict Thermal Throttling in Vacuum**: Heat in space cannot be dissipated through convection or conduction; it can only radiate into deep space ($T_{\text{space}} \approx 3\text{ K}$). Under intense compute, avionics quickly spike toward 68°C, triggering aggressive throttling or payload shutdowns.
2. **Periodic Solar Eclipses**: In typical 550 km LEO orbits (period $\sim 95$ minutes), satellites spend 35+ minutes per orbit in the Earth’s shadow. Battery State-of-Charge (SoC) plummets, requiring non-critical batch compute to yield power immediately.
3. **Intermittent Ground Contacts**: Satellites pass over physical ground stations for only 5–10 minutes per pass. Schedulers must pre-plan job data ingress and result egress windows rather than assuming continuous Internet connectivity.
4. **Radiation Upsets & Dynamic Optical Cross-Links**: Single Event Upsets (SEU bit-flips in SRAM) and attitude tracking jitter frequently drop Inter-Satellite Optical Laser (ISL) links, corrupting in-flight computations and severing network paths.
5. **Compute Loss on Eviction**: Naive preemption or reactive restarts discard hours of valuable orbital compute.

---

## 🟢 The Solution: Orbit Scheduler

**Orbit Scheduler** is a physics-informed, lookahead-aware distributed orchestrator designed from the ground up for satellite constellations:

* **🔭 3-Hour Predictive Lookahead Horizon**: Before placing or continuing any workload, the scheduler simulates each satellite's 3-hour trajectory—calculating upcoming solar shadow entries, battery SoC draw curves, and core thermal buildup.
* **🛡️ Safe Proactive Migration**: If the predicted safe window $T_{\text{safe}} < T_{\text{rem}} + T_{\text{transfer}} + 90\text{s}$, the workload is autonomously migrated across 10 Gbps optical ISL links to a cool, sunlight-facing satellite before degradation occurs.
* **⏸️ Unplaceable Job Protection**: If no satellite meets safety and ground-contact constraints, jobs wait safely in a priority queue rather than forcing a risky placement that could fail mid-execution.
* **💾 Checkpoint & Rollback Engine**: Workloads take incremental state checkpoints (every 180s). If an SEU radiation upset occurs, the job rolls back to its last verified state rather than restarting from scratch.
* **🤖 Google Gemini Natural Language Policy Synthesis**: Operators type operational rules in plain English (e.g., *"Lock batch processing on polar passes when battery is under 40%"*). Gemini translates them into live constraint expressions with impact analysis and operator confirmation.
* **🔗 Immutable Append-Only Decision Ledger**: Every scheduling decision, migration event, and fault recovery is hashed and chained into a cryptographic SHA-256 audit ledger, verifiable in one click.
* **🌍 Real 3D Interactive World Globe & 2D Mercator Console**: Realistic 3D rotating Earth, day/night terminators, 72 Walker-delta satellites, green connected nodes, red unlinked nodes, and electric blue ground feeder passes.

---

## 💻 Tech Stack & Architecture

```
                    ┌──────────────────────────────────────────────┐
                    │          Flutter Mission Control UI          │
                    │   (3D Globe Canvas, Telemetry & Webhooks)    │
                    └──────────────────────┬───────────────────────┘
                                           │ WebSockets / HTTP (8088)
                                           ▼
                    ┌──────────────────────────────────────────────┐
                    │             Serverpod 3.4 / 4.0              │
                    │         (Dart High-Concurrency Server)       │
                    └──────┬───────────────┬────────────────┬──────┘
                           │               │                │
            ┌──────────────▼─────┐  ┌──────▼──────┐  ┌──────▼─────────────┐
            │ Keplerian Physics  │  │   Gemini    │  │  Append-Only Hash  │
            │  & Thermal Engine  │  │  AI Engine  │  │   Audit Ledger     │
            │  (72 Satellites)   │  │  (Operator) │  │     (SHA-256)      │
            └────────────────────┘  └─────────────┘  └────────────────────┘
```

| Layer | Technologies Used | Key Responsibilities |
| :--- | :--- | :--- |
| **Backend Framework** | **Serverpod 3.4 / 4.0 (Dart)** | Full-stack Dart server, streaming endpoints, real-time serialization, database ORM. |
| **Cloud Hosting** | **Serverpod Cloud (`scloud`)** | Containerized rollout, auto-scaling podlets, SSL management, cloud database. |
| **Frontend & Visualization** | **Flutter 3.47+ (Web & Desktop)** | 60 FPS real-time UI, CustomPainter 3D spherical trigonometry, `fl_chart`, aerospace typography. |
| **Artificial Intelligence** | **Google Gemini 1.5 Pro / Flash** | Natural language policy synthesis, constraint reasoning, and human-in-the-loop explanation. |
| **Astrodynamics & Physics** | **Vector Math 64 & Keplerian Mechanics** | Circular orbit propagation ($R = 6921\text{ km}, i = 53^\circ$), cylindrical shadow geometry, line-of-sight Earth occultation. |
| **Thermodynamics & Power** | **Stefan-Boltzmann Lumped Capacitance** | $dT/dt = \frac{1}{C}(Q_{\text{solar}} + Q_{\text{internal}} - \epsilon\sigma A T^4)$, battery charge/discharge rate, 68°C thermal cutoff. |
| **Networking & Topology** | **ISL Optical Mesh & Ground Feeder** | 10 Gbps inter-satellite laser links, 10 physical Earth ground stations (Svalbard, Madrid, Singapore, etc.). |
| **Security & Cryptography** | **SHA-256 Hash Chain** | Tamper-evident ledger linking every scheduling and migration decision into an immutable block sequence. |

---

## 🖥️ Mission Control Console Screens

1. **🛰️ Constellation Map (3D Globe & 2D Mercator)**:
   - Interactive 3D spherical Earth rotating in real-time with night-side city lights and atmospheric limb glow.
   - 72 Walker-delta satellites (6 planes × 12 slots).
   - **Green Nodes**: Active laser mesh crosslink nodes.
   - **Red Nodes**: Unlinked nodes (undergoing gimbal slew, polar crossings, or power recovery).
   - **Electric Blue Beams**: High-speed (10 Gbps) ground station downlink passes.
2. **⚡ Workloads & Jobs**: Submit batch/real-time compute jobs, view priority queues, inspect interactive timeline bars with checkpoint markers, and track live migration hops.
3. **📊 Satellite Telemetry & Forecast**: Dedicated aerospace flight console with 3-hour lookahead curves for Battery SoC % (20% emergency reserve line), core thermal curves (68°C throttle threshold), and laser crosslink schedules.
4. **⚠️ Fault Injection Engine**: Color-coded by severity (**HIGH / CRITICAL** in Red, **MEDIUM** in Amber, **LOW** in Emerald). Manually inject Radiation SEU bit-flips, Laser Link Drops, Thermal Spikes, or Satellite Power Outages and observe autonomous re-planning.
5. **🤖 Gemini Operator Assistant**: Natural language policy interface with instant constraint parsing, impact previews, and operator confirmation gates.
6. **🔗 Cryptographic Decision Ledger**: Append-only log recording every placement, migration, and preemption decision with SHA-256 hash validation.
7. **📈 Benchmark Suite**: Multi-seed algorithmic comparisons evaluating Orbit Lookahead against **Round-Robin**, **Greedy Least-Loaded**, and **No-Migration** baseline strategies.

---

## 🚀 Local Development Quickstart

### Prerequisites
- [Flutter 3.47+](https://docs.flutter.dev/get-started/install) (Dart 3.13+)
- [Serverpod CLI 3.4+](https://docs.serverpod.dev)

### 1. Clone the Repository
```powershell
git clone https://github.com/DevSanjay09/Orbit-scheduler.git
cd Orbit-scheduler
```

### 2. Start the Serverpod Backend Server
```powershell
cd orbit_scheduler_server
dart pub get
dart bin/main.dart
```
*The backend API server starts at `http://localhost:8088/`.*

### 3. Start the Flutter Mission Control Client
In a new terminal:
```powershell
cd orbit_scheduler_flutter
flutter pub get
flutter run -d chrome
# Or native desktop: flutter run -d windows
```

### 4. Run the Full End-to-End Verification Test
```powershell
cd orbit_scheduler_server
dart run test/verify_prototype.dart
```

---

## 📜 License
This project is open-source and available under the [MIT License](LICENSE).
