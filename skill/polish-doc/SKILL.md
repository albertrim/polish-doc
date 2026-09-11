---
name: polish-doc
description: "Turns whatever it is given — a file path, pasted text, an analysis you just produced — into one standalone HTML document. Plain words a 12-year-old understands, short sentences, no repetition, diagrams wherever they beat prose. Ends with a revision pass that checks nothing is said twice or left out, then strips the AI tells. A new document uses the bundled template; an existing HTML document keeps its own fonts, colors and layout and only the text changes. Works in any language: the document is written in the OS locale's language by default, or whichever language you ask for. Triggers: '/polish-doc', 'make this an HTML document', 'turn this into a report', 'polish this doc', 'document this', 'HTML 문서로 만들어줘', '보고서로 정리해줘', '문서 폴리싱', 'ドキュメントにして', '整理成文档', '整理成文件'."
user-invocable: true
metadata:
  version: 0.1.2
---

# /polish-doc — content into a standalone HTML document

Turn the given content into **one HTML file** that opens with no external dependencies.
Assume the reader is not a developer and is reading on a laptop at arm's length.

Two jobs, one skill:

| Source | Job | Look |
|---|---|---|
| Notes, `.md`, `.txt`, pasted text, this session's output | **New document** | `TEMPLATE.html` |
| An `.html` document that already has its own stylesheet | **Existing document** | Its own. Fonts, colors, layout stay; only the text changes |

## 1. Reading the arguments

| Argument | What to do |
|---|---|
| File path (`.md` `.txt`) | Read it in full. It is the raw material |
| File path (`.html`) | An existing document. Read it in full, markup included — you keep its look (§5). If it has no stylesheet of its own, treat it as raw material |
| Pasted text or notes | Use as-is, it is the raw material |
| Several files | Read them all and **merge into one document.** Do not give each file its own section. If one of them is an existing `.html` document, that one is the base and the others merge into it |
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
2. **An existing document keeps its language.** Polishing is not translating. Rewrite it in another language only when asked.
3. **The OS locale** — `ko_KR` → Korean, `ja_JP` → Japanese, `de_DE` → German.
4. **The language of the raw material** — used when the locale is `C`, `POSIX`, unset or unreadable.

Source language does not override the locale. A Korean-locale machine turns an English spec into a Korean document, because the reader is local. Quoted strings, code, IDs, error messages and product names stay exactly as they are in the source — those are not prose.

Say which language you chose in one line when you report the saved path, so the user can override it in one word.

Once decided, that choice drives four things in the file. An existing document already has them — check they are right and leave them.

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
- Adjective claims — "stable", "sufficiently", "not significant", "advanced", "optimized" — and importance claims — "the implications are significant", "this is a structural problem", "시사하는 바가 큽니다". Replace with the number, the fact, or the specific implication. Or delete.
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
- Colors come from the document's own palette: the template variables (`--key` `--ok` `--warn` `--bad`) in a new document, the existing stylesheet's variables or colors in an existing one. Never encode meaning in color alone — label it too.
- SVG text is real text, so it inherits the document's language. Keep labels to a few words; long CJK strings and long German compounds both overflow a box sized for English.
- The `figcaption` says **what the picture proves**, in one line. Not its name — "Architecture diagram" tells the reader nothing.
- If a picture is decoration, cut it. It earns its place by replacing prose.

## 5. Building the file

**New document**

1. Use `TEMPLATE.html` (in this skill folder) as the skeleton. Do not touch the CSS — new documents must not each look different.
2. Fill the `{{...}}` slots, delete the blocks you do not need.
3. Where it goes — same folder as the source file, or the current working directory if the content was pasted.
4. Filename — `<topic>-<purpose>-<YYYYMMDD>.html`. **Use ASCII letters, digits and hyphens**, transliterating the topic if the document is not in a Latin script (`벤더 연동` → `vendor-integration`). This keeps the file safe to attach, upload and put in a URL. Example: `vendor-integration-options-20260904.html`.
5. Check the `<title>`, the `.meta` masthead and the `footer` — real date, real author, and both in the document's language.

