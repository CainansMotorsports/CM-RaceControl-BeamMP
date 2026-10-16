# CM-RaceControl-BeamMP
# Cainan's Motorsports Race Control

A custom multiplayer racing management system for BeamMP and BeamNG.drive.

## Overview

Cainan's Motorsports Race Control is being developed for Crowley's Ridge Raceway and future multiplayer dirt racing events.

The system will provide automatic race scoring, driver registration, live leaderboards, race director controls, and persistent track records.

## Planned Features

- **Live Leaderboard:** Driver positions, completed laps, and fastest lap times.
- **Race Registration:** Driver registration with Race Director approval and removal.
- **Race Management:** Race starts, restarts, randomized starting grids, and manual adjustments.
- **Flag Controls:** Green, yellow, and red flags with frozen scoring during cautions and stoppages.
- **Automatic Lap Timing:** Checkpoint-based lap validation and timing.
- **All-Time Track Record:** Persistent fastest valid lap with the record holder's BeamMP username.
- **Custom UI:** Expandable leaderboard, registration interface, and separate Race Director controls.

## Track Checkpoints

The racing system is designed to recognize these BeamNGTrigger objects:

- `CM_Race_StartZone`
- `CM_Race_FinishLine`
- `CM_Race_CP1`
- `CM_Race_CP2`
- `CM_Race_CP3`
- `CM_Race_CP4`
- `CM_Race_CP5`

## Architecture

The planned system includes a server-side Lua plugin for multiplayer scoring and synchronization, plus a client-side interface for race information and registration.

## Development Status

**In development.** The full multiplayer scoring system is not yet implemented or verified.

## Hosting

The project is intended for deployment on a BeamMP server hosted by Assetto Hosting, subject to plugin review and approval.
