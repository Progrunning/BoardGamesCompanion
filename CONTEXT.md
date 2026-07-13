# Board Games Companion

A companion app for board game players — a Flutter mobile app backed by a Search API that fronts BoardGameGeek (BGG) data.

## Language

### Deployment

**Release**:
A specific build of the Search API, identified by the short git SHA of the commit it was built from. One release = one immutable image tag.
_Avoid_: Build, version, build ID

**Color**:
One of the two interchangeable production slots for the Search API — blue or green. Exactly one color serves traffic at steady state.

**Active color**:
The color currently receiving production traffic. The reverse-proxy site snippet is the single source of truth for which color is active.
_Avoid_: Live container, current deployment

**Cutover**:
The act of switching production traffic from the active color to the freshly deployed one, performed only after the new color proves healthy.
_Avoid_: Swap, switch-over, flip (in docs; "flip" is fine in conversation)

**Rollback**:
Deploying a previously released image tag through the normal deploy path. A rollback is an ordinary deploy pointed at an old release, not a special mechanism.
