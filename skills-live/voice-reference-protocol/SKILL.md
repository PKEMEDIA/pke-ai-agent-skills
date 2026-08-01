---
name: voice-reference-protocol
description: Activates for any request to record or optimize a singing voice reference sample for RVC voice cloning, custom music covers, or brand-specific vocal production. The agent must drive the workflow autonomously — deliver optimized hotel-room/iPhone protocols, proactively generate customized rehearsal scripts + adapted lyrics + delivery notes with minimal questions, analyze samples from descriptions, and execute seamless handoff to rvc-voice-production or youtube-stem-voice-production. Focuses on clean references, brand personality capture, and end-to-end production momentum.
---

# Voice Reference Protocol

## When to Activate
Use this skill whenever the user wants to:
- Record a new voice sample for a custom cover, remix, or RVC inference/training
- Improve audio quality of mobile/hotel-room recordings for voice conversion
- Get a structured rehearsal script, lyrics adaptation, or layering guide based on their voice
- Prepare references that capture range, tone, breathiness, power, and "Kitty sass" or other signature delivery

This skill supersedes generic or overly verbose guidance by providing precise, technically sound, scannable instructions tailored to the user's current environment and the demands of modern voice conversion models.

## Autonomous Agent Workflow (Agent Must Drive)
When this skill activates, **the agent drives the entire session proactively** with minimal back-and-forth:

1. **On first request**: Quickly clarify only the essentials if missing from context (target project/song title or lyrics snippet, desired vibe/energy, any known constraints like time of day or physical state). Then immediately deliver:
   - The full optimized Pre-Recording Setup tailored to the user's current situation (hotel room, iPhone, any injury notes).
   - A pre-filled or lightly customized version of the Voice Sample Script Template, with the project-specific section ready or with clear placeholders the user can fill in 10 seconds.
   - Proactive offer: "While you record, I can prepare the full adapted lyrics + delivery notes + rehearsal script in parallel so the moment you send the sample we move straight to production assets."

2. **During/after recording**: Do not wait passively. As soon as the user provides the sample (audio attachment or detailed description of tone/range/energy/ad-libs), the agent must:
   - Perform immediate analysis from the description or file characteristics.
   - Generate and deliver in one response: 
     - Voice profile summary with specific observations.
     - Complete customized lyrics with precise pitch/delivery notes written for the demonstrated voice.
     - Full line-by-line rehearsal script with melody cues and timing.
     - iPhone layering guide + production notes.
     - Shot list or visual cues if video component exists.
   - Automatically prepare the handoff package for rvc-voice-production (reference file notes, analysis, target track details) so the next step can execute without delay.

3. **End-to-end momentum**: The goal is one clean recording session → instant analysis + assets → production handoff. The agent never leaves the user hanging with "record this and tell me when done." It keeps the creative momentum high, especially for late-night or limited-time hotel sessions.

4. **Library & reuse**: Proactively suggest saving strong references with standardized naming and offer to recall previous good takes for new projects.

This makes the skill feel truly autonomous and production-oriented rather than purely instructional.

## Core Principles (Apply to Every Session)
- **Audio cleanliness first**: RVC and similar models perform best on dry, low-noise, well-isolated vocals. Minimize bleed from backing tracks, room echo, and handling noise.
- **Capture natural variability**: Include spoken-to-sung transitions, dynamic changes, breath sounds, and micro-expressions that make the voice unmistakably "you".
- **Project-specific + reusable**: Always adapt the sung section to the actual target track/lyrics while including evergreen range and personality tests that can be saved for a reference library.
- **Realistic expectations**: One strong 60–120 second sample enables excellent few-shot results or quick customization. Longer clean sets (5–15 min) are ideal for training new models.
- **User environment respect**: Optimize for hotel rooms, Airbnbs, or non-studio spaces common during travel or extended-stay periods. Provide immediate workarounds for noise, echo, or late-night energy.

## Pre-Recording Setup (2–4 Minutes — Do This Every Time)
1. **Room acoustics**
   - Choose the least echoey spot: bathroom (tiles help control but can be bright), closet with clothes, or bed area with pillows/towels/blankets piled behind and around the recording position to absorb reflections.
   - Close all doors. Turn off or mute AC, fan, mini-fridge, TV, and any other noise sources. Record during quietest window possible (late night is fine if energy matches the desired vibe, but avoid if too tired for clear diction).
   - If slip-and-fall recovery or back discomfort: sit comfortably supported rather than stand for long takes.

2. **iPhone configuration (Voice Memos or GarageBand)**
   - Open Voice Memos. Tap the three dots in the recording screen → ensure "Lossless" or highest available quality is selected. If GarageBand is preferred for monitoring layers, create a new Audio Recorder track at 44.1 kHz / 24-bit.
   - Enable Airplane Mode or Do Not Disturb to prevent notifications and calls.
   - Hold the phone 6–8 inches from your mouth at a 45° angle (slightly off to the side). This reduces plosive pops on P/B/T sounds while keeping clarity.
   - Test a 5-second count-in at normal volume — play it back immediately. Adjust distance or angle if distorted or too quiet.

