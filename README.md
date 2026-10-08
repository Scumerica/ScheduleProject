# Modular Scheduling System

A single-page scheduler that assigns office staff to positions, stations and break times for each work day, and keeps the load fair from week to week.

## Running it

Double-click `Launch_Scheduler.bat`. It opens `Data/scheduler.html` in Microsoft Edge as an app window. No install or internet connection is needed.

## Layout

| Path | Contents |
| --- | --- |
| `Launch_Scheduler.bat` | Launcher |
| `Data/scheduler.html` | The whole application (HTML, CSS and JavaScript in one file) |
| `Storage/` | Where the Save button writes dated schedule files. These are not tracked in git because they contain staff names and private notes |

## How it schedules, in short

- Each role has a Required count per day, a Max Rot (most days in a row) and a Break Rot (rest days afterwards). All are in days.
- Positions are handed out at the start of the week and held all week. Each day only adjusts for who is out, with a one-day stand-in.
- Roles are filled in hierarchy order. Roles marked equal share any shortage.
- Picks go to whoever has gone longest without a weekly position.
- A holder who is out three or more days of their week is put back on the same role the next week.

## Appointments to publish

**Settings** holds the appointment groups: a tree, up to 5 levels deep, of groups and the appointment types inside them (Short, Long, Class C road test, CDL road test). Each group is ticked with the positions that staff it, and each item carries a weight from 0 to 100%.

**Views ▾ Appointments to Publish** shows the result for each day of this week and the next three:

- A group's time is the staff the schedule puts in its positions, multiplied by the hours they serve (appointment hours or road test hours), less their breaks.
- That time is shared among the group's items by weight. Weights under 100% hold the rest back.
- An appointment type's time divided by its transaction time limit is the number to publish.

This reads the staff schedule; it does not change who works where.

Click **Test Mode** in the top bar to load a sample office.
