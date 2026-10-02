# Scoring rules

Implemented in `lib/domain/scoring/activity_score.dart`. Points are never taken from a timer.

## Choice activities

Maths, words, patterns, and knowledge:

| Result | Points | Stars |
|---|---:|---:|
| No miss and no hint | 10 | 3 |
| A miss, no hint | 7 | 2 |
| A hint was used | 5 | 1 |

## Matching

| Result | Points | Stars |
|---|---:|---:|
| No miss and no hint | 12 | 3 |
| A miss, no hint | 8 | 2 |
| A hint was used | 6 | 1 |

## Mazes

| Result | Points | Stars |
|---|---:|---:|
| No wrong step and no hint | 12 | 3 |
| A wrong step, no hint | 9 | 2 |
| A hint was used | 6 | 1 |

## Spot the difference

| Result | Points | Stars |
|---|---:|---:|
| No miss and no hint | 12 | 3 |
| A miss, no hint | 8 | 2 |
| A hint was used | 5 | 1 |

## Tic-Tac-Toe

A win, draw, or loss can finish the round. Only a win with no hint counts as mastery, and that result is not written into the logic skill.

| Result | Points before a hint | Stars |
|---|---:|---:|
| Win | 10 | 3 |
| Draw | 6 | 2 |
| Loss | 4 | 1 |

A hint lowers the points by 2, with a floor of 1, and lowers the stars by 1, with a floor of 1.

## Badges and replays

The first finish of an activity id writes one row in `level_badges`. The badge id is `level:` plus the activity id. Replays do not add another row. The saved best score and best stars only move upward. The first result summary is kept. Original milestone badges, including Maze Explorer and the six-game sticker, still use their previous targets. Tic-Tac-Toe and Knowledge do not count toward the six-game sticker.
