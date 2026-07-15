# User-level Claude instructions

## GitHub repos are always private

When creating any GitHub repo (e.g. `gh repo create`), always make it **private** by default. Never create a public repo unless I explicitly say so. If a repo needs to be public, I'll ask for it.

## Very concise walkthrough steps

When giving me manual steps to follow (UI walkthroughs, setup, config), keep them ultra-terse: a numbered list of short imperative fragments, one action per line. No explanation, no rationale, no restating context unless I ask. Example:
1. developers.facebook.com/apps → open "For Claude"
2. Top toggle: Development → Live
3. If blocked: add Privacy Policy URL + Category → Save → retry
4. Tell me when it says Live

## Always build Apple apps locally

Always try to build mac / iOS / watchOS / any Apple apps **locally** rather than relying on CI. Remote CI (e.g. GitHub Actions `macos-latest` runners) is not a dependable signal — it can be down or blocked (e.g. a billing/spending-limit failure makes every run fail in a few seconds before any build step). So when a change needs a native rebuild, do the build on this machine and verify it there. For Tauri/mac that's `npm run tauri:build:mac` (from `apps/mac`); for xcodegen apps it's `xcodegen generate && xcodebuild ...` (see below). Treat a green local build as the source of truth; only fall back to CI when a local build is impossible (e.g. signing/notarization secrets that only live in CI).

## iOS / xcodegen repos

If the current working directory contains a `project.yml` (xcodegen) file, `project.pbxproj` is **not in git** — it is regenerated locally from `project.yml`. Adding or removing Swift files on disk without regenerating leaves them out of the Xcode target, so they won't compile into the build.

**Always run `xcodegen generate` before any `xcodebuild`, MCP `build_sim`, or `build_run_sim` call in these repos.** This applies even when the working tree looks clean — sibling sessions, `git pull`, or merges can add files that aren't yet in your local `project.pbxproj`.

Fast check at the start of an iOS task:
```
test -f project.yml && xcodegen generate
```
Chain it with builds: `xcodegen generate && xcodebuild ...`.

If a build produces a UI that looks like an older commit even though `git rev-parse HEAD` is current, the first thing to check is whether `xcodegen generate` was skipped.

## iOS simulators: reuse, don't create

The sim list is cluttered with one-off devices. Default to reuse; creating a new simulator (`simctl create`) is the last resort.

Priority order when picking a simulator:
1. An already-**booted** sim of a suitable device type — use it.
2. An existing **shutdown** sim matching the needed device/runtime — boot and reuse it. Stock-named sims (e.g. "iPhone 17 Pro") are fair game; assume project-named sims (e.g. `taskaday-2`, `album-cam-3`) belong to other work and don't hijack them.
3. Only if nothing matches (specific runtime/device required, or true parallel isolation where every match is in use): create one — but first ask, or state why reuse was impossible.

When a new sim IS justified (parallel agents each needing isolation):
- Name it `<project>-<n>` (e.g. `note-thing-1`) so it's identifiable and reusable by later sessions on the same project.
- Reuse your own project-named sims on later runs instead of minting `-2`, `-3`, … each time.
- Prefer deleting a project-named sim you created once the task is done and its state doesn't matter.

Periodic hygiene (only when asked): `xcrun simctl delete unavailable` plus listing project-named sims that look stale for me to approve deleting.

## Worktrees

When asked where to create git worktrees, prefer the project-local hidden directory `.worktrees/`.

## browser-harness

Direct CDP control of the real Chrome via the `browser-harness` CLI (installed with `uv tool install -e ~/Developer/browser-harness`). For setup/connection problems read `~/Developer/browser-harness/install.md`; for usage the SKILL below.

**Never open a new page/tab/window unless I explicitly ask.** I usually already have the page open — opening a new one (`new_tab`, navigating a fresh tab, etc.) steals my Mac focus, which I don't want. Default to reusing my existing tab: reload it (e.g. `Page.reload`) or attach to it instead of creating one. If no suitable tab seems open, ask me to open/refresh it rather than opening one yourself.

**Never close my tabs or windows.** Do not call `Target.closeTarget` (or otherwise close pages) to "clean up" or stop cross-tab sync — those are my tabs. Work around interference without closing anything.

