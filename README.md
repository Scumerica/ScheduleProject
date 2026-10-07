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

Click **Test Mode** in the top bar to load a sample office.
