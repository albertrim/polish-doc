---
name: polish-doc
description: "Turns whatever it is given — a file path, pasted text, an analysis you just produced — into one standalone HTML document. Plain words a 12-year-old understands, short sentences, no repetition, diagrams wherever they beat prose. Ends with a revision pass that strips the AI tells. Works in any language: the document is written in the OS locale's language by default, or whichever language you ask for. Triggers: '/polish-doc', 'make this an HTML document', 'turn this into a report', 'polish this doc', 'document this', 'HTML 문서로 만들어줘', '보고서로 정리해줘', '문서 폴리싱', 'ドキュメントにして', '整理成文档', '整理成文件'."
user-invocable: true
---

# /polish-doc — content into a standalone HTML document

Turn the given content into **one HTML file** that opens with no external dependencies.
Assume the reader is not a developer and is reading on a laptop at arm's length.

## 1. Reading the arguments

| Argument | What to do |
|---|---|
| File path (`.md` `.txt` `.html`) | Read it in full. For `.html`, strip the tags and take the body text |
| Pasted text or notes | Use as-is, it is the raw material |
| Several files | Read them all and **merge into one document.** Do not give each file its own section |
| Nothing | The analysis or result you just produced in this session. If there is none, ask in one line what to document, and stop |

Long raw material does not get skimmed. **You cannot choose what to cut without reading all of it.**

## 2. Language — decide this first

**The default is the OS locale.** The people who read this document sit where the machine sits. Read it before writing anything:

```bash
defaults read -g AppleLocale 2>/dev/null || echo "${LC_ALL:-${LANG:-}}"
```

On macOS `$LANG` is often `en_US.UTF-8` on a machine whose system language is Korean, so `AppleLocale` comes first. On Linux use `$LC_ALL`, then `$LANG`.

Precedence, highest first:

1. **The user names a language** — "write it in English", or the request itself is written in another language and asks for a document for that audience. This always wins.
2. **The OS locale** — `ko_KR` → Korean, `ja_JP` → Japanese, `de_DE` → German.
3. **The language of the raw material** — used when the locale is `C`, `POSIX`, unset or unreadable.

Source language does not override the locale. A Korean-locale machine turns an English spec into a Korean document, because the reader is local. Quoted strings, code, IDs, error messages and product names stay exactly as they are in the source — those are not prose.

Say which language you chose in one line when you report the saved path, so the user can override it in one word.

Once decided, that choice drives four things in the template:

| Slot | What to put |
|---|---|
| `<html lang>` | BCP 47 tag — `en`, `ko`, `ja`, `zh-Hans`, `zh-Hant`, `de`, `ar` … |
| `<html dir>` | `ltr`, or `rtl` for Arabic, Hebrew, Persian, Urdu |
| Confidentiality tag, footer notice | Written in the document's language. Not left in English |
| Dates | The convention that language uses — `2026-09-04`, `2026년 9월 4일`, `4. September 2026`, `September 4, 2026` |

In an RTL document, flip the direction of arrow glyphs (`→` becomes `←`) and of SVG flow diagrams. The CSS already handles borders, list indents and table alignment.

## 3. Sentence rules

**Plain.** A 12-year-old should follow it. Use a technical term only when it is the real name of the thing, and explain it once. Never twice.

**Short.** One claim per sentence. The ceiling depends on the script:

| Language | Average sentence | Hard stop |
|---|---|---|
| Korean, Japanese | ~40 characters | 2 lines on screen |
| Chinese | ~35 characters | 2 lines on screen |
| English and other Latin-script languages | ~18 words | 25 words |

**Answer first.** Every section opens with its conclusion. No background, history or premises up front.

**Always cut**
- Anything said twice. If a summary table and a detail card carry the same field, **merge them.**
- Change history. "In v1 it was X, we changed it in v2" — delete all of it. Write only the final state.
- Openings and wrap-ups. "Let me start with some background", "To summarize".
- A closing paragraph that repeats what came before.
- Adjective claims — "stable", "sufficiently", "not significant", "advanced", "optimized". Replace with a number or a fact, or delete.
- Any sentence whose deletion loses no information.

**Never cut** — numbers, dates, file paths, IDs, commands, and choices a human has to make. Shortening by dropping data is a failure, not a win.

**Emphasis** — one bold phrase per paragraph. All bold is no bold.

## 4. Diagrams — use them