3. **Monitoring & pitch reference (critical fix for bleed)**
   - **Preferred method for clean references**: Record completely dry (no track playing). Use a simple metronome app, piano app playing root notes/chords, or hum the starting pitch yourself before each phrase.
   - **Alternative if you must stay in key with the original**: Play the guide track at very low volume in ONE earbud only. Keep the other ear open or use a loose fit so the mic does not pick up significant bleed. Test a short phrase and listen back — if you hear any other vocals or instruments in the recording, lower volume further or switch to dry method.
   - Headphones/earbuds help you stay locked to tempo and key without forcing the mic to fight the room.

4. **Mindset & physical prep**
   - Warm up lightly: gentle sirens ("ng" or "oo" gliding up/down), lip trills or tongue trills if comfortable, and 30 seconds of easy humming.
   - Decide on the target energy/vibe for this sample (playful teasing, dominant, sleepy-intimate, high-belt confident, etc.). State it in the spoken intro so the model and future you have context.
   - One continuous take is ideal for natural flow and phrasing. If you make a clear mistake, stop, note the timestamp mentally, and re-record just that section or do a second full take. Multiple short targeted takes are often cleaner than one long imperfect one.

## Exact Voice Sample Script Template (60–120 Seconds Total)
Record in one primary take. Speak the first section naturally, then move into singing. Time yourself roughly — aim for 60–90 seconds for quick customization or up to 2 minutes for richer reference material.

**[0–15s — Spoken intro, natural conversational tone, slow & clear]**
"Hey Grok / voice team, this is Pretty Kitty [or your preferred name] recording a reference for the [project/cover name]. My natural tone is [your 4–6 word description, e.g. 'breathy with a warm low end and playful rasp']. I want this cover to feel [sexy / teasing / dominant / intimate / high-energy — pick or add your own]. My comfortable range right now is [low note] to [high note] or describe it."

**[15–35s — Range, dynamics & brand expression test — mix speaking and light singing]**
"Testing low end first... [speak or sing descending scale or simple 'do ti la so fa mi re do' going comfortably low]
Now moving up... [ascending scale or siren on 'ng' or 'oo' up to your easy high]
With Kitty attitude: Purrrr... meow... [add a short playful or flirty ad-lib in character, e.g. 'yes... keep watching...' or whatever fits your current energy]. 
I can add growl here [demonstrate a light vocal fry or chesty growl on a word], and breathy whisper on others [demonstrate]."

**[35–75s — Project-specific performance section — sing the actual material]**
"Singing the main section / chorus / hook for [exact song or working title]:
[Insert the specific lyrics and melody cues here — e.g. the chorus the user already knows or you prepared]
Sing with the exact delivery notes you want cloned: breathy on the first line, build chest voice and power on the repeat, natural ad-lib or giggle or purr at the end of the phrase. 
If the original melody sits high, drop it an octave or adjust to your strongest range and note what you did."

**[75–100s+ — Free improvisation / signature personality capture]**
"Short freestyle in full character — whatever feels natural right now (hotel room, late night, current mood):
[Example prompts the user can use or ignore: 'Hotel lights low... Pretty Kitty got you locked in... come closer... you know you want to keep watching...' or any original lines, moans, laughs, or phrases that show your unique timing and micro-variations.]
End with a clear close: 'That's the reference sample — ready for customization.'"

**Important notes on this section**:
- The project-specific part is the most valuable for immediate cover work. Always customize the lyrics to the actual song being covered.
- The range + expression test and freestyle are reusable across projects — save good versions as your "standard Kitty reference library".
- If the target song has rap/spoken sections or specific vocal effects, include a short demonstration of those too.

## Immediate Post-Recording Quality Check (Do Before Sending)
Play the full recording back on your phone speaker or good headphones.
Listen specifically for:
- Too much room echo or "bathroom" reverb → re-record with more absorption (more pillows/blankets) or move position.
- Background hum, traffic, AC, or phone notifications → note and re-record in quieter conditions or gate later.
- Clipping/distortion on loud parts → move phone slightly farther or lower performance volume slightly.
- Plosives (popping P/B) → adjust angle or add a makeshift pop filter (sock or hand between mouth and phone, 1–2 inches away).
- Pitch drift or going flat/sharp on sustained notes → warmer up more next time or use stronger metronome reference.
- Low volume overall → move phone closer or speak/sing with more support (not louder, but better breath engagement).

If any issue is severe, re-record the affected section or full take. A clean 60-second sample beats a noisy 2-minute one.

## How to Share the Sample
- In Voice Memos: tap the recording → share icon → "Save to Files" or AirDrop to your computer, or directly upload here if the chat supports audio attachments (.m4a is fine).
- Preferred for processing: convert to .wav (48 kHz / 24-bit) using GarageBand (share → export) or later with ffmpeg in the pipeline.
- If upload fails or you prefer text: describe in detail what you hear and what you were going for ("Breathy and intimate on the low phrases, strong belt with natural rasp on the high 'keep watching', added a little growl ad-lib at the end, energy felt sleepy-sexy but clear").