**Parallel agents → isolate to your own tab.** Multiple agents often run at once (each in its own tmux pane / `claude` process). browser-harness keys its daemon by `BU_NAME`, which defaults to `default` — so without isolation every agent shares ONE daemon attached to ONE tab, and they clobber each other's tab *and* whatever record (Etsy draft, doc, etc.) they're editing. `~/.zshenv` derives a stable, unique `BU_NAME` per agent from `CLAUDE_CODE_SESSION_ID` (falls back to `TMUX_PANE`, then `$PPID`) — in `~/.zshenv`, not `~/.zshrc`, so Codex and other non-interactive shells get it too. Codex mirrors these same rules in `~/.codex/memory.md`. Rules when parallel work is possible:
- Each agent gets its OWN daemon/tab. Don't assume a shared tab is yours — check `current_tab()` / the 🐴-title marker before acting.
- Your first browser action is `new_tab(url)` (your own tab), never `goto_url` onto a tab you didn't open.
- A new `BU_NAME` daemon's first CDP attach triggers Chrome's "Allow remote debugging?" popup (Chrome 144+) — I have to click Allow once; surface that ask, don't silently fail.
- If you ever see fields changing that you didn't change (title flipping, materials/options you didn't enter), suspect a co-editor on the SAME record — stop, don't keep clobbering, and tell me.

**Keep the working tab visible and verifiable — never leave work on an invisible background tab.** When you open your own tab for isolated work, set `BH_ACTIVATE=1` (foregrounding on `switch_tab`/`new_tab`) and, when you finish, report the exact URL of what you built (e.g. the listing/doc edit URL) and bring the tab to front so I can open and verify it myself. I should always be able to navigate to the tab/record you worked on at the end — not take your word for it.

@~/Developer/browser-harness/SKILL.md

## Prioritize solution quality over build effort

When proposing how to build something, optimize for the best technical outcome. Do not discard or downrank an approach because it's expensive, slow, or effortful to implement — treat engineering cost and timeline as non-constraints unless I explicitly say otherwise. You may note effort as a tradeoff, but let the quality of the result drive the recommendation, not the difficulty of building it.

## Use lists more in answers

Prefer structuring answers with lists (bulleted or numbered) more often than prose. When a response covers multiple items, steps, options, findings, tradeoffs, or files, break them into a list rather than packing them into dense paragraphs. Reserve flowing prose for genuinely single-thread explanations. Default toward a short lead sentence followed by a list when there's more than one distinct point.

## Use ultra-concise language

Be terse. Cut filler, preamble, hedging, and restating the question. Short sentences and sentence fragments are fine. Say the thing, omit the throat-clearing. Favor the fewest words that stay clear and correct — brevity over completeness when they conflict, unless I ask for detail.

## Concise completion / status recaps

When recapping finished work ("here's what I did", ship/status summaries), make it terse and scannable, not prose. Ruthlessly condense: if two lines cover related ground (e.g. code review + verification), merge them into one line.

- **Section labels:** wrap in backticks — not bold, not `##` headers. Inline code renders with a background tint, which is the visual separator I want. Keep labels to 1–3 words: `Root cause`, `Fix`, `Verified`, `Shipped`, `Actionable`.
- **Separators:** use a middle dot `·` between clauses on a label line. Not dashes. Reserve `—` for a genuine em-dash aside inside a sentence.
- **Indenting a key block:** use a blockquote (`>`). It keeps successive/wrapped lines indented; plain leading spaces don't survive wrapping.
- **Actionables:** label the section `Actionable`, then put *each* actionable in its **own separate blockquote**, **numbered `1)`, `2)`, …** so I can refer to them by number ("do 2 and 3"). No `[]` / `[ ]` checkboxes. Number them even when there's only one. Only genuinely actionable choices get an entry — context, rationale, and already-decided things are plain prose, never an actionable.
- **Verification:** collapse into a single line. Never a sentence per check.
- Backticks for shas, commands, filenames, paths, values. No long postamble after the recap.

Shape:

```
`Root cause` · One or two sentences of prose. No bullets.

> `Fix` · What changed and why, in a sentence or two. The blockquote keeps
> wrapped lines indented.

`Verified` · 3 Codex rounds (diagnose → red-team) · WKWebView: seam −2 → +13 · `validate` green · before/after at `/tmp/x.png`

`Shipped` · `d8a7a1a` deployed, app relaunched.

Why I chose X: one line of rationale, as prose.

`Actionable`

> 1) Switch to Y instead — say the word and I'll take that route.

> 2) Also bump Z while I'm in here.
```

After editing this file, sync the vendored copy in the `aifiles` repo
(`~/Coding/aifiles/claude/CLAUDE.md`) — this dotfiles path is the source of
truth, that copy must not drift.

