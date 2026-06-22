# Product Video Workflow (for Agents)

## Intent

User wants to create a product video with a script-first confirmation approach: generate script → user approves → generate code → render.

Triggers: `/video`, `product video`, `video script`, `tutorial video`, `demo video`, `product update video`, `video workflow`

---

## Workflow Architecture: 4 Phases

This workflow is designed for **token efficiency** by separating concerns and deferring context injection.

### Visual Flow Diagram

```
USER REQUEST: /video [topic]
       ↓
╔══════════════════════════════════════════════╗
║  PHASE 1: Script Generation (Lightweight)    ║
║  ────────────────────────────────────────   ║
║  Load: workflows/ + PRD + decisions/        ║
║  Generate: Pure-text script (YAML/MD)       ║
║  Output: script.yaml                        ║
║  Tokens: ~1300 | Time: ~5 min               ║
╚════════════════┬═════════════════════════════╝
                 ↓
╔════════════════════════════════════════════╗
║  [APPROVAL GATE] User Reviews Script       ║
║  ────────────────────────────────────────  ║
║  Options:                                  ║
║  ├─ ✓ Continue → Phase 3                  ║
║  ├─ ✎ Revise → Phase 2                    ║
║  └─ ↻ Restart → Re-Phase 1                ║
║                                            ║
║  KEY: Do NOT generate code before approval ║
╚════════════════╤════════════════════════════╝
                 ↓
╔════════════════════════════════════════════╗
║  PHASE 2: Script Revision (Optional)       ║
║  ────────────────────────────────────────  ║
║  Input: User's change requests             ║
║  Modify: Only changed scenes               ║
║  Output: Updated script                    ║
║  Tokens: ~600 | Time: ~3 min               ║
║  → Back to Approval Gate                   ║
╚════════════════╤════════════════════════════╝
                 ↓
╔════════════════════════════════════════════╗
║  PHASE 3: Code Generation (Rich Context)   ║
║  ────────────────────────────────────────  ║
║  PREREQUISITE: Script is APPROVED ✓        ║
║                                            ║
║  Load:                                     ║
║  • Approved script (read, don't regen)    ║
║  • facts/product.md (brand colors)        ║
║  • assets/ (image refs)                   ║
║  • Related PRD                             ║
║                                            ║
║  Generate:                                 ║
║  • React scene components                  ║
║  • Brand constants injection               ║
║  • Timeline composition                    ║
║                                            ║
║  Output: VideoScene.tsx                    ║
║  Tokens: ~2200 | Time: ~2 min              ║
╚════════════════╤════════════════════════════╝
                 ↓
╔════════════════════════════════════════════╗
║  PHASE 4: Local Render & Persist           ║
║  ────────────────────────────────────────  ║
║  User runs locally:                        ║
║  $ npm install remotion ffmpeg-static     ║
║  $ npx remotion preview                    ║
║  $ npx remotion render out.mp4             ║
║                                            ║
║  Save to knowledge repo:                   ║
║  ~/team-knowledge/assets/videos/YYYY-MM-DD ║
║                                            ║
║  Time: ~10 min (incl. rendering)           ║
╚════════════════╤════════════════════════════╝
                 ↓
        ┏━━━━━━━━━━━━━━━━━━━━┓
        ┃  COMPLETE ✓ out.mp4 ┃
        ┃  Total Time: 15 min  ┃
        ┃  Total Tokens: 3500- ┃
        ┃           4100       ┃
        ┗━━━━━━━━━━━━━━━━━━━━┛

KEY DESIGN POINTS:
• Separate script from code (different context)
• Approval gate prevents wrong-direction code gen
• Script persistence supports resumption
• Phase 3 reads script, never regenerates
• Token efficiency through staged loading
```

### Phase 1: Script Generation (Lightweight Context)

**Goal**: Generate a pure-text script (YAML or Markdown), let user confirm, **then stop**.

**Context to load** (minimal):
- `workflows/*.yaml` — interaction definitions
- `approved-prds/[feature].md` — product feature description
- `decisions/` — relevant product decisions
- User's specified feature/use case

**Context to NOT load**:
- Brand colors, logo paths, asset lists
- Full product knowledge base
- Implementation details
- Code templates

**Output**: Script file (example structure below)

```yaml
video_metadata:
  title: "Feature Demo"
  duration_seconds: 30
  fps: 30
  scene_count: 4

scenes:
  - id: 1
    name: "opening"
    duration_seconds: 3
    text: "Main headline"
    animation: "fade_in, scale"
    notes: "Designer notes"
  
  - id: 2
    name: "demo"
    duration_seconds: 20
    text: "Feature walkthrough"
    animation: "slide_left"
    action: "Show interaction"
  
  - id: 3
    name: "benefit"
    duration_seconds: 5
    text: "Core value proposition"
    animation: "highlight"
  
  - id: 4
    name: "closing"
    duration_seconds: 2
    text: "CTA"
    animation: "fade_out"

design_notes: |
  - Color tone: tech-forward
  - Scene 2 is critical: show fluidity
  - Consider background music
```

