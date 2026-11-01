# Planning

Tracks planning-with-files (PWF) artifacts for structured task execution. This repo is public, so everything here is public too.

## Structure

    planning/
      active/           <- Current work-in-progress PWF files
        task_plan.md
        findings.md
        progress.md
      archive/          <- Completed issues
        YYYY-MM-issue-N-slug/

## Skills

- `/planning-init <N>` - start issue N (branch + PWF baseline derived from the issue body)
- `/planning-update` - sync checkboxes mid-session
- `/planning-archive` - archive completed work, create fresh active/
