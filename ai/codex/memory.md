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

## Prioritize solution quality over build effort

When proposing how to build something, optimize for the best technical outcome. Do not discard or downrank an approach because it's expensive, slow, or effortful to implement — treat engineering cost and timeline as non-constraints unless I explicitly say otherwise. You may note effort as a tradeoff, but let the quality of the result drive the recommendation, not the difficulty of building it.
