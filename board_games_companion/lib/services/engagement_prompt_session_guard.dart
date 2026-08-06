/// Ensures the user is shown at most one engagement prompt (Rate & Review or
/// Support) per app session, so the app never stacks asks in front of them.
///
/// There's no existing app-wide session concept in this codebase, so this is
/// deliberately a simple in-memory flag: it starts false on every cold start
/// and is flipped once either prompt is actually shown to the user.
class EngagementPromptSessionGuard {
  EngagementPromptSessionGuard._();

  static bool promptShownThisSession = false;

  static void reset() {
    promptShownThisSession = false;
  }
}
