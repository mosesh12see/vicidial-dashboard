# 📅 Vicidial Time Machine - Go Back in Time!

## The Problem You Had
You asked: "can we not look at what it was like at the beginning of the day when it was yesterdays view correct? like go back in time?"

**Answer**: NO - because the database only has CURRENT data. Once calls keep coming in, yesterday's numbers change.

## The Solution

I created a **Daily Snapshot System** that saves data every day so you can go back in time!

---

## How to Use It

### 1. Create a snapshot for today
```bash
cd /Users/mosesherrera/Desktop/vicidial-analysis
python3 daily_snapshot.py --save 2025-11-07
```

### 2. View a snapshot from the past
```bash
python3 daily_snapshot.py --restore 2025-11-06
```

### 3. List all available snapshots
```bash
python3 daily_snapshot.py --list
```

### 4. Save yesterday's snapshot (default)
```bash
python3 daily_snapshot.py
```

---

## What Gets Saved

Each snapshot saves:
- **JSON file** with all metrics (calls, opt-ins, sales, minutes)
- **HTML file** copy of your dashboard
- Stored in: `/Users/mosesherrera/Desktop/vicidial-analysis/snapshots/YYYY-MM-DD/`

Example structure:
```
snapshots/
├── 2025-11-06/
│   ├── metrics.json
│   └── deep-analysis.html
├── 2025-11-07/
│   ├── metrics.json
│   └── deep-analysis.html
```

---

## Automate It! (Run Every Day at Midnight)

Add this to your crontab to save snapshots automatically:

```bash
# Open crontab editor
crontab -e

# Add this line (saves yesterday's data at midnight every day)
0 0 * * * cd /Users/mosesherrera/Desktop/vicidial-analysis && /opt/homebrew/bin/python3 daily_snapshot.py

# Save and exit (press ESC, then :wq in vim)
```

Now every morning you'll have yesterday's snapshot saved!

---

## Examples

### Save snapshots for the last week
```bash
python3 daily_snapshot.py --save 2025-11-01
python3 daily_snapshot.py --save 2025-11-02
python3 daily_snapshot.py --save 2025-11-03
python3 daily_snapshot.py --save 2025-11-04
python3 daily_snapshot.py --save 2025-11-05
python3 daily_snapshot.py --save 2025-11-06
python3 daily_snapshot.py --save 2025-11-07
```

### Compare two dates
```bash
python3 daily_snapshot.py --restore 2025-11-05
python3 daily_snapshot.py --restore 2025-11-06
```

---

## Important Notes

- **Correct definitions are used**: Opt-ins = ALL 6 statuses, Sales = ONLY 'SALE'
- Snapshots are frozen in time - they won't change
- You can go back and see exactly what the numbers were on any day
- The HTML file in each snapshot is a full copy you can open in a browser

---

## Why This is Better Than Just Querying the Database

The database only has RAW call records. As new calls come in throughout the day, the aggregated numbers change.

With snapshots:
- ✅ You can see what the dashboard looked like at end-of-day
- ✅ You can compare day-to-day trends
- ✅ You have a backup if something goes wrong
- ✅ You can audit historical data

---

## Quick Reference

| Command | What it does |
|---------|-------------|
| `python3 daily_snapshot.py` | Save yesterday's snapshot |
| `python3 daily_snapshot.py --save 2025-11-07` | Save specific date |
| `python3 daily_snapshot.py --restore 2025-11-06` | View snapshot |
| `python3 daily_snapshot.py --list` | List all snapshots |
