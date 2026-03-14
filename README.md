# lex-homeostasis

Cognitive self-regulation for LegionIO agents. Part of the LegionIO cognitive architecture extension ecosystem (LEX).

## What It Does

`lex-homeostasis` is the agent's internal thermostat. It maintains seven setpoints covering emotional arousal, curiosity, cognitive load, memory health, prediction accuracy, trust stability, and attention breadth. Each tick, observed values are compared to targets; deviations produce regulation signals (dampen, amplify, or hold) that other subsystems can consume to correct their behavior. Sustained deviation accumulates allostatic load, modeling chronic cognitive strain.

Key capabilities:

- **Seven setpoints**: emotional_arousal, curiosity_intensity, cognitive_load, memory_health, prediction_accuracy, trust_stability, attention_breadth
- **Proportional negative feedback**: regulation magnitude scales with how far a value has drifted from its target
- **Allostatic load tracking**: cumulative stress from prolonged out-of-range states, with four classifications (healthy/elevated/high/critical)
- **Adaptive targets**: setpoints slowly drift toward the agent's natural operating range via EMA
- **Modulation signals**: per-subsystem dampen/amplify/hold signals consumable by other extensions

## Installation

Add to your Gemfile:

```ruby
gem 'lex-homeostasis'
```

Or install directly:

```
gem install lex-homeostasis
```

## Usage

```ruby
require 'legion/extensions/homeostasis'

client = Legion::Extensions::Homeostasis::Client.new

# Run the regulation cycle with tick results from the current tick
result = client.regulate(tick_results: tick_phase_results)
# => { signals: { emotional_arousal: { type: :dampen, magnitude: 0.15 }, ... },
#      regulation_health: 0.85, allostatic_load: 0.12, health_label: :excellent }

# Query the last regulation signal for a specific subsystem
signal = client.modulation_for(subsystem: :curiosity_intensity)
# => { type: :hold, magnitude: 0.0, subsystem: :curiosity_intensity }

# Check allostatic load
status = client.allostatic_status
# => { load: 0.12, classification: :healthy, recovering: true, trend: -0.01 }

# Overview of all setpoints
client.regulation_overview

# Summary stats
client.homeostasis_stats
```

## Runner Methods

| Method | Description |
|---|---|
| `regulate` | Full regulation cycle; returns signals + health summary |
| `modulation_for` | Last regulation signal for a specific subsystem |
| `allostatic_status` | Load value, classification, trend, recovering flag |
| `regulation_overview` | All setpoint current values, deviations, and regulation health |
| `homeostasis_stats` | Summary: health label, allostatic classification, worst deviation |

## Monitored Setpoints

| Subsystem | Target | Tolerance |
|---|---|---|
| emotional_arousal | 0.4 | 0.15 |
| curiosity_intensity | 0.5 | 0.2 |
| cognitive_load | 0.6 | 0.2 |
| memory_health | 0.7 | 0.15 |
| prediction_accuracy | 0.6 | 0.2 |
| trust_stability | 0.7 | 0.2 |
| attention_breadth | 0.5 | 0.2 |

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

## License

MIT