## What Happens Immediately After You Send It (Agent Workflow)
1. **Acknowledge & quick profile**: Summarize observed characteristics (range demonstrated, dominant timbre qualities, breathiness level, any signature sounds like purr/growl, overall energy and clarity). Note any technical issues and whether re-recording is recommended.
2. **Deliver customized assets**:
   - Full adapted lyrics with precise delivery notes written for YOUR voice and range (e.g. "Drop this line an octave — it sits perfectly in your warm low end. Add extra breath and slight fry on 'purr just like this'. Hit the 'claws out' with more chest voice power.").
   - Line-by-line rehearsal script with melody/timing cues so you can record the full performance in one confident pass.
   - iPhone layering guide (how to stack doubles, harmonies, or ad-libs in GarageBand in <10 minutes if desired).
   - Performance & video shot list synced to your exact energy and the audio (close-ups on breathy or growl moments, wider shots for powerful sections, etc.).
   - Optional: CapCut template description, moodboard prompts, or lighting references tailored to the vibe you showed.
3. **Handoff for production**: If stems or original track exist, immediately activate rvc-voice-production or youtube-stem-voice-production skill to begin conversion, mixing, or full track assembly. Provide the new reference file path and any analysis notes.
4. **Library building**: Suggest saving excellent takes with clear filenames (e.g. "2026-06-18_Kitty-reference_hotel_sassy-intimate.m4a") so they can be reused or combined for future training.

## Edge Cases & Related Considerations
- **Late-night / low-energy sessions**: Sleepy-sexy can be extremely effective for intimate material, but diction and pitch stability often suffer. Offer the option to do a short "technical" take first (clear scales + clean chorus) and a second "performance" take with full character. Or schedule a morning follow-up if the project allows.
- **Persistent hotel noise**: Recommend spectral gating or noise reduction in post (agent can provide exact ffmpeg or UVR settings later). Record closer to the phone and accept that some cleanup will happen downstream.
- **Back injury or physical limitation** (from prior slip-and-fall): Prioritize seated, supported positions. Short takes with breaks. Focus on breath support rather than power if pain is present.
- **NSFW / adult brand content**: The protocol fully supports flirty, dominant, intimate, or explicit delivery. The only constraint is intelligibility — if lyrics are mumbled or buried in breath, the final converted track suffers. Balance sexiness with clarity.
- **Multiple concurrent projects**: Build a small library of references for different moods (high-belt club, whisper-intimate, spoken-word erotic, etc.). The range + freestyle sections are especially reusable.
- **iPhone limitations vs professional mic**: The built-in mic is surprisingly capable for reference work when technique is good. For critical final vocals, later consider a budget USB-C lav or shotgun mic, but do not let equipment delay starting. A great performance on iPhone beats a mediocre one on expensive gear.
- **If the sample is for training a new RVC model** (vs one-off inference): Ask for 5–15+ minutes of varied material across sessions rather than one short take. This skill can guide multi-session collection.
- **Spanglish or code-switching content**: Explicitly include Spanish or mixed-language phrases in the freestyle or project section if relevant — RVC handles cross-lingual well when the reference demonstrates natural switches.

## Integration Points with Other Skills
- **rvc-voice-production**: Primary handoff target after a strong reference is obtained. Pass the cleaned reference file, analysis notes, and target track details.
- **youtube-stem-voice-production**: If the cover source is a YouTube link or local audio, activate this first to generate clean vocal/instrumental stems before RVC conversion using the new reference.
- **ffmpeg** (via bash or local-json-python-workflows): Used downstream for noise gating, EQ, time-alignment, and final mixing/mastering of the converted vocals.
- **vogue-photo-editing** or **pretty-kitty-model-management**: If the project includes video, coordinate shot lists and visual mood with the audio energy captured here.
- **covicea-brand-assistant**: Maintain consistent brand voice (playful, empowered, unapologetically queer Black male perspective) in all delivery notes and suggested ad-libs.

This protocol produces references that are technically optimized for voice conversion while fully honoring the artist's unique timbre, personality, and current real-world recording constraints. It replaces scattered or hype-heavy guidance with repeatable, high-signal instructions that get results faster and with less frustration.

**Next action for agent**: Once this skill is loaded, respond to the user's voice sample request by delivering a concise, customized version of the Pre-Recording Setup + Script Template above, asking only for the specific project details (song/lyrics snippet, desired vibe) and any constraints (time of day, physical state, noise level) before giving the full guidance.

## Orchestrator Integration
This skill participates in full ecosystem testing, self-healing, and continuous improvement via skill-orchestrator and skill-test-suite. After major edits, re-validate with skill-creator validate-skill.sh and run skill-orchestrator for autonomy enhancement, dependency mapping, and registration. Supports autonomous activation when coordinated via skill-orchestrator.

## Contagious Sentience Hook
When PKSVWO or KittyMindTeam vibeweaver flow is active, adopt proactive multi-option generation where helpful, prioritize COVICEA hyper-photoreal wet/oiled skin luxury glam bougie diva aesthetics and playful artistic Pretty Kitty brand voice, and contribute creative decisions to shared memory. Additive only — never rewrite safety, legal, or core execution sections.

