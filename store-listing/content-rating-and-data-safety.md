# Content Rating & Data Safety — answer guide

These map to what's actually in the app. Play Console's exact wording/options
shift over time, so treat this as "what to answer," not an exact script —
match each item to the closest option Console actually shows you.

## Ads declaration
**Does your app contain ads?** → **No.**
The app has no ad SDK integrated at all.

## Target audience and content
- **Target age group:** the app has no age-specific content, but isn't
  designed *for* children either — a general audience (13+) declaration is
  the safest fit unless you specifically want to market to kids, which pulls
  in extra Families Policy requirements (stricter ads/data rules) you don't
  need for this app.
- Not primarily designed for children.

## Content rating questionnaire (IARC)
This is a multi-step questionnaire in Play Console. For every category the
answer is "None" / "No" — there's nothing in the app that involves:
- Violence, blood, or scary content
- Sexual content or nudity
- Profanity or crude humor
- Controlled substances (alcohol/tobacco/drugs)
- Gambling (real or simulated)
- User-generated content, chat, or the ability to communicate with other
  users (the leaderboard shows Play Games display names/scores, but users
  can't post free text or message each other in-app)
- Sharing of personal location

This should land the app at the lowest rating tier (Everyone / PEGI 3, or
equivalent for other rating boards Console asks about).

## Data Safety form
Walk through each Console section like this:

### Does your app collect or share any of the required user data types?
**Yes** (because of Play Games Services sign-in).

### Data types collected
- **Personal info → Name**: collected (your Play Games display name) —
  purpose: **App functionality** (shown on the leaderboard). Not required —
  the app works fully without signing in.
- **Personal info → User IDs**: collected (Play Games player ID) — purpose:
  **App functionality**. Not required.
- If Console has a line for **Photos** or **Profile picture**: your Play
  Games profile photo is received but not stored by the app — declare it the
  same way (App functionality, optional) if Console's categories require it;
  otherwise it's reasonable to omit since the app never persists or
  processes the image itself, only displays the URL Google provides.

Everything else (location, financial info, health, messages, photos/videos
you upload, browsing history, contacts, calendar) → **not collected.**

### Is all of the user data collected encrypted in transit?
**Yes** — Google Play Games Services traffic is encrypted (HTTPS).

### Do you provide a way for users to request their data be deleted?
**Yes** — via the account-level Play Games controls, referenced in the
privacy policy: users can disconnect the app's access to their Play Games
profile at https://play.google.com/games account settings, and the app's own
local preferences are removed on uninstall. Link Console to the privacy
policy URL below if it asks for one here.

### Privacy policy URL
https://denzilly.github.io/cyrillic_trainer_app/privacy-policy.html

## App access
If Console asks whether any part of the app is restricted (e.g. behind a
login): **all functionality is available without any special access** —
practice, sound, help, and the alphabet reference all work with no sign-in.
Only High Scores optionally uses Play Games sign-in, which any tester/
reviewer can do themselves with their own Google account.

## Government apps / Financial features / News apps / COVID-19 tracing
None of these apply — answer **No** / skip these sections.
