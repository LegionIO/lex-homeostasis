# lex-homeostasis

**Level 3 Leaf Documentation**
- **Parent**: `/Users/miverso2/rubymine/legion/extensions-agentic/CLAUDE.md`
- **Gem**: `lex-homeostasis`
- **Version**: `0.1.1`
- **Namespace**: `Legion::Extensions::Homeostasis`

## Purpose

Cognitive self-regulation for LegionIO agents. Maintains seven internal setpoints and applies proportional negative feedback each tick to push deviating subsystems back toward their targets. Tracks cumulative allostatic load (chronic stress from sustained deviation) and emits modulation signals consumed by other extensions. Setpoints adapt slowly via EMA to reflect the agent's natural operating range.

## Gem Info

- **Require path**: `legion/extensions/homeostasis`
- **Ruby**: >= 3.4
- **License**: MIT
- **Registers with**: `Legion::Extensions::Core`

## File Structure

```
lib/legion/extensions/homeostasis/
  version.rb
  helpers/
    constants.rb          # Setpoints, thresholds, labels
    setpoint.rb           # Setpoint value object with EMA adaptation
    regulator.rb          # Multi-setpoint regulation loop
    allostatic_load.rb    # Cumulative load tracker
  runners/
    homeostasis.rb        # Runner module

spec/
  legion/extensions/homeostasis/
    helpers/
      constants_spec.rb
      setpoint_spec.rb
      regulator_spec.rb
      allostatic_load_spec.rb
    runners/homeostasis_spec.rb
  spec_helper.rb
```

## Key Constants

```ruby
SETPOINTS = {
  emotional_arousal:   { target: 0.4, tolerance: 0.15, gain: 0.3 },
  curiosity_intensity: { target: 0.5, tolerance: 0.2,  gain: 0.25 },
  cognitive_load:      { target: 0.6, tolerance: 0.2,  gain: 0.2 },
  memory_health:       { target: 0.7, tolerance: 0.15, gain: 0.35 },
  prediction_accuracy: { target: 0.6, tolerance: 0.2,  gain: 0.3 },
  trust_stability:     { target: 0.7, tolerance: 0.2,  gain: 0.25 },
  attention_breadth:   { target: 0.5, tolerance: 0.2,  gain: 0.2 }
}

ALLOSTATIC_LOW_THRESHOLD    = 0.3
ALLOSTATIC_HIGH_THRESHOLD   = 0.6
ALLOSTATIC_CRITICAL_THRESHOLD = 0.85

REGULATION_HEALTH = {
  (0.8..)     => :excellent,
  (0.6...0.8) => :good,
  (0.4...0.6) => :fair,
  (0.2...0.4) => :poor,
  (..0.2)     => :critical
}
```

## Helpers

### `Helpers::Setpoint` (class)

Tracks one regulated variable over time.

| Method | Description |
|---|---|
| `update(value)` | records current value; computes deviation from target |
| `within_tolerance?` | true if absolute deviation <= tolerance |
| `deviation_ratio` | deviation / tolerance (>1.0 means out of range) |
| `adapt_target` | EMA-shifts target toward recent observed values |
| `trend` | linear slope of last N values (positive = rising) |

### `Helpers::Regulator` (class)

Holds a Setpoint per monitored subsystem; computes regulation cycle output.

| Method | Description |
|---|---|
| `regulate(observations)` | updates all setpoints from observation hash; returns signal hash |
| `health_label` | overall regulation health (:excellent..:critical) from avg deviation |
| `worst_deviation` | subsystem with highest deviation_ratio |
| `adapt_setpoints` | calls adapt_target on all setpoints |

Regulation signal format per subsystem:
```ruby
{ type: :dampen|:amplify|:hold, magnitude: Float, subsystem: Symbol }
```

### `Helpers::AllostaticLoad` (class)

Cumulative stress tracker updated each regulate cycle.

| Method | Description |
|---|---|
| `update(regulator)` | accumulates deviation from all out-of-range setpoints; decays load when in-range |
| `classification` | :healthy / :elevated / :high / :critical based on thresholds |
| `trend` | slope of recent load history |
| `recovering?` | true if load is decreasing over recent ticks |

## Runners

Module: `Legion::Extensions::Homeostasis::Runners::Homeostasis`

Private state: `@regulator` (memoized `Regulator`) and `@allostatic_load` (memoized `AllostaticLoad`).

Observation extraction from `tick_results`:
- `emotional_arousal` — from `tick_results[:emotional_evaluation][:arousal]`
- `cognitive_load` — from `elapsed / budget` ratio in tick timing
- `memory_health` — from `tick_results[:memory_consolidation][:health]`
- `prediction_accuracy` — from `tick_results[:prediction_engine][:accuracy]`
- `trust_stability` — from `tick_results[:identity_entropy_check][:stability]`
- `curiosity_intensity` and `attention_breadth` — from respective tick phases

| Runner Method | Parameters | Description |
|---|---|---|
| `regulate` | `tick_results: {}` | Full regulation cycle; returns signals, health, allostatic load |
| `modulation_for` | `subsystem:` | Return the last regulation signal for a specific subsystem |
| `allostatic_status` | (none) | Load value, classification, trend, recovering? |
| `regulation_overview` | (none) | All setpoint current values, deviations, and regulation health |
| `homeostasis_stats` | (none) | Summary: health label, allostatic classification, worst deviation |

## Integration Points

- **lex-tick**: `regulate` is called in the `post_tick_reflection` or a dedicated homeostasis phase with the full tick_results hash.
- **lex-emotion**: `emotional_arousal` observation sourced from lex-emotion's `evaluate_valence` output; regulation dampens/amplifies arousal drive.
- **lex-curiosity**: `curiosity_intensity` observation from detect_gaps output; regulation throttles wonder formation when curiosity is chronically elevated.
- **lex-habit**: lower `cognitive_load` through habit execution is the indirect path: automatic habits free up cognitive budget, which homeostasis observes.
- **lex-metacognition**: `Homeostasis` is listed under `:cognition` capability category.

## Development Notes

- Observations are extracted from `tick_results` keys; if a phase did not run (missing key), that setpoint is not updated for that tick.
- Regulation signals are proportional: `magnitude = (deviation / tolerance) * gain`. Signals above 1.0 are not clamped — callers should interpret >1.0 as "urgent correction needed".
- `adapt_setpoints` is called automatically at the end of `regulate`; setpoint targets drift slowly via EMA (alpha derived from REGULATION_GAIN).
- AllostaticLoad accumulates additively when setpoints are out of range and decays multiplicatively when all are in range. Critical load does not automatically reset the agent.
- No actor; `regulate` is driven by the tick cycle.