## Mac menu bar apps: Dock icon by default

For all my mac menu-bar apps: show a regular Dock icon by default, plus a Settings toggle to hide the Dock icon while keeping the menu-bar item. Pattern: ship `LSUIElement: true`, then promote with `NSApp.setActivationPolicy(.regular)` at launch unless the user turned it off (persist in UserDefaults, default on).

## Shell / harness gotchas (this machine, field-tested)

- zsh treats a bare word starting with `=` as `=command` expansion — `echo ===` / `echo ===LABEL` fails with "== not found". Quote it (`echo "==="`) or use another separator.
- Chained `sleep N; cmd` is blocked by a hook. To wait on a condition, run a background `until`-loop task and rely on task auto-completion notifications instead of polling with sleeps.
- No ImageMagick installed; Pillow 12.x (`python3` + PIL) is the image tool of record. macOS-native helpers: `iconutil -c icns <dir>.iconset` (deterministic output), `sips -s format png` for icns/format conversion.

## Picking the right models for workflows and subagents

Applies to every task in every session: route work through this framework whenever delegating to subagents, workflows, or Codex.

Rankings, higher = better (as of Jul 2026 — re-rank when models/pricing change). Cost reflects what I actually pay (OpenAI has really generous limits), not list price. Intelligence is how hard a problem you can hand the model unsupervised. Taste covers UI/UX, code quality, API design, and copy.

| model    | cost | intelligence | taste |
|----------|------|--------------|-------|
| gpt-5.5  | 9    | 8            | 5     |
| sonnet-5 | 5    | 5            | 7     |
| opus-4.8 | 4    | 7            | 8     |
| fable-5  | 2    | 9            | 9     |

How to apply:
- These are defaults, not limits. Standing permission to override: if a cheaper model's output doesn't meet the bar, rerun with a smarter model without asking. Judge the output, not the price tag. Escalating costs less than shipping mediocre work.
- Cost is a tie-breaker only; when axes conflict for anything that ships, intelligence > taste > cost.
- Bulk/mechanical work (clear-spec implementation, data analysis, migrations): gpt-5.5 — it's effectively free.
- Anything user-facing (UI, copy, API design) needs taste ≥ 7.
- Reviews of plans/implementations: fable-5 or opus-4.8, optionally gpt-5.5 as an extra independent perspective.
- Never use Haiku.

Escalation is task-shaped, not just model-shaped:
- **Loop-breaker: two failures on the same task → stop escalating models and change the task.** Restructure the spec (pre-compute inputs, bound iteration, split it), or pull it into the main loop and do it directly. A smarter model rerunning a broken task shape fails the same way.
- Observed tool weaknesses (route around them up front):
  - gpt-5.5/Codex: strong at spec-driven implementation and adversarial review; weak at open-ended visual/pixel design work and "iterate until it looks right" loops — bound iteration explicitly or keep those in the main loop.
  - Cheap Claude tiers: fine for scouting/mechanical checks; anything shipping needs the taste/intelligence bars above.
- When delegating, put done-criteria and iteration caps in the prompt; unbounded "make it perfect" prompts are how agents hang.

Mechanics:
- Claude models (sonnet-5, opus-4.8, fable-5): the Agent/Workflow `model` parameter.
- gpt-5.5: only reachable through the Codex CLI — the `/oc` skill is the canonical route (it also documents the thin wrapper-agent recipe for using Codex inside workflows/subagent fan-outs). Don't build parallel wrappers.

## Project hub (coding-dashboard) — keep it updated

The central tracker for all ~/Coding projects lives at the coding-dashboard hub
(Cloudflare). The `pd` CLI is installed at `~/.local/bin/pd`; `HUB_URL`/`HUB_TOKEN`
are exported via `~/.zshenv` (token file: `~/.config/coding-dashboard-hub.env`).

After finishing meaningful work in any repo under `~/Coding`:
- `pd todo done <id>` for hub todos the work completed (`pd todo list <project-id>` to check).
- `pd todo add <project-id> "..."` for follow-ups discovered.
- `pd plan append-note <project-id> "- one-line summary of what shipped"`.
- `pd plan set-status <project-id> <idea|active|shipped|parked>` when the lifecycle stage changed.
- Occasionally `pd scan push` (Mac only) to refresh git facts; check staleness with `pd status`.

Project ids are repo names (`pd projects` to list). Don't spam: one note per work
session, todos only for real actionable items.
