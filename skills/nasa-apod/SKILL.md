---
name: nasa-apod
description: "NASA Astronomy Picture of the Day. Use when the user asks about space, astronomy, NASA photos, today's space image, celestial objects, nebulae, galaxies, planets, or a specific date in the APOD archive."
metadata: { "openclaw": { "requires": { "bins": ["curl"] } } }
---

# NASA Astronomy Picture of the Day Skill

Fetch and explore NASA's Astronomy Picture of the Day archive. The APOD API
returns public NASA imagery, videos, titles, dates, and explanations.

Use live API calls. Do not invent APOD titles, URLs, dates, or explanations.

## API Endpoint

Base URL:

```text
https://api.nasa.gov/planetary/apod
```

Default public API key:

```text
DEMO_KEY
```

If `NASA_API_KEY` is set in the environment, use that instead of `DEMO_KEY`.

## Commands

Today's APOD:

```bash
curl -s "https://api.nasa.gov/planetary/apod?api_key=${NASA_API_KEY:-DEMO_KEY}&thumbs=true"
```

Specific date:

```bash
curl -s "https://api.nasa.gov/planetary/apod?api_key=${NASA_API_KEY:-DEMO_KEY}&date=YYYY-MM-DD&thumbs=true"
```

Date range:

```bash
curl -s "https://api.nasa.gov/planetary/apod?api_key=${NASA_API_KEY:-DEMO_KEY}&start_date=YYYY-MM-DD&end_date=YYYY-MM-DD&thumbs=true"
```

Random selection:

```bash
curl -s "https://api.nasa.gov/planetary/apod?api_key=${NASA_API_KEY:-DEMO_KEY}&count=N&thumbs=true"
```

Dates must be between 1995-06-16 and today.

## Response Fields

- `title` - image or video title
- `date` - APOD publication date
- `explanation` - NASA's expert description
- `url` - standard resolution image or video URL
- `hdurl` - high resolution image URL, when available
- `media_type` - `image` or `video`
- `thumbnail_url` - video thumbnail when `thumbs=true`
- `copyright` - creator credit when present

## Presenting Results

For a single APOD entry, include:

- title
- date
- media type
- image/video URL, preferring `hdurl` when present
- a concise summary in your own words
- copyright credit when present

For videos, include the video URL and thumbnail URL if available.

For multiple entries, use a numbered list with title, date, media type, URL,
and a one-line summary for each result.

## Safety

This skill is read-only. It fetches publicly available NASA data. There are no
side effects and no required secrets.

