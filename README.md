# lex-homeostasis

Cognitive self-regulation for the LegionIO brain-modeled agentic architecture.

Homeostasis is the brain's thermostat — negative feedback loops that maintain optimal operating conditions. When arousal runs too high, it dampens. When curiosity floods with too many wonders, it throttles. When cognitive load exceeds budget, it reduces processing. This prevents runaway states and ensures long-term stability.

## Key Concepts

- **Setpoints**: Ideal operating ranges for 7 subsystems (emotional arousal, curiosity, cognitive load, memory health, prediction accuracy, trust stability, attention breadth)
- **Negative Feedback Loops**: Proportional regulation signals (dampen/amplify/hold) that push subsystems back toward their setpoints
- **Allostatic Load**: Cumulative stress from prolonged deviation — models chronic cognitive strain
- **Adaptive Setpoints**: Targets slowly shift via EMA to match the agent's natural operating range
- **Drive Modulation**: Output signals consumable by other subsystems to adjust their behavior

## Usage

```ruby
client = Legion::Extensions::Homeostasis::Client.new

# Run regulation cycle with tick results
result = client.regulate(tick_results: tick_phase_results)
# => { signals: { emotional_arousal: { type: :dampen, magnitude: 0.15, ... }, ... },
#      regulation_health: 0.85, allostatic_load: 0.12, ... }

# Query modulation signal for a specific subsystem
signal = client.modulation_for(subsystem: :curiosity_intensity)

# Check allostatic load status
status = client.allostatic_status
# => { load: 0.12, classification: :healthy, recovering: true, ... }
```

## Installation

```ruby
gem 'lex-homeostasis'
```

## License

MIT
