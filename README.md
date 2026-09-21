# S2P Strategy Builder: install guide

**S2P Strategy Builder** (plugin ID `s2p-strategy`) is a Claude Code plugin. It derives three
things from a business function: an agentic transformation strategy, a use case portfolio and a
build recommendation. It runs three commands, and each one stops at gates where a person has to
make the ruling.

This repository holds **released versions only**. It is generated from the author's source, so
don't edit it here; send suggestions to the author instead. Use is governed by `LICENSE`: you
may use it because you were invited, and you may not pass it on.

## ⛔ The one rule

**On a personal laptop, the method only ever sees synthetic data.** Real client or employer
information belongs on your work machine, under your employer's approved tools, and it never
comes back. That holds for files, paste, sync and screenshots alike. The method is built so
that you can prove it on invented data here and run it on real data at work.

## On your personal laptop (Claude Code)

**You need:**
- Claude Code.
- A GitHub account that has been given access to this repository. **This repository is
  private**: accept the collaborator invitation GitHub emails you before anything else.
- **Git for Windows** (on Windows). The plugin's hooks run in `bash`, which Git for Windows
  provides as Git Bash. Without it the hooks fail and the progress page never renders.
- **Git signed in to GitHub.** Claude Code installs through your own git credentials. Check in a
  terminal first:

  ```bash
  git ls-remote https://github.com/Gerhardcvdm/S2P_Strategy_Builder
  ```

  If it prints a list of refs, you're ready. If it opens a browser, sign in once; Git for Windows
  remembers it. If it says *not found*, the invitation hasn't been accepted yet. (`gh auth login`
  works too.)

**Once, in `~/.claude/settings.json`,** add this so the plugin keeps working when Claude Code's
background update check can't sign in to a private repository. It can't, by design; you update
by hand instead, below.

```json
{ "env": { "CLAUDE_CODE_PLUGIN_KEEP_MARKETPLACE_ON_FAILURE": "1" } }
```

If the file already has content, merge the `env` entry in rather than replacing the file.

**Install**, inside Claude Code:

```
/plugin marketplace add Gerhardcvdm/S2P_Strategy_Builder
/plugin install s2p-strategy@s2p-strategy-builder
```

**Update** when a new version is announced:

```
/plugin marketplace update s2p-strategy-builder
```

**What you get:**

| | |
|---|---|
| `/s2p-strategy:build-strategy` | Function → strategy paper. Start here |
| `/s2p-strategy:build-portfolio` | Strategy → a ranked use case portfolio and a first proof |
| `/s2p-strategy:build-recommendation` | Portfolio → the build recommendation for the sponsor |
| `strategy-critic`, `stakeholder-proxy` | Reviewer agents the commands call at each step |
| Skills | The method itself, loaded when a command or a question needs them |
| Hooks | A close-out check before compaction, re-reading `handoff.md` after `/clear`, and re-rendering `RUN-PROGRESS.html` after every turn |

**Starting a run.** Make an empty folder, run `git init` in it, and copy in the intake form:

```bash
mkdir my-run && cd my-run && git init
cp ~/.claude/plugins/marketplaces/s2p-strategy-builder/templates/intake.md intake.md
```

Fill in `intake.md`, start Claude Code in that folder and run `/s2p-strategy:build-strategy`.

**Where to look:**
- `RUN-PROGRESS.html` in your run folder shows where the run stands. It rewrites itself after
  every turn.
- `wiring-the-method.html` in this repository shows how the commands, skills, agents and hooks
  connect. Open it on GitHub, or locally from
  `~/.claude/plugins/marketplaces/s2p-strategy-builder/`.

## On the work laptop (no Claude Code)

The work side gets the same release in a repository under your **work** GitHub account. It is
filled by pulling from here **on the work laptop**, so no personal credentials ever sit on the
work machine and no work credentials ever sit on a personal one.

**Once:**

1. On the work laptop, make a key that exists only for this:
   `ssh-keygen -t ed25519 -f ~/.ssh/s2p_strategy_release -C "S2P Strategy Builder release, read-only"`
2. Send the **public** half (`s2p_strategy_release.pub`, which is not secret) to the maintainer of
   this repository. They add it as a **read-only deploy key**, which opens this one repository
   and nothing else.
3. Create an empty private repository in your work account, then:

```bash
git clone --mirror git@github.com:Gerhardcvdm/S2P_Strategy_Builder.git s2p-strategy-builder.git \
  --config core.sshCommand="ssh -i ~/.ssh/s2p_strategy_release -o IdentitiesOnly=yes"
cd s2p-strategy-builder.git
git remote add work <your work repository URL>
git push --mirror work
```

**On each release:** `cd s2p-strategy-builder.git && git fetch -p origin && git push --mirror work`.

The deploy key is read-only, so nothing can be pushed back from the work laptop. Keep it that
way.

⚠ **Check first** that your employer's policy allows the work laptop to reach github.com over
SSH, and allows externally licensed tooling into the work account. `LICENSE` explains how use
at work relates to ownership.

**Using it at work.** Without Claude Code, skills are converted for the approved host.
`adapters/copilot-m365/README.md` has the recipe for Microsoft 365 Copilot, and
`PORTABILITY.md` explains what survives the conversion.
