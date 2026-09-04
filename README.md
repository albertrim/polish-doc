# /polish-doc — notes into one document

A Claude Code skill that turns analysis output, meeting notes and drafts into **one HTML document**.
It opens as a single file, pastes into Slack, and prints without falling apart.

It is written for a reader who is not a developer. **Plain enough for a 12-year-old, short sentences, lots of pictures.**
Then it does one more pass to strip the tells that give away AI writing.

**Any language.** By default the document comes out in your OS locale's language — a `ko_KR` machine produces Korean, a `de_DE` machine produces German — and you can override that in one word. The template ships with CJK, Arabic and Devanagari font fallbacks and logical CSS properties, so right-to-left documents lay out correctly.

---

## 1. Install

```bash
./install.sh
```

Installs globally into `~/.claude/skills/`. For a single project:

```bash
./install.sh --project /path/to/repo
```

Manual install is just a folder copy.

```bash
cp -R skill/polish-doc ~/.claude/skills/
```

**Start a new Claude Code session** afterwards and it shows up in the list.

## 2. Use it

```
/polish-doc analysis.md
/polish-doc ~/Downloads/meeting-notes.txt reference.html
/polish-doc <paste the content you want documented>
/polish-doc                      ← documents whatever you just produced. Asks what to build if there's nothing
```

Give it several files and it **merges them into one document.** It does not give each file its own section.
The result is saved next to the source file as `<topic>-<purpose>-<YYYYMMDD>.html`.

Open `example/sample-en.html` or `example/sample-ko.html` in a browser and you will see exactly what comes out. Same template, same rules, two locales.

## 3. What it does for you

| | |
|---|---|
| **Cuts** | Repetition, change history, openings and wrap-ups, conclusions that restate the body, adjective claims like "stable / sufficient / advanced" |
| **Keeps** | Numbers, dates, file paths, IDs, commands, and any choice a human has to make |
| **Draws** | Three or more steps → a flow. Things moving between systems → an architecture diagram. Belief ↔ reality → a two-column comparison. Schedules → a timeline |
| **Revises** | Uniform sentence length, everything in threes, "First / Also / Finally", hedged endings — all of it gets fixed, in whichever language the document is in |

## 4. Layout

```
polish-doc-skill/
├── README.md                     this file
├── install.sh                    installer
├── skill/polish-doc/
│   ├── SKILL.md                  the rules — arguments, language, sentences, diagrams, revision
│   └── TEMPLATE.html             skeleton and CSS. What makes every document look the same
├── manual/
│   └── PROMPT.md                 using it without Claude Code (claude.ai, ChatGPT, …)
└── example/
    ├── sample-en.html            sample output, English. The content is fictional
    └── sample-ko.html            sample output, Korean. The content is fictional
```

## 5. Changing it

Different complaints live in different files. Don't mix them up.

| What bothers you | File to edit |
|---|---|
| Type size, colors, table styling, spacing | `:root` variables and CSS in `TEMPLATE.html` |
| Sentences are long / hard / rambling | `SKILL.md` §3 sentence rules |
| It picks the wrong language | `SKILL.md` §2 language |
| It doesn't draw pictures | `SKILL.md` §4 diagrams |
| It reads like AI wrote it | `SKILL.md` §6 revision |
| Filename or where files land | `SKILL.md` §5 |

Re-run `./install.sh` after editing.

## 6. Worth knowing

- **The template CSS is not edited per document.** The documents have to look like one set. Change `TEMPLATE.html` instead.
- The **confidential tag in the masthead is the default**, translated into the document's language. Tell it to drop the tag for anything going outside the company.
- No external scripts, CDNs or image files. Pictures are inline SVG or CSS boxes. **Send one file and the other person sees exactly what you see.**
- Want a shareable link? Build the document first, then say "publish this as a link".
