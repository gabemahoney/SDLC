# Apiary: who runs which skill (b.v38)

- **Managing Intelligence:** runs no skills itself. It starts one Main Agent per skill.
- **Main Agent skills that launch no Child Agents:** project-setup, write-idea, write-bug, define-bug, research, configure-worktree, teardown-worktree, release.
- **Main Agent skills that launch Child Agents:** one diagram each below.

## write-prd

```mermaid
flowchart LR
  M["write-prd<br/>(Main Agent)"]
  M --> C0["req-review"]
```

## write-srd

```mermaid
flowchart LR
  M["write-srd<br/>(Main Agent)"]
  M --> C0["model-writer"]
  M --> C1["model-review"]
  M --> C2["research"]
  M --> C3["req-review"]
```

## write-plan

```mermaid
flowchart LR
  M["write-plan<br/>(Main Agent)"]
  M --> C0["product-manager"]
```

## write-epic

```mermaid
flowchart LR
  M["write-epic<br/>(Main Agent)"]
  M --> C0["engineer-planner"]
  M --> C1["test-writer-planner"]
  M --> C2["doc-writer-planner"]
  M --> C3["product-manager"]
```

## develop-epic

```mermaid
flowchart LR
  M["develop-epic<br/>(Main Agent)"]
  M --> C0["engineer"]
  M --> C1["test-writer"]
  M --> C2["doc-writer"]
  M --> C3["code-review"]
  M --> C4["test-review"]
  M --> C5["doc-review"]
  M --> C6["product-manager"]
```

## fix-bug

```mermaid
flowchart LR
  M["fix-bug<br/>(Main Agent)"]
  M --> C0["engineer"]
  M --> C1["test-writer"]
  M --> C2["doc-writer"]
  M --> C3["code-review"]
  M --> C4["test-review"]
  M --> C5["doc-review"]
```

## idea-review

```mermaid
flowchart LR
  M["idea-review<br/>(Main Agent)"]
  M --> C0["code-review"]
  M --> C1["test-review"]
  M --> C2["doc-review"]
  M --> C3["product-manager"]
```

req-review is a Child Agent skill. Other Child Agent skill names are placeholders until those skills are written.
