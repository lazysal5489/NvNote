# NvNote

A local-first,Markdown note-taking app for mobile,built with Flutter.Notes are stored as plain `.md` file on the device - no account,no cloude sync,no server.

## Overview

NvNote lets you write notes in Markdown and organize them without relying on folders:tag notes,link one note to another,and search across everything you've written.Everything stays on the device as plain,portable files.

## Features

- `Makrdown notes` - create and edit notes with standard Markdown formatting.
- `Tag` - attach tags to notes to group them by topic: duplicate/blank tag are rejected.
- `Note linking` - link notes with `[[Note Tiltle]]` syntax;linked notes show backlinks,and links to a renamed/deleted note are flagged as broken.
- `Search` - search notes by title, content, or tag,with tile matches ranked first.
- `offline-first` - works entirely without internet;notes live in the app's local storage folder by default.

## Planned / stretch

- Custom vault folder picking(chose any folder on the device,not just app default).
- Mermaid diagram rendering inside notes.

## Tech stack

| Layer | Choice |
| --- | --- |
| Framwork | Flutter (Dart) |
| Platform | Android / Ios(in the future) |
| Storage | Local file system (`.md` files) |
| State management | None - built-in `Statefulwidget` / `setState` |

## Architecture

The code is split into four layers so the ui never touches storage directly:

```text
lib/
  models/     # Note, Tag, Folder, Vault — plain Dart, no Flutter imports
  services/   # NoteLinkService, TagService — business rules, unit-testable
  data/       # VaultStorage — reads/writes .md files
  screens/    # NoteListScreen, NoteEditorScreen, TagsScreen, SearchScreen
  widgets/    # Reusable UI pieces (NoteCard, TagChip, ...)
```

`screens` -> `services` -> `data` -> `models`.business logic lives in services,independent of any widget,so it can be unit tested on it own.

## Getting started

### Prerequisites

- Flutter SDK
- Android Studio / Xcode,or a connected device / emulator

### Run it locally

```bash
git clone https://github.com/lazysal5489/NvNote.git
cd nvnote
flutter pub get
flutter run
```

## Team

- lazysal5489(archay)
