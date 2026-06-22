# UI Draft Workflow

Use for `/ui-draft`, clickable prototypes, interaction YAML, workflow editing, or Figma handoff.

## Inputs

First execute `knowledge-sync.md`. The workflow must try to clone or pull `https://github.com/your-org/team-knowledge.git` before reading workflow YAML, PRD context, or prototypes.
Then execute `active-memory.md` to load relevant UX, workflow, component, validation, copy, and prototype rules.

Default workflow file:

`~/team-knowledge/features/[feature]/workflow.yaml`

Legacy fallback:

`~/team-knowledge/workflows/[feature].yaml`

If no workflow exists, infer a minimal workflow from the PRD or ask the user whether to draft one.
Also load matching `memory/rules/` and recent `memory/sessions/` notes before changing workflow structure.

## Generate HTML Prototype

1. Read and parse `features/[feature]/workflow.yaml`, falling back to `workflows/[feature].yaml` if the feature workspace does not exist yet.
2. Map `states` to UI views.
3. Map `display` components to HTML controls.
4. Map `actions` and `flow` to click transitions.
5. Map `validation` to inline form validation.
6. Write a single self-contained file to `features/[feature]/prototype.html`.
7. If a legacy `prototypes/[feature].html` already exists, mention it but do not update both copies unless the user asks for legacy compatibility.

Supported components:

- `select`
- `file_upload`
- `table`
- `button`
- `alert`
- `progress_bar`
- `text_input`
- `textarea`
- `checkbox`
- `radio`

Prototype requirements:

- Responsive layout.
- Clickable state transitions.
- Mock data for result tables.
- At least one meaningful empty, loading, error, or permission state when relevant.
- CSV export only if the workflow includes downloadable results.

## Edit Workflow

When the user asks to edit a prototype or workflow:

1. Show the current workflow summary, not necessarily the full YAML.
2. Apply requested changes to `features/[feature]/workflow.yaml` when a feature workspace exists or is being created; otherwise update the legacy `workflows/[feature].yaml`.
3. Regenerate `features/[feature]/prototype.html`.
4. Summarize changed states, components, and validation.
5. Propose memory updates if the edit creates a reusable UX rule, validation principle, or unresolved workflow question.

Ask before overwriting if the workflow contains user edits that are not part of the request.

## View Prototype Info

When asked to view:

- Report workflow path.
- Report prototype path.
- Prefer `features/[feature]/workflow.yaml` and `features/[feature]/prototype.html`; include legacy paths only when those are the active source.
- Count states and components.
- Mention last modified time if available.

## Figma Handoff

Use Figma only if an available Figma tool or app exists in the current environment.

If native Figma creation is unavailable, produce a Figma-ready screen spec:

- Section name: `[feature] · [YYYY-MM-DD]`
- Screen/frame list.
- Navigation hierarchy.
- Component notes.
- State annotations.
- Copy deck.
- Prototype links or transition notes.

Never promise direct Figma file creation if the current tools cannot do it.

## Completion Message

Return:

- Path to the HTML prototype.
- Path to the feature workspace.
- Main path demonstrated.
- Major states included.
- What remains intentionally out of scope.
- Approved active memory updates, if any were written.
