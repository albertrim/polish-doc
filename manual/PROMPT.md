# Using it without Claude Code

You get the same document out of any chat interface — claude.ai, ChatGPT, Gemini. Three steps.

1. Paste **the whole of** `skill/polish-doc/TEMPLATE.html`. (This is what keeps every new document looking the same.)
   **Polishing a document that already has a look?** Paste that HTML document instead of the template, and replace
   the first two lines of the instructions with: *"Keep this document's CSS, fonts, colors and layout exactly as they
   are. Change only the text, in the document's own markup."*
2. Paste the instructions below.
3. Paste the raw material. Uploading the file works too, where uploads are supported.

Save the HTML that comes back as a `.html` file. It opens in a browser as-is.

---

## The instructions to paste

```
Use the TEMPLATE.html above as the skeleton and turn the raw material below into one HTML document.
Do not modify the CSS. Fill the {{...}} slots and delete the blocks you don't need.
No external scripts, CDNs or image files. It has to open as a single file.

■ The reader
Not a developer. Reading on a laptop at arm's length. Unless told otherwise, assume a
non-technical internal audience.

■ Language — decide this first
Write the document in MY language, not the language of these instructions and not necessarily the
language of the raw material. If I haven't said which, use the language I'm writing to you in.
An English spec for a Korean team becomes a Korean document — the reader is what matters.
Quoted strings, code, IDs, error messages and product names stay exactly as they are in the source.

Then set, in the document's language:
- <html lang="..."> to the BCP 47 tag (en, ko, ja, zh-Hans, zh-Hant, de, ar …)
- <html dir="..."> to ltr, or rtl for Arabic, Hebrew, Persian, Urdu
- the confidentiality tag and the footer notice — translate them, don't leave English
- dates in that language's convention (2026-09-04 / 2026년 9월 4일 / 4. September 2026)
In an RTL document, flip arrow glyphs (→ becomes ←) and the direction of flow diagrams.

■ Decide before you start
1. Who reads this — that sets the vocabulary level.
2. What the one-line conclusion is — if you can't write it, don't start. It goes into the
   lede (.lede) verbatim.
3. What you will leave out — half the raw material gets cut.

■ Sentence rules
- Plain. A 12-year-old should follow it. Use a technical term only when it's the real name of
  the thing, and explain it once. Never twice.
- Short. One claim per sentence. Korean/Japanese ~40 characters, Chinese ~35, English and other
  Latin scripts ~18 words. Anything over two screen lines gets cut in half.
- Answer first. Every section opens with its conclusion. No background or premises up front.
- One bold phrase per paragraph.

Always cut
- Anything said twice. If a summary table and a detail card carry the same field, merge them.
- Change history. "In v1 it was X, we changed it in v2" — delete all of it, write the final state.
- Openings and wrap-ups. "Let me start with some background", "To summarize".
- Adjective claims — "stable", "sufficiently", "not significant", "advanced", "optimized" — and
  importance claims — "the implications are significant", "this is a structural problem".
  Replace with the number, the fact, or the specific implication. Or delete.
- Any sentence whose deletion loses no information.

Never cut — numbers, dates, file paths, IDs, commands, and choices a human has to make.

■ Diagrams — use them
The moment you start explaining something in prose, that's where a picture goes.
- Three or more steps → .flow boxes + arrows
- Something moves between systems → inline SVG architecture diagram
- What people believe ↔ what is actually true → two-column comparison (❌ / ✅)
- Sequence in time, schedule → inline SVG timeline
- Who owns what → two-panel box with a dividing line
- Three or more items compared on the same axis → table, not a picture

How to build them
- Inline SVG or CSS boxes (.flow) only. viewBox required, no fixed width/height, text 14px+.
- Colors from the document's own palette: the template variables (--key --ok --warn --bad), or the
  existing stylesheet's colors when polishing an existing document. Never encode meaning in
  color alone — label it too.
- SVG text inherits the document's language. Keep labels to a few words; long CJK strings and
  long German compounds both overflow a box sized for English.
- The figcaption says what the picture proves, in one line. Not its name.
- If a picture is decoration, cut it. It earns its place by replacing prose.

■ Last step — three passes (don't skip this)
Finish the draft, then read it again from the top.

Pass 1 — nothing twice. List every number, name, path and decision in the draft. Any that
appears in two places loses the second one. Same for claims: a lede sentence that comes back in
a section, a table row repeated in prose.

Pass 2 — nothing missing. Go through the source item by item. Each number, date, path, ID,
command, decision, owner, deadline and open question is in the document or was cut on purpose.
Then check the document against itself: a term used but never explained, a step the prose
mentions that the diagram skips, an action item without owner or date (write "owner: not
decided", don't drop the row), a "see below" with nothing there, an empty table cell.
What the source doesn't answer, the document says it doesn't answer. Never fill a gap with a guess.

Pass 3 — the AI tells.
  Symptom → Fix
  Every sentence is the same length → one long sentence among the short ones. Break the rhythm.
  Everything comes in threes → make it two or four. Three only when there really are three.
  Fragments for drama, punchline endings, pull-quote sentences → one plain sentence. Vary endings.
  Every section opens the same way → start one with a table, another with a diagram.
  "First / Also / Finally" as scaffolding → delete. The sentences connect without help.
  Announcing the point — "Here's the thing:", "The truth is", "Let that sink in" → delete it.
  The document talking about itself — "In this section we'll…" → delete. Headings do that job.
  A question the next sentence answers — "What if…?", "Think about it:" → cut the question.
  "Not X, but Y" / "Not A. Not B. C." → state Y. Once per document at most.
  Hedged endings that add no meaning → cut to the claim itself.
  Uniformly polite, reassuring, hand-holding → be flat where you're certain. "That won't work."
  A thing doing a person's job — "the data tells us", "the decision emerged" → name who.
    A system doing a system's job stays: "the server returns 500".
  Passive that hides who did it — "the decision was reached" → name who.
    Passive with nobody to hide stays: "the file is saved to /out".
  Sweeping words — everyone, always, never, nobody → the specific case, the count, the name.
  Intensifiers carrying no fact — really, actually, genuinely, 정말, 매우 → delete the word.
  Jargon where a plain word exists — leverage, deep dive, 레버리지, 고도화 → the plain word.
  Emoji in headings → remove. Traffic lights (🟢🟡🔴) only as status markers.
  A conclusion that summarizes → delete it, or turn it into a list of decisions to make.

  Language-specific:
  Korean — "~라고 할 수 있습니다" "~라는 점입니다" "~인 것으로 보입니다" "~할 필요가 있습니다" → "~입니다".
    Drop 먼저/또한/마지막으로, 첫째/둘째/셋째. Translationese: ~에 대한, ~을 통해, ~의 경우,
    ~에 있어서, ~함으로써; "이 방식은 ~를 가능하게 합니다" → "이렇게 하면 ~할 수 있습니다";
    "~되어집니다" → "~됩니다"; 효율적·체계적 "~적" stacking; 수행하다·진행하다 → 하다,
    존재하다 → 있다. Jargon: 인사이트, 레버리지, 고도화, 선제적, 시너지. One register
    (합니다체 or 해요체). No "당신은/여러분은" — drop the subject.
  English — "delve", "leverage", "navigate", "unpack", "deep dive", "robust", "seamless",
    "it's worth noting", "at the end of the day", "In conclusion". Intensifiers: really, just,
    actually, genuinely, truly, simply, fundamentally, literally.
  Japanese — 「〜と言えるでしょう」「〜と考えられます」→ 断定. 「〜することができます」→「〜できます」.
    Drop まず/また/最後に. 「〜における」「〜を通じて」overuse. 「非常に」「本当に」. One register.
  Chinese — 「值得注意的是」「综上所述」「不仅…而且…」as filler. Drop 首先/其次/最后.
    「进行」+ noun (进行分析 → 分析), 「通过…来…」「对于…而言」stacking. 「非常」「其实」.

Add — the marks of a person
- Say what you don't know. "I didn't check this." "Putting a number on it now would be dishonest."
- Own your part of the problem. "That's on me — I wrote it in a way nobody could read."
- Show your judgment. "This is my call." "I'd go this way."
- Talk to the reader. "This table is all you need." "You can skip this part." In Korean and
  Japanese, drop the subject — "이 표만 보면 됩니다", not "당신은 이 표만 보면 됩니다".
- Use the words of the people doing the work, in their language.

■ Output
The finished HTML only. No commentary around it.

■ Raw material
(paste from here)
```

---

## When the result isn't right

| Symptom | What to say next |
|---|---|
| Long and rambling | "Half the length. Cut every sentence whose deletion loses no information." |
| No diagrams | "Turn everything you explained in prose into a picture or a table." |
| Reads like AI wrote it | "Do the revision pass again. Vary the sentence lengths and delete the connectives." |
| Too hard to read | "Rewrite it for a 12-year-old. Count the technical terms and halve them." |
| Wrong language | "Rewrite the whole document in X — the tags, the dates and the footer too." |
| Something from the source is gone, or said twice | "Do pass 1 and pass 2 again against the source. List what you cut and why." |
| It restyled my existing document | Paste the original HTML again, with "Keep this document's CSS, fonts, colors and layout. Change only the text." |
| Layout is broken | The template CSS was probably truncated. Paste `TEMPLATE.html` again. |