**Existing document** — the reader already knows this document. They open the polished one and see the same document, easier to read.

1. Do not use `TEMPLATE.html`. Keep the `<head>` as it is: `<style>`, `<link>`, fonts, `:root` variables, `lang`, `dir`. Do not add the template's CSS, swap the fonts, change the colors, or rebuild the page into the template's masthead / lede / sections.
2. Keep the document's own building blocks — its heading levels, table markup, callout and card classes, its way of drawing a flow. New content is built from the classes the document already has. If it needs something it has no class for, write the smallest inline addition in its palette, not a new stylesheet.
3. Change the text: sentences, order, duplicates, gaps, tells (§3, §6). Add, merge or delete blocks as the content needs, in the document's own markup.
4. Save next to the source as `<original name>-polished.html`. **Never overwrite the source.** Replace it only when the user says so.
5. Move an existing document onto `TEMPLATE.html` only when the user asks for it — "make it match the standard look", "템플릿 양식으로 바꿔줘".

## 6. Revision — nothing twice, nothing missing, no AI tells (skipping this step means the job failed)

Finish the draft, then **read it again from the top**, three passes. It has to read as if the user wrote it.

**Pass 1 — nothing twice.** List every number, name, path and decision in the draft. Any that appears in two places loses the second one. Same for claims: a sentence in the lede that comes back in a section, a table row repeated in prose, a "key point" box restating the paragraph above it. One place per fact, and the reader reaches it once.

**Pass 2 — nothing missing.** Go through the source the same way, item by item. Each number, date, path, ID, command, decision, owner, deadline and open question is either in the document or was cut on purpose, and you can say why. Then check the document against itself:
- A term used but never explained.
- A step the prose mentions that the flow diagram skips. A system in the diagram the text never names.
- An action item without who does it or by when. If the source does not say, write "owner: not decided" — do not drop the row.
- A "see below" / "as above" with nothing there. A section the lede or table of contents promises that does not exist.
- An empty table cell.

What the source does not answer, the document says it does not answer. Do not fill a gap with a guess.

**Pass 3 — the AI tells**

| Symptom | Fix |
|---|---|
| Every sentence is the same length | Put one long sentence among the short ones. Break the rhythm |
| Everything comes in threes | Make it two or four. Three only when there really are three |
| Fragments for drama, a paragraph that ends on a punchline, a sentence that sounds like a pull-quote — "Speed. Quality. Cost. Pick two." | One complete, plain sentence. Vary how paragraphs end |
| Every section opens the same way | Start one with a table, another with a diagram |
| "First / Also / Finally" as scaffolding | Delete them. The sentences connect without help |
| Announcing the point instead of making it — "Here's the thing:", "The truth is", "Let me be clear", "핵심은 이것입니다" — or stamping it afterwards — "Full stop.", "Let that sink in.", "This matters because" | Delete the announcement. The point stays |
| The document talking about itself — "In this section we'll…", "As we'll see", "이 글에서는 ~를 살펴보겠습니다" | Delete. Headings already do that job |
| A question the next sentence answers — "What if…?", "Think about it:", "Here's what I mean:", "왜 그럴까요? 바로 ~" | Cut the question, keep the answer |
| "Not X, but Y" / "X isn't the problem, Y is" / "Not A. Not B. C." | State Y. Once per document at most |
| Hedged endings that add no meaning | Cut to the claim itself |
| Uniformly polite, reassuring ("and that's okay"), hand-holding | Be flat where you are certain. "That won't work." |
| A thing doing a person's job — "the data tells us", "the decision emerged", "the market rewards", "이 방식은 ~를 가능하게 합니다" | Name who read the data, who decided. A system doing a system's job stays: "the server returns 500" |
| Passive that hides who did it — "the decision was reached", "mistakes were made", "결정되었습니다" | Name who. Passive with nobody to hide stays: "the file is saved to `/out`" |
| Sweeping words — "everyone", "always", "never", "nobody", "people tend to" | The specific case, the count, the name |
| Intensifiers and softeners that carry no fact — "really", "actually", "genuinely", "fundamentally", "정말", "매우", "사실상" | Delete the word. If the sentence lost nothing, it was filler. Keep the ones that change meaning: "only", "다만" |
| Jargon where a plain word exists — "leverage", "deep dive", "레버리지", "고도화" | The plain word. Lists per language below |
| Emoji in headings | Remove. Traffic lights (🟢🟡🔴) only as status markers |
| A conclusion that summarizes what came before | Delete it, or turn it into a list of decisions to make |

