## 📝 Description
<!-- Brief description of the changes introduced by this pull request -->

## 🎯 Motivation & Context
<!-- Why is this change required? What problem does it solve? Link issues if applicable: Fixes #123 -->

## 🛠️ Changes Implemented
- 

## 🧪 Verification & Quality Checklist
Please ensure all criteria from `AGENTS.md` and `CONTRIBUTING.md` are met:

- [ ] **Formatting:** Ran `dart format .` and no diffs remain
- [ ] **Static Analysis:** Ran `flutter analyze` with 0 warnings and 0 errors
- [ ] **Automated Tests:** Ran `flutter test` and all unit/widget tests pass
- [ ] **Line Constraints:** All non-generated files in `lib/` are $\le 250$ lines; widgets are $\le 80$ lines
- [ ] **Type Safety:** Zero `dynamic` types introduced (except strict JSON deserialization)
- [ ] **Architecture:** Strict Clean Architecture (UI $\rightarrow$ BLoC $\rightarrow$ Repository $\rightarrow$ Database)
- [ ] **Database & Migrations:** Any Drift schema changes increment `schemaVersion` and include `onUpgrade` batch migrations
- [ ] **No Secrets:** No `.env`, API keys, or private tokens committed

## 🤖 AI Disclosure
<!-- If an AI assistant was used, please note the tool, model, and scope of generation -->
- **AI Assisted:** [Yes / No]
- **Tool / Agent:** 
- **Human Reviewer:** 

## 📸 Screenshots or Recordings (UI Changes Only)
| Before | After |
|---|---|
| (screenshot) | (screenshot) |
