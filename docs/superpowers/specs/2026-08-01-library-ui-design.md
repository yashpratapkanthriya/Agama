# Library UI Overhaul Design Spec

## Context
The current Library UI relies on a misleading "Paste text to read" button that opens a bottom sheet with mixed responsibilities (file picking, text pasting, and engine selection). This violates frontend design principles of self-explanatory, intuitive controls.

## Design Goals
1. **Direct Input:** Remove the modal entirely. Expose inputs directly on the main screen.
2. **Clear Intent:** Separate the action of *providing content* from *choosing the reading engine*.
3. **Premium Aesthetics:** Maintain the Impeccable guidelines (AgamaTheme colors, JetBrains Mono, 12px radius).

## Architecture & Layout

### 1. Hero Input Section
Instead of a single button opening a sheet, the hero section will contain two distinct input areas:
- **File Dropzone/Picker:** A large, clearly labeled area/button to pick `.pdf`, `.epub`, or `.md` files. State changes when a file is selected (shows filename).
- **Text Area:** A direct text input field for pasting raw text.

### 2. Engine Selection Section
Directly below the inputs:
- Label: "Read with:"
- Three engine cards: RSVP, Sweep, Bionic.
- **Behavior:** Clicking an engine card triggers the reading session.
- **Validation:** If no file is picked and the text area is empty, clicking an engine card highlights the input areas with an error state (e.g., crimson border or shake animation) indicating input is required.

### 3. Library Section (Recent Documents)
- Maintained at the bottom of the screen.
- Later to be integrated with real storage (out of scope for this UI pass).

## Implementation Details
- **File Modification:** `apps/flutter_client/lib/src/features/library/library_view.dart`
- **State Management:** Add local state (`StatefulWidget`) to track the currently picked file (`PlatformFile?`) or the text content.
- **Dependency:** `file_picker` is already installed and will be utilized.

## Error Handling
- Invalid file types rejected by the picker.
- Empty state handled by visual validation cues on the engine buttons.

## Out of Scope
- Backend storage of library files (handled in a separate DB task).