**Language-specific tells**

- **Korean**
  - Endings — "~라고 할 수 있습니다", "~라는 점입니다", "~인 것으로 보입니다", "~할 필요가 있습니다", "~하는 것이 중요합니다" → "~입니다", "~하세요". Scaffolding — "먼저 / 또한 / 마지막으로", "첫째 / 둘째 / 셋째".
  - Translationese — "~에 대한", "~을 통해", "~의 경우", "~에 있어서", "~함으로써". A thing as subject: "이 방식은 ~를 가능하게 합니다" → "이렇게 하면 ~할 수 있습니다". Double passive "~되어집니다" → "~됩니다". "~적(的)" stacking — 효율적·체계적·전략적. Sino-Korean verbs where a native one exists — 수행하다·진행하다 → 하다, 존재하다·위치하다 → 있다, 제공하다 → 주다.
  - Words — intensifiers 정말·매우·굉장히·사실상·단순히. Loanword jargon 인사이트·레버리지·고도화·선제적·시너지·얼라인 → the Korean word.
  - Register — 합니다체 or 해요체, one for the whole document. No "당신은 / 여러분은": Korean drops the subject, and a document that keeps saying "you" reads translated.
- **English**
  - Openers and crutches — "Here's the thing", "It turns out", "The truth is", "Let me be clear", "Full stop", "Let that sink in", "it's worth noting that", "at the end of the day", "in today's fast-paced". Cut "In conclusion".
  - Jargon → plain — delve → look at, leverage → use, navigate → handle, unpack → explain, deep dive → analysis, lean into → accept, double down → commit, landscape → field, circle back → return to, robust / seamless → the specific property, or delete.
  - Intensifiers — really, just, actually, genuinely, truly, honestly, simply, fundamentally, literally. Kill the em-dash-heavy triplet rhythm.
- **Japanese**
  - Endings — 「〜と言えるでしょう」「〜ではないでしょうか」「〜と考えられます」→ 断定. 「〜することができます」→「〜できます」. Scaffolding — 「まず」「また」「最後に」.
  - Translationese — 「〜における」「〜において」「〜を通じて」「〜に関して」 overuse. 「〜させていただきます」 is too humble for a document.
  - Words — 「非常に」「本当に」「まさに」. Katakana jargon 「レバレッジ」「インサイト」「アライン」→ 日本語. Register — です・ます or である, one for the whole document.
- **Chinese**
  - Filler — 「值得注意的是」「综上所述」「总的来说」「不仅…而且…」. Scaffolding — 首先/其次/最后.
  - Translationese — 「进行」+ noun as a verb (进行分析 → 分析), 「对于…而言」「通过…来…」「在…方面」 stacking, chains of 「的」.
  - Words — 「非常」「极其」「真正」「其实」. Avoid the four-character-idiom pile-up.

**What to add — the marks of a person**
- **Say what you don't know.** "I didn't check this." "Putting a number on it now would be dishonest."
- **Own your part of the problem.** "That's on me — I wrote it in a way nobody could read."
- **Show your judgment.** "This is my call." "I'd go this way."
- **Talk to the reader.** "This table is all you need." "You can skip this part." In Korean and Japanese, drop the subject — "이 표만 보면 됩니다", not "당신은 이 표만 보면 됩니다".
- **Use the words of the people doing the work**, in their language.

**Last check** — read it aloud. Anything you stumble over gets rewritten. Anything you can't get through in one breath becomes two sentences.

## 7. After it is built

- State the saved path in one line. For an existing document, say that its look was kept.
- If you cut something important, name that one thing. Do not explain what you put in — that is visible when they open it.
- If the user wants a shareable link, offer to publish it as an Artifact then. Do not publish first.
