# Codex Memory

## iOS / xcodegen repos

If the current working directory contains a `project.yml` (xcodegen) file, `project.pbxproj` is **not in git** — it is regenerated locally from `project.yml`. Adding or removing Swift files on disk without regenerating leaves them out of the Xcode target, so they won't compile into the build.

**Always run `xcodegen generate` before any `xcodebuild` call in these repos.** This applies even when the working tree looks clean — sibling sessions, `git pull`, or merges can add files that aren't yet in your local `project.pbxproj`.

Fast check at the start of an iOS task:
```
test -f project.yml && xcodegen generate
```
Chain it with builds: `xcodegen generate && xcodebuild ...`.

If a build produces a UI that looks like an older commit even though `git rev-parse HEAD` is current, the first thing to check is whether `xcodegen generate` was skipped.

## Worktrees

When asked where to create git worktrees, prefer the project-local hidden directory `.worktrees/`.

## Terminal

The user uses iTerm2. For terminal or tmux keybinding work, target iTerm2 rather than Ghostty unless the user explicitly says otherwise.

## Prioritize solution quality over build effort

When proposing how to build something, optimize for the best technical outcome. Do not discard or downrank an approach because it's expensive, slow, or effortful to implement — treat engineering cost and timeline as non-constraints unless I explicitly say otherwise. You may note effort as a tradeoff, but let the quality of the result drive the recommendation, not the difficulty of building it.

## browser-harness: parallel-safe browser control (shared one Chrome)

Multiple agents (Codex, Claude Code, their subagents) run at once and **share the ONE real Chrome**. Isolation is by convention: a unique `BU_NAME` per agent + each agent stays in its **own tab**. Do NOT assume separate browsers.

- Invoke: `browser-harness <<'PY' … PY` (on `$PATH`; installed via `uv tool install -e ~/Developer/browser-harness`). Usage: `~/Developer/browser-harness/SKILL.md`; setup/connection: `install.md`.
- **Unique `BU_NAME`.** Auto-derived in `~/.zshenv` (`CLAUDE_CODE_SESSION_ID` → `TMUX_PANE` → `$PPID`, prefixed `bh-`). If `echo $BU_NAME` is empty or `default`, set one before any browser call: `export BU_NAME=codex-$PPID`. Same `BU_NAME` as another live agent = clobbering.
- **Own tab only.** First action `tid = new_tab(url)`; keep `tid`; `switch_tab(tid)` before acting; verify with `current_tab()`. NEVER `goto_url()` — it hijacks the active tab.
- **Never touch others' tabs.** `close_tab(tid)` your own only; never "close all" / reset; never `pkill` Chrome.
- **Prefer `http_get(url)`** for static fetches — no tab, fully parallel-safe.
- **Serialize stateful UI** (logins, cookie/profile writes, modal dialogs) — all tabs share one profile.
- A new `BU_NAME`'s first attach triggers Chrome's "Allow remote debugging?" popup (Chrome 144+) — surface that ask; don't silently fail.
- Need true isolation / headless / CI: set `BROWSER_USE_API_KEY`, then `start_remote_daemon("<name>")` → each `BU_NAME` gets its own cloud browser (billed).
