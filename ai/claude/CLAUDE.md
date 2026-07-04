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

## Worktrees

When asked where to create git worktrees, prefer the project-local hidden directory `.worktrees/`.

## gstack

Installed globally at `~/.claude/skills/gstack`. **Use gstack's `/browse` skill for all web browsing. Never call `mcp__claude-in-chrome__*` tools — route all browser automation through `/browse` instead.**

Available gstack slash commands:
`/office-hours`, `/plan-ceo-review`, `/plan-eng-review`, `/plan-design-review`, `/design-consultation`, `/design-shotgun`, `/design-html`, `/review`, `/ship`, `/land-and-deploy`, `/canary`, `/benchmark`, `/browse`, `/connect-chrome`, `/qa`, `/qa-only`, `/design-review`, `/setup-browser-cookies`, `/setup-deploy`, `/retro`, `/investigate`, `/document-release`, `/codex`, `/cso`, `/autoplan`, `/plan-devex-review`, `/devex-review`, `/careful`, `/freeze`, `/guard`, `/unfreeze`, `/gstack-upgrade`, `/learn`.

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

When recapping finished work ("here's what I did", ship/status summaries), make it terse and scannable, not prose:
- Lead with a one-line headline, e.g. `Shipped to main: \`<sha>\`.`
- "What changed" = short **one-line** bullets, one idea each — not 1–2 sentence bullets.
- Collapse all verification into a single line: `Passed: tsc, eslint, tests, prod build, screenshot.` — never a sentence per check.
- Caveats / "cleanup later" = short one-line bullets.
- End with a one-line `Next:` if relevant.
- Backticks for shas, commands, filenames. Let the bullets carry it; minimal explanation.

## Mac menu bar apps: Dock icon by default

For all my mac menu-bar apps: show a regular Dock icon by default, plus a Settings toggle to hide the Dock icon while keeping the menu-bar item. Pattern: ship `LSUIElement: true`, then promote with `NSApp.setActivationPolicy(.regular)` at launch unless the user turned it off (persist in UserDefaults, default on).
