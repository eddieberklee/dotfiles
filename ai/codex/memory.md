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

For tmux window movement, use `swap-window -d -t :-1` and `swap-window -d -t :+1`: omitting `-d` keeps focus at the original index instead of on the moved window.

The portable iTerm2 keymap and its setup guide live at `~/dotfiles/iterm/tmux-window-move.itermkeymap` and `~/dotfiles/iterm/README.md`.

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

## Mac apps needing TCC permissions: sign with a stable identity

Any macOS app I build that needs **Accessibility, Screen Recording, or Input Monitoring** must be signed with a **stable identity** — my Apple Development cert (team `6643C3LRJA`) or a Developer ID — **never ad-hoc** (`CODE_SIGN_IDENTITY: "-"`).

Why: TCC binds a grant to the app's Designated Requirement. Ad-hoc → the DR is a literal cdhash that changes every rebuild, so each rebuild looks like a new app and the permission resets (re-grant every build). A real cert → cert-based DR (bundle id + cert) that survives rebuilds, so the grant sticks.

- `project.yml`/build settings: `CODE_SIGN_IDENTITY: "Apple Development"`, `CODE_SIGN_STYLE: Manual`, `DEVELOPMENT_TEAM: 6643C3LRJA` (local macOS dev needs NO provisioning profile).
- Install with `ditto` (preserves the signature; `cp`/`rsync` can break it); keep ONE canonical copy in `/Applications` and run it from there (stray DerivedData/worktree copies make duplicate TCC rows).
- Verify: `codesign -d --requirements - "<App>"` shows a cert-based `designated =>` (has `certificate leaf[subject.CN] = "Apple Development…"`), not cdhash/adhoc.
- Broken grant recovery: `tccutil reset Accessibility <bundleid>` (and `ScreenCapture`/`ListenEvent`), reopen, re-grant once. Accessibility is only re-read on relaunch (quit & reopen).
