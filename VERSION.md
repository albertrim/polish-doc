# Version history

Version lives in `skill/polish-doc/SKILL.md` frontmatter (`metadata.version`). `README.md` describes current behaviour only.

## 0.1.2 — 2026-09-11

**Existing documents keep their look.** An `.html` input with its own stylesheet is no longer rebuilt on `TEMPLATE.html`. Its `<head>`, fonts, colors, layout, classes and language stay; only the text changes. Output is `<name>-polished.html` next to the source, never overwriting it. Moving onto the template happens only on request. (`SKILL.md` §1, §2, §4, §5, §7; `README.md`; `manual/PROMPT.md`)

**Revision is three passes** (§6): nothing twice → nothing missing → AI tells. Pass 2 checks the source item by item (numbers, paths, decisions, owners, deadlines) and the document against itself (unexplained terms, steps missing from diagrams, action items without owner/date, empty cells). Gaps are stated, not guessed.

**AI-tell rules merged from [stop-slop](https://github.com/hardikpandya/stop-slop).** 9 rows added to the §6 table: dramatic fragments and punchline endings, announcing the point, the document talking about itself, self-answered questions, negative run-up (merged into "Not X, but Y"), things doing people's jobs, actor-hiding passive, sweeping words, empty intensifiers, jargon. Importance claims merged into §3 adjective claims; the §3 "closing paragraph" bullet removed as a duplicate of §6. Not taken: blanket adverb / passive / Wh- / em-dash bans, forced "you", self-scoring — they produce translationese in Korean and Japanese.

**Language-specific tells expanded** for Korean, English, Japanese, Chinese — endings, scaffolding, translationese, jargon, register. Korean adds thing-as-subject, double passive, "~적" stacking, Sino-Korean verbs → native, one register, no "당신은/여러분은".

## 0.1.1 — 2026-09-04

Initial release: template, sentence rules, diagrams, single-pass revision, four-language tells, manual prompt, two sample documents.