**Critical**: After outputting script, ask for user confirmation before Phase 3:

```
Script generated:
[full script output]

🎬 Ready to confirm?
□ Yes, generate code (Phase 3)
□ Revise: [describe changes]
□ Restart: [new direction]
```

**Do not proceed to Phase 3 until user explicitly confirms or says "continue".**

### Phase 2: Script Revision (Optional, Lightweight)

If user says "revise script":
- Re-run Phase 1 script generation for **modified scenes only**
- Keep already-approved scenes unchanged
- Output new script, ask for re-confirmation

**Token saving**: Do NOT load brand/asset context; the script gen doesn't need it.

---

### Phase 3: Code Generation (Deferred, Assumes Script Approved)

**Prerequisite**: User has confirmed script in Phase 1 or Phase 2. Script is marked APPROVED.

**Goal**: Generate complete production-ready Remotion TypeScript code.

**Context to load** (on top of approved script):
- ✅ Approved script content (read, don't regenerate)
- ✅ `facts/product.md` — brand colors, logo paths, product info
- ✅ Available assets in `assets/` or image references
- ✅ Related PRD and workflows (brief reference)

**Do NOT**:
- Regenerate the script
- Ask about scenes or timing (already confirmed)
- Re-read the full knowledge base

**Output**: `VideoScene.tsx` (complete Remotion component)

#### Code Generation Steps

1. **Extract Script Timeline**
   ```
   Read from approved script:
   - Scene durations
   - Text content per scene
   - Animation types
   - Designer notes
   
   Do NOT: Ask user again about these; they're already confirmed.
   ```

2. **Inject Brand Constants**
   ```typescript
   // Fetch from facts/product.md
   const BRAND = {
     colorPrimary: '#8DC8E8',
     colorAccent: '#FF7F32',
     background: '#F8F6F3',
     logoPath: './assets/logo.png',
   };
   ```

3. **Build Scene Components**
   ```typescript
   // One component per script scene
   const SceneOpening = ({ from, durationInFrames }) => (
     <Sequence from={from} durationInFrames={durationInFrames}>
       <Text fontSize={48} fill={BRAND.colorPrimary}>
         {/* text from script scene 1 */}
       </Text>
     </Sequence>
   );
   
   const SceneDemo = ({ from, durationInFrames }) => (
     // similar structure for scene 2
   );
   ```

4. **Compose Timeline**
   ```typescript
   export const ProductVideo: React.FC = () => {
     const fps = 30;
     const totalSeconds = 30;  // from script metadata
     const durationInFrames = totalSeconds * fps;
     
     return (
       <Composition
         component={MainVideoComposition}
         durationInFrames={durationInFrames}
         fps={fps}
         width={1920}
         height={1080}
         id="ProductVideo"
       />
     );
   };
   ```

5. **Provide Asset Checklist**
   ```
   Required files:
   - logo.png (1920x1080, optional)
   - Background or product screenshots (optional)
   
   Placement: ./assets/[filename]
   ```

---

### Phase 4: Render & Persistence

User runs locally:
```bash
npm install remotion ffmpeg-static
npx remotion preview src/VideoScene.tsx
npx remotion render src/VideoScene.tsx out.mp4
```

Then save to knowledge repo:
```bash
mkdir -p ~/team-knowledge/assets/videos/YYYY-MM-DD-feature-name/
cp out.mp4 ~/team-knowledge/assets/videos/YYYY-MM-DD-feature-name/
cp script.md ~/team-knowledge/assets/videos/YYYY-MM-DD-feature-name/
cp src/VideoScene.tsx ~/team-knowledge/assets/videos/YYYY-MM-DD-feature-name/source.tsx
```

---

## Token Efficiency Mechanisms

| Mechanism | How It Saves Tokens |
|-----------|-------------------|
| **Script-Code Separation** | Script generation uses only workflows + PRD (small). Code generation uses brand + assets (once). Never load both together. |
| **User Confirmation Gate** | Stop after Phase 1, don't generate code if user disagrees with direction. Prevents wasted tokens on wrong code. |
| **Persistent Script** | Save approved script to knowledge repo. User can resume across sessions without re-describing. |
| **No Script Regeneration** | Phase 3 reads approved script, doesn't regenerate. Phase 2 modifies only specific scenes. |
| **Context Injection Timing** | Brand/asset context loaded only in Phase 3, when script is locked. Small overhead per phase. |
| **Lightweight Agent for Phase 1** | Use simpler agent for script (less reasoning), specialized agent for code (more reasoning, but once only). |

---

## Detailed Implementation Guide

### For Phase 1 (Script Generation)

```
1. Sync knowledge repo
2. Load only:
   - workflows/ directory
   - approved-prds/ (matching feature)
   - decisions/ (matching feature)
3. For each scene in the interaction flow:
   - Extract: what happens, how long, what user sees
   - Write: scene_id, name, duration, text, animation, notes
4. Output script YAML
5. **STOP AND ASK FOR CONFIRMATION**
   Do not call Phase 3 automatically.
```

### For Phase 2 (Script Revision, If Needed)

```
1. User says "revise: change scene 2 to 25 seconds, add AI mention"
2. Load same lightweight context as Phase 1
3. For modified scenes ONLY:
   - Regenerate that scene
   - Keep others unchanged
4. Output new script
5. **STOP AND ASK FOR RE-CONFIRMATION**
```

### For Phase 3 (Code Generation)

```
1. Verify: User has confirmed script (Phase 1 or 2)
2. Load:
   - Approved script (read from output/saved file, don't regenerate)
   - facts/product.md (brand)
   - assets/ directory listing
   - Related PRD (brief)
3. For each script scene:
   - Convert to React component
   - Timeline: Sequence from/durationInFrames
   - Text/animation from script
4. Inject brand constants
5. Compose all scenes
6. Output VideoScene.tsx
7. Provide asset checklist and run instructions
```

---

## Integration with Other HiveMind Workflows

### Before `/video`: `/gtm` for Market Positioning
```
/gtm dashboard analytics positioning
  → Generate marketing angles, value props

/video --script-from-gtm dashboard analytics
  → Use GTM output to inform script narrative
```

### After `/video`: `/email` for Announcement
```
/video [feature]
  → Generate video

/email product update with [video.mp4]
  → Generate email HTML with video preview
```

---

## Interaction Model

### Happy Path
```
User: /video dashboard demo, 30 seconds
Agent: 
  [Phase 1: Script Generation]
  Script generated:
  [full YAML]
  
  Ready to confirm? (Yes/Revise/Restart)

User: Yes, continue

Agent:
  [Phase 3: Code Generation]
  Code generated: VideoScene.tsx
  [setup instructions]

User: Local render → out.mp4
```

### Revision Path
```
User: /video dashboard demo, 30 seconds
Agent: [Phase 1 script]

User: Revise: scene 2 should emphasize data drill-down

Agent:
  [Phase 2: Revised script, scene 2 updated]
  
  Confirm? (Yes/Revise again/Restart)

User: Yes, continue

Agent: [Phase 3: Code]
```

---

## Error Handling

| Scenario | Action |
|----------|--------|
| No workflows found for feature | Prompt user to describe interaction manually |
| PRD missing | Proceed with workflows alone; ask user for feature description |
| User silent after script output | Remind them to confirm before proceeding |
| User asks for code changes after Phase 3 | VideoScene.tsx is open for editing; help them modify specific sections |
| Rendering fails locally | Troubleshoot: FPS, frame count, asset paths |

---

## Output Checklist

**Phase 1 Output:**
- [ ] Script file (YAML or Markdown)
- [ ] Confirmation prompt (don't auto-proceed)

**Phase 2 Output (if revised):**
- [ ] Updated script with changes
- [ ] Re-confirmation prompt

**Phase 3 Output:**
- [ ] `VideoScene.tsx` (complete, production-ready)
- [ ] Asset checklist
- [ ] Setup + render instructions
- [ ] Optional: Example run commands

**Phase 4 (User's Local):**
- [ ] out.mp4 (rendered video)
- [ ] Script + source code in knowledge repo (optional but recommended)

---

## Key Principles

1. **Defer context injection**: Load only what each phase needs.
2. **Stop at confirmation gates**: Phase 1 → confirm → Phase 3. No auto-proceed.
3. **Never regenerate confirmed artifacts**: Script is locked after confirmation.
4. **Lightweight early, rich later**: Script uses simple context; code uses rich context once.
5. **Persistent intermediate state**: Save script to knowledge repo for resume-ability.

---

## When NOT to Use This Workflow

- User wants one-off, throw-away video → `/video` is overkill
- User wants full autonomy (don't want to confirm) → Still use `/video`, but auto-skip Phase 1 confirmation if user explicitly says "auto-proceed"
- User is in a hurry (< 5 min) → Consider `/video --fast` that combines phases (trade token for speed)

---

## Comparison: Script-First vs. Script-Later

| Aspect | Script-First (`/video`) | Script-Later (direct code) |
|--------|----------------------|--------------------------|
| **Confirmation** | Phase 1 → User approves → Phase 3 | No intermediate check, risk of wrong code |
| **Revision** | Easy (just text), lightweight | Requires regenerating code |
| **Token usage** | 2 small calls (script + code), fewer wasted tokens | 1 large call, risk of needing redo |
| **Designer experience** | Confirms narrative before seeing code | Sees code, might have feedback on narrative |
| **Time** | Slightly slower (2 phases), but safer | Faster if right first time, slower if need redo |

Script-first is **safer and more token-efficient** for complex videos.
