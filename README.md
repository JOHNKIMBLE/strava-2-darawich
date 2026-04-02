# Strava-2-Dawarich

Pull Strava activities as GPX files and push them into [Dawarich](https://github.com/Freika/dawarich) for location tracking.

## How It Works

1. Authenticates with Strava via OAuth (opens your browser)
2. Fetches activities and their GPS streams from the Strava API
3. Converts each activity to a GPX file (includes HR, cadence, power, temp if available)
4. Optionally pushes GPX files to Dawarich's import API

On first run, a baseline date is set to **now** — only future activities are synced. Use `--days`, `--months`, or `--all` to pull historical data.

## Prerequisites

- Python 3.8+
- A [Strava API Application](https://www.strava.com/settings/api) with:
  - **Authorization Callback Domain**: `localhost`
- (Optional) A running Dawarich instance with an API key

## Setup

```bash
# Clone and install
git clone https://github.com/JOHNKIMBLE/strava-2-darawich.git
cd strava-2-darawich
pip install -r requirements.txt
```

### Option A: `.env` file (quickest)

```bash
cp .env.example .env
# Edit .env with your values
```

### Option B: Interactive setup

```bash
python strava_gpx.py setup
```

Both methods work — `.env` takes priority if both exist.

### Virtual Rides (Zwift, etc.)

Virtual rides report GPS from the virtual world (New Caledonia, London, etc.), which creates huge "teleport" distances in Dawarich between your real location and the virtual one. The script auto-detects virtual activities (`VirtualRide`, `VirtualRun`) and relocates their GPS to your home coordinates — preserving the ride's shape, distance, and sensor data without the teleport.

Home location is resolved automatically in this order:

1. `HOME_LOCATION` in `.env` (e.g. `HOME_LOCATION=41.8781,-87.6298`)
2. A place named "Home" in your Dawarich instance (via the Places API)
3. Interactive prompt — the script asks for your city/address, geocodes it, and saves to `.env`

Once set, it's cached in `.env` and never asked again.

Then authorize with Strava:

```bash
python strava_gpx.py auth
```

## Usage

### Sync new activities

```bash
# Sync activities since last run
python strava_gpx.py sync

# Sync but don't push to Dawarich
python strava_gpx.py sync --no-push
```

### Pull historical data

```bash
# Last 30 days
python strava_gpx.py sync --days 30

# Last 6 months
python strava_gpx.py sync --months 6

# Everything
python strava_gpx.py sync --all
```

### Push existing GPX files to Dawarich

```bash
# Push all files from gpx_output/
python strava_gpx.py push

# Push from a custom directory
python strava_gpx.py push --dir /path/to/gpx/files
```

## Automating with Cron (Unraid User Scripts)

Add a User Script on Unraid to sync on a schedule:

```bash
#!/bin/bash
cd /path/to/Strava-2-Darawich
python3 strava_gpx.py sync
```

Set the schedule (e.g., every 6 hours) in the User Scripts plugin.

## Files

| File | Purpose |
|------|---------|
| `strava_gpx.py` | Main script |
| `.env` | Strava/Dawarich credentials (git-ignored) |
| `.env.example` | Template for `.env` |
| `config.json` | Alternative to `.env` — created by `setup` (git-ignored) |
| `token.json` | OAuth tokens (git-ignored) |
| `state.json` | Tracks last sync time and fetched activity IDs (git-ignored) |
| `gpx_output/` | Generated GPX files (git-ignored) |

## Rate Limits

Strava API allows 100 requests per 15 minutes and 1,000 per day. Each activity requires 2 API calls (list + streams). The script includes built-in rate limiting delays.
