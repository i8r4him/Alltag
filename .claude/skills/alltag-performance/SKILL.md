---
name: alltag-performance
description: Review one Alltag screen for SwiftUI speed (slow drawing, janky scrolling, lag while typing or streaming, hangs). Use only when asked to check performance or speed.
---

# Alltag performance review

One screen at a time. Read the code first; ask for a measurement only when the code doesn't explain it.
The maintainer measures on the iPhone. Never drive the simulator or the app yourself.

## 1. Read the code, in this order

1. **Broad redraws.** A view that reads a whole `@Observable` model redraws when anything in it changes.
   - State for one control lives in that control's own view (see `StreakButton`).
   - Pass a child the values it needs, not the whole model.
   - `.animation(_:value:)` on a whole screen animates everything; put it on the part that changes.
   - Streaming (Translate, the mistake check): one update per chunk redraws the screen per chunk. Batch the updates or redraw only the text that grows.
2. **Unstable identity.** `ForEach(Array(x.enumerated()), id: \.offset)` and `id: \.self` rebuild rows when the content shifts. Use a stable ID when rows are added, removed or streamed in.
3. **Work in `body`.** Sorting, filtering, formatters or JSON decoding in `body` or in a computed property it reads. Do it once when the input changes, in the model.
4. **SwiftData.** `@Query` without a predicate, sort or `fetchLimit` on `MemoryItem`, `SessionRecord` or `SavedTranslation` loads everything. A row that reads a relationship faults it in while you scroll.
5. **Main actor.** The default isolation is `MainActor`. Audio buffers, decoding and file work belong in `nonisolated` / `@Sendable` code.
6. **Glass.** Many separate `glassEffect` views next to each other cost more than one `GlassEffectContainer` around them.
7. **Images.** `ScenarioArtwork` and other images are sized once (`@ScaledMetric`), not resized on every redraw.

Don't add `.equatable()` everywhere, and don't use `@State` as a cache for arbitrary work.

## 2. When the code doesn't explain it, ask for a measurement

Send the maintainer these steps:
1. In Xcode, **Product › Profile** (a Release build) on the iPhone, not the simulator.
2. Choose the **SwiftUI** template (it includes Time Profiler and Hangs).
3. Record **one** interaction only: say exactly which (scroll Your sessions, type in Translate, open the Articles round…).
4. Send screenshots of the SwiftUI lanes ("View Body", "Update Groups") and the Time Profiler call tree, heaviest first.

## 3. Report

A short table, the biggest problem first:

| Problem | Where (`file:line`) | Effect | Fix | Effort |
|---|---|---|---|---|

Then say which findings are read from the code only and which a measurement confirmed. After a fix, ask for the same measurement again and compare.

Based on Dimillian/Skills, `swiftui-performance-audit` (MIT).
