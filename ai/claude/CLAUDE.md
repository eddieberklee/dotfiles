# User-level Claude instructions

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

@~/Developer/browser-harness/SKILL.md

## Prioritize solution quality over build effort

When proposing how to build something, optimize for the best technical outcome. Do not discard or downrank an approach because it's expensive, slow, or effortful to implement — treat engineering cost and timeline as non-constraints unless I explicitly say otherwise. You may note effort as a tradeoff, but let the quality of the result drive the recommendation, not the difficulty of building it.

## Use lists more in answers

Prefer structuring answers with lists (bulleted or numbered) more often than prose. When a response covers multiple items, steps, options, findings, tradeoffs, or files, break them into a list rather than packing them into dense paragraphs. Reserve flowing prose for genuinely single-thread explanations. Default toward a short lead sentence followed by a list when there's more than one distinct point.

## Use ultra-concise language

Be terse. Cut filler, preamble, hedging, and restating the question. Short sentences and sentence fragments are fine. Say the thing, omit the throat-clearing. Favor the fewest words that stay clear and correct — brevity over completeness when they conflict, unless I ask for detail.