The moment you start explaining something in prose, that is where a picture goes. These always get drawn:

| Situation | Form |
|---|---|
| Three or more steps | `.flow` boxes + arrows |
| Something moves between systems | Inline SVG architecture diagram |
| What people believe ↔ what is actually true | Two-column comparison (❌ / ✅) |
| Sequence in time, schedule | Inline SVG timeline |
| Who owns what | Two-panel box with a dividing line |
| Three or more items compared on the same axis | Table, not a picture |

**How to build them**
- **Inline SVG** or **CSS boxes** (`.flow`) only. No external scripts, CDNs or image files — the file has to open on its own.
- SVG needs a `viewBox` and no fixed `width`/`height`. Text at 14px or larger.
- Colors come from the template variables (`--key` `--ok` `--warn` `--bad`) only. Never encode meaning in color alone — label it too.
- SVG text is real text, so it inherits the document's language. Keep labels to a few words; long CJK strings and long German compounds both overflow a box sized for English.
- The `figcaption` says **what the picture proves**, in one line. Not its name — "Architecture diagram" tells the reader nothing.
- If a picture is decoration, cut it. It earns its place by replacing prose.

## 5. Building the file

1. Use `TEMPLATE.html` (in this skill folder) as the skeleton. Do not touch the CSS — documents must not each look different.
2. Fill the `{{...}}` slots, delete the blocks you do not need.
3. Where it goes — same folder as the source file, or the current working directory if the content was pasted.
4. Filename — `<topic>-<purpose>-<YYYYMMDD>.html`. **Use ASCII letters, digits and hyphens**, transliterating the topic if the document is not in a Latin script (`벤더 연동` → `vendor-integration`). This keeps the file safe to attach, upload and put in a URL. Example: `vendor-integration-options-20260904.html`.
5. Check the `<title>`, the `.meta` masthead and the `footer` — real date, real author, and both in the document's language.

## 6. Revision — strip the AI tells (skipping this step means the job failed)

Finish the draft, then **read it again from the top** and fix what follows. It has to read as if the user wrote it.

**Tells, in any language**

| Symptom | Fix |
|---|---|
| Every sentence is the same length | Put one long sentence among the short ones. Break the rhythm |
| Everything comes in threes | Make it two or four. Three only when there really are three |
| "First / Also / Finally" as scaffolding | Delete them. The sentences connect without help |
| Hedged endings that add no meaning | Cut to the claim itself |
| "Not X, but Y" used repeatedly | Once per document |
| Every section opens the same way | Start one with a table, another with a diagram |
| Emoji in headings | Remove. Traffic lights (🟢🟡🔴) only as status markers |
| Uniformly polite throughout | Be flat where you are certain. "That won't work." |
| A conclusion that summarizes what came before | Delete it, or turn it into a list of decisions to make |

**Language-specific tells**

- **Korean** — "~라고 할 수 있습니다", "~라는 점입니다" → "~입니다". Drop "먼저 / 또한 / 마지막으로". Watch for translationese: overused "~에 대한", "~을 통해", "~의 경우".
- **English** — "delve", "leverage", "robust", "seamless", "it's worth noting that", "in today's fast-paced". Cut "In conclusion". Kill the em-dash-heavy triplet rhythm.
- **Japanese** — 「〜と言えるでしょう」「〜ではないでしょうか」→ 断定. Drop 「まず」「また」「最後に」as scaffolding. Watch overused 「〜における」「〜を通じて」.
- **Chinese** — 「值得注意的是」「综上所述」「不仅…而且…」as filler. Drop the 首先/其次/最后 scaffolding. Avoid the four-character-idiom pile-up.

**What to add — the marks of a person**
- **Say what you don't know.** "I didn't check this." "Putting a number on it now would be dishonest."
- **Own your part of the problem.** "That's on me — I wrote it in a way nobody could read."
- **Show your judgment.** "This is my call." "I'd go this way."
- **Talk to the reader.** "This table is all you need." "You can skip this part."
- **Use the words of the people doing the work**, in their language.

**Last check** — read it aloud. Anything you stumble over gets rewritten. Anything you can't get through in one breath becomes two sentences.

## 7. After it is built

- State the saved path in one line.
- If you cut something important, name that one thing. Do not explain what you put in — that is visible when they open it.
- If the user wants a shareable link, offer to publish it as an Artifact then. Do not publish first.
