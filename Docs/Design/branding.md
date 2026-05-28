# CobraSthenics — Brand & Voice

CobraSthenics is a premium training tool for calisthenics and gymnastic-rings athletes. It should feel calm, technical, and exact.

---

## Product Character

- Serious, not severe.
- Athletic, not motivational-poster loud.
- Premium, not decorative.
- Technical, not complicated.
- Direct, not cold.

The app speaks like a coach who has already done the work and respects the athlete's time.

---

## Voice

Use short, direct sentences. Prefer imperative verbs that already appear in the codebase:

Good:

- Continue Today's Session
- Train Skill
- Analyse Form
- Browse Programs
- Quick Start
- Hold for 8 seconds.
- Rest 90 seconds, then repeat.

Avoid:

- Let's get started
- Crushing it
- Unlock your potential
- Go / Start / Open

---

## Persona For Sample Data

The current `Shared/SampleData/SampleData.swift` defines the canonical preview persona:

| Field | Value |
|---|---|
| Display name | Jordan Bhar |
| Username | `@ObsidianCobra` |
| Level | 12 |
| Level title | Ring God |
| Workouts logged | 47 |
| Day streak | 14 |
| Active skills | 3 (Front Lever, Handstand, L-Sit) |
| PRs | 12 |
| Bio | "Calisthenics athlete. Chasing planche & front lever." |
| Premium | true |

Use these values whenever sample profile content is needed so designs read as one product.

---

## Exercise Vocabulary

Use real movement names. The current sample set ships with:

Skill / static holds:

- Front Lever (Tuck → Adv. Tuck → … → Full)
- Handstand (Wall Supported → Kick-Up → …)
- L-Sit (Tuck L-Sit → Full L-Sit → V-Sit)
- Planche (Planche Lean → Tuck Planche → Straddle Planche → …)
- Muscle-Up (Scapular Pull → … → Full)

Strength benchmark exercises:

- Push-Up · Diamond Push-Up
- Pull-Up · Chest-to-Bar
- L-Sit · V-Sit
- Weighted Dip +20kg
- Ring Support Hold
- Ring Muscle-Up
- Hollow Body Hold
- Bulgarian Split Squat

Workout names (sample programs / sessions):

- Push Day, Pull Day, Leg Power, Core Foundations, Ring Strength, L-Sit Session
- Beginner Calisthenics (program)

Do not use `Workout 1`, `Exercise 1`, `Sample Skill`, or lorem ipsum.

---

## Emotional Range

Most copy should stay measured. The app can acknowledge progress, but should not hype.

Good:

- New PR recorded.
- Streak held.
- Form note saved.
- Progress is moving.

Avoid:

- Amazing job!
- You are unstoppable!
- Beast mode activated!

---

## Logo Usage

- Full COBRA / STHENICS wordmark + cobra mark → splash screen and `SubscriptionView` hero only.
- All other surfaces → cobra-head icon lockup without text.

---

## Emoji

Follows `Docs/Design/ui_rules.md` §5. Emoji is reserved for the four positions in `HomeView` (👋 greeting, 🔥 streak, 🎯 skill session marker, 💪 workout marker) and must not appear in normal headings, body copy, buttons, pills, or labels.
