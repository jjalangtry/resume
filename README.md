# resume.jjalangtry.com

Terminal-aesthetic resume hosting site. Edit one file, push, done.

---

## Workflow

```
edit latex/resume.tex  →  git push  →  CI compiles  →  git pull
```

1. Edit `latex/resume.tex`
2. `git add latex/resume.tex && git commit -m "update resume" && git push`
3. GitHub Actions compiles it with XeLaTeX, names it `JakobLangtry{Mon}{YY}.pdf`,
   commits it to `public/resumes/`, and updates `versions.json`
4. Railway auto-redeploys — site is live
5. `git pull` to get the compiled PDF locally if you want it

> Pushing the same month twice just overwrites that month's PDF (same filename).
> Each new month automatically creates a new entry in the version history.

---

## Local Preview (before pushing)

Requires MacTeX: `brew install --cask mactex-no-gui`

```bash
cd latex
make open      # compile + open PDF
make watch     # auto-recompile on save
make clean     # remove build artifacts
```

---

## Project Layout

```
latex/
  resume.tex         ← the one file you edit
  archive/           ← manually drop old .tex versions here if you want
  Makefile           ← local compile shortcuts

public/
  resumes/
    versions.json    ← auto-maintained by CI
    JakobLangtryFeb26.pdf
    ...

src/                 ← Astro site source
.github/workflows/
  compile-resume.yml ← the automation
railway.toml
```

---

## Deployment

Deployed on Railway via `pnpm build` (Astro static) + `sirv` static server.
Custom domain: `resume.jjalangtry.com`
