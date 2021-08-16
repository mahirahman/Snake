# Snake in MIPS 🐍

Implementation of the classic video game Snake in low level MIPS Assembly Language 🕹️

[![Made with MIPS](data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxODAuNzkiIGhlaWdodD0iMzUiIHZpZXdCb3g9IjAgMCAxODAuNzkgMzUiPjxyZWN0IGNsYXNzPSJzdmdfX3JlY3QiIHg9IjAiIHk9IjAiIHdpZHRoPSIxMTUuMzEiIGhlaWdodD0iMzUiIGZpbGw9IiMzMUM0RjMiLz48cmVjdCBjbGFzcz0ic3ZnX19yZWN0IiB4PSIxMTMuMzEiIHk9IjAiIHdpZHRoPSI2Ny40Nzk5OTk5OTk5OTk5OSIgaGVpZ2h0PSIzNSIgZmlsbD0iIzM4OUFENSIvPjxwYXRoIGNsYXNzPSJzdmdfX3RleHQiIGQ9Ik0xNS42OSAyMkwxNC4yMiAyMkwxNC4yMiAxMy40N0wxNi4xNCAxMy40N0wxOC42MCAyMC4wMUwyMS4wNiAxMy40N0wyMi45NyAxMy40N0wyMi45NyAyMkwyMS40OSAyMkwyMS40OSAxOS4xOUwyMS42NCAxNS40M0wxOS4xMiAyMkwxOC4wNiAyMkwxNS41NSAxNS40M0wxNS42OSAxOS4xOUwxNS42OSAyMlpNMjguNDkgMjJMMjYuOTUgMjJMMzAuMTcgMTMuNDdMMzEuNTAgMTMuNDdMMzQuNzMgMjJMMzMuMTggMjJMMzIuNDkgMjAuMDFMMjkuMTggMjAuMDFMMjguNDkgMjJaTTMwLjgzIDE1LjI4TDI5LjYwIDE4LjgyTDMyLjA3IDE4LjgyTDMwLjgzIDE1LjI4Wk00MS4xNCAyMkwzOC42OSAyMkwzOC42OSAxMy40N0w0MS4yMSAxMy40N1E0Mi4zNCAxMy40NyA0My4yMSAxMy45N1E0NC4wOSAxNC40OCA0NC41NyAxNS40MFE0NS4wNSAxNi4zMyA0NS4wNSAxNy41Mkw0NS4wNSAxNy41Mkw0NS4wNSAxNy45NVE0NS4wNSAxOS4xNiA0NC41NyAyMC4wOFE0NC4wOCAyMS4wMCA0My4xOSAyMS41MFE0Mi4zMCAyMiA0MS4xNCAyMkw0MS4xNCAyMlpNNDAuMTcgMTQuNjZMNDAuMTcgMjAuODJMNDEuMTQgMjAuODJRNDIuMzAgMjAuODIgNDIuOTMgMjAuMDlRNDMuNTUgMTkuMzYgNDMuNTYgMTcuOTlMNDMuNTYgMTcuOTlMNDMuNTYgMTcuNTJRNDMuNTYgMTYuMTMgNDIuOTYgMTUuNDBRNDIuMzUgMTQuNjYgNDEuMjEgMTQuNjZMNDEuMjEgMTQuNjZMNDAuMTcgMTQuNjZaTTU1LjA5IDIyTDQ5LjUxIDIyTDQ5LjUxIDEzLjQ3TDU1LjA1IDEzLjQ3TDU1LjA1IDE0LjY2TDUxLjAwIDE0LjY2TDUxLjAwIDE3LjAyTDU0LjUwIDE3LjAyTDU0LjUwIDE4LjE5TDUxLjAwIDE4LjE5TDUxLjAwIDIwLjgyTDU1LjA5IDIwLjgyTDU1LjA5IDIyWk02Ni42NSAyMkw2NC42OCAxMy40N0w2Ni4xNSAxMy40N0w2Ny40NyAxOS44OEw2OS4xMCAxMy40N0w3MC4zNCAxMy40N0w3MS45NiAxOS44OUw3My4yNyAxMy40N0w3NC43NCAxMy40N0w3Mi43NyAyMkw3MS4zNSAyMkw2OS43MyAxNS43N0w2OC4wNyAyMkw2Ni42NSAyMlpNODAuMzggMjJMNzguOTAgMjJMNzguOTAgMTMuNDdMODAuMzggMTMuNDdMODAuMzggMjJaTTg2Ljg3IDE0LjY2TDg0LjIzIDE0LjY2TDg0LjIzIDEzLjQ3TDkxLjAwIDEzLjQ3TDkxLjAwIDE0LjY2TDg4LjM0IDE0LjY2TDg4LjM0IDIyTDg2Ljg3IDIyTDg2Ljg3IDE0LjY2Wk05Ni4yNCAyMkw5NC43NSAyMkw5NC43NSAxMy40N0w5Ni4yNCAxMy40N0w5Ni4yNCAxNy4wMkwxMDAuMDUgMTcuMDJMMTAwLjA1IDEzLjQ3TDEwMS41MyAxMy40N0wxMDEuNTMgMjJMMTAwLjA1IDIyTDEwMC4wNSAxOC4yMUw5Ni4yNCAxOC4yMUw5Ni4yNCAyMloiIGZpbGw9IiNGRkZGRkYiLz48cGF0aCBjbGFzcz0ic3ZnX190ZXh0IiBkPSJNMTI5LjcwIDIyTDEyNy41MCAyMkwxMjcuNTAgMTMuNjBMMTI5LjQ1IDEzLjYwTDEzMi40MSAxOC40NUwxMzUuMjkgMTMuNjBMMTM3LjI0IDEzLjYwTDEzNy4yNyAyMkwxMzUuMDkgMjJMMTM1LjA2IDE3LjU1TDEzMi45MCAyMS4xN0wxMzEuODUgMjEuMTdMMTI5LjcwIDE3LjY3TDEyOS43MCAyMlpNMTQ0LjgxIDIyTDE0Mi40MyAyMkwxNDIuNDMgMTMuNjBMMTQ0LjgxIDEzLjYwTDE0NC44MSAyMlpNMTUyLjM2IDIyTDE0OS45OCAyMkwxNDkuOTggMTMuNjBMMTUzLjgyIDEzLjYwUTE1NC45NiAxMy42MCAxNTUuODAgMTMuOThRMTU2LjY0IDE0LjM1IDE1Ny4xMCAxNS4wNlExNTcuNTYgMTUuNzYgMTU3LjU2IDE2LjcxTDE1Ny41NiAxNi43MVExNTcuNTYgMTcuNjYgMTU3LjEwIDE4LjM1UTE1Ni42NCAxOS4wNSAxNTUuODAgMTkuNDJRMTU0Ljk2IDE5LjgwIDE1My44MiAxOS44MEwxNTMuODIgMTkuODBMMTUyLjM2IDE5LjgwTDE1Mi4zNiAyMlpNMTUyLjM2IDE1LjQ3TDE1Mi4zNiAxNy45M0wxNTMuNjggMTcuOTNRMTU0LjQxIDE3LjkzIDE1NC43OCAxNy42MVExNTUuMTUgMTcuMjkgMTU1LjE1IDE2LjcxTDE1NS4xNSAxNi43MVExNTUuMTUgMTYuMTIgMTU0Ljc4IDE1LjgwUTE1NC40MSAxNS40NyAxNTMuNjggMTUuNDdMMTUzLjY4IDE1LjQ3TDE1Mi4zNiAxNS40N1pNMTYxLjcyIDIxLjI0TDE2MS43MiAyMS4yNEwxNjIuNTAgMTkuNDlRMTYzLjA2IDE5Ljg2IDE2My44MSAyMC4wOVExNjQuNTUgMjAuMzIgMTY1LjI3IDIwLjMyTDE2NS4yNyAyMC4zMlExNjYuNjQgMjAuMzIgMTY2LjY0IDE5LjY0TDE2Ni42NCAxOS42NFExNjYuNjQgMTkuMjggMTY2LjI1IDE5LjExUTE2NS44NyAxOC45MyAxNjUuMDAgMTguNzRMMTY1LjAwIDE4Ljc0UTE2NC4wNSAxOC41MyAxNjMuNDEgMTguMzBRMTYyLjc4IDE4LjA2IDE2Mi4zMiAxNy41NVExNjEuODcgMTcuMDMgMTYxLjg3IDE2LjE2TDE2MS44NyAxNi4xNlExNjEuODcgMTUuMzkgMTYyLjI5IDE0Ljc3UTE2Mi43MSAxNC4xNSAxNjMuNTQgMTMuNzlRMTY0LjM4IDEzLjQzIDE2NS41OCAxMy40M0wxNjUuNTggMTMuNDNRMTY2LjQxIDEzLjQzIDE2Ny4yMiAxMy42MlExNjguMDIgMTMuODAgMTY4LjY0IDE0LjE3TDE2OC42NCAxNC4xN0wxNjcuOTAgMTUuOTNRMTY2LjcwIDE1LjI4IDE2NS41NyAxNS4yOEwxNjUuNTcgMTUuMjhRMTY0Ljg2IDE1LjI4IDE2NC41NCAxNS40OVExNjQuMjIgMTUuNzAgMTY0LjIyIDE2LjA0TDE2NC4yMiAxNi4wNFExNjQuMjIgMTYuMzcgMTY0LjYwIDE2LjU0UTE2NC45OSAxNi43MSAxNjUuODQgMTYuODlMMTY1Ljg0IDE2Ljg5UTE2Ni44MCAxNy4xMCAxNjcuNDMgMTcuMzNRMTY4LjA2IDE3LjU2IDE2OC41MiAxOC4wN1ExNjguOTggMTguNTggMTY4Ljk4IDE5LjQ2TDE2OC45OCAxOS40NlExNjguOTggMjAuMjEgMTY4LjU2IDIwLjgzUTE2OC4xNCAyMS40NCAxNjcuMzAgMjEuODBRMTY2LjQ2IDIyLjE3IDE2NS4yNiAyMi4xN0wxNjUuMjYgMjIuMTdRMTY0LjI0IDIyLjE3IDE2My4yOCAyMS45MlExNjIuMzIgMjEuNjcgMTYxLjcyIDIxLjI0WiIgZmlsbD0iI0ZGRkZGRiIgeD0iMTI2LjMxIi8+PC9zdmc+)](https://www.cse.unsw.edu.au/~cs1521/18s2/notes/C/notes.html)

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See below for prerequisite libraries and notes on how to deploy the project on a live system.

`git clone https://github.com/mahirahman/snake`

To get a feel for this game, try it out in QtSpim:

1. Open [QtSpim](http://spimsimulator.sourceforge.net)
2. Click 'File' on the top left
3. Click 'Reinitialize and Load File' from the drop-down menu
4. Find snake.s on your computer and open it
5. Click the green play button
6. Enter command w|a|s|d into the console that pops up

```
.@.............
...............
...............
...............
...............
...............
...............
....ooo#.......
...............
...............
...............
...............
...............
...............
...............
```

## Notes

The starting state of a game to the right, where you can see all the key parts of the game. Snake is played on a 15×15 grid. The snake is made up of a head (#), and a number of body segments (o), and can move around the grid.

When the user enters one of w, a, s, or d, the snake will move one step on the grid either north, west, south, or east, respectively. The snake won't move if the requested direction is where the first non-head segment is.

Also on the grid: apples! Snakes like apples *[citation needed]* so, if the snake's head moves over an apple (denoted @), the snake consumes it, and gains three segments over the next three moves. If there's no apple on the grid, a new one is added in a random empty cell.

The game ends only when either the snake falls off one of the edges of the board, or the snake runs into its own body — as the snake's length increases, not falling off the board or running into itself become increasingly tricky!

## Built With

* [MIPS Assembly Language (MAL)](https://www.cse.unsw.edu.au/~cs1521/18s2/notes/C/notes.html) - Assembly Language
* [QtSpim](http://spimsimulator.sourceforge.net) - MIPS Simulator

## License

* [General Public License v2.0](https://github.com/mahirahman/snake/blob/master/LICENSE)

## Authors

* **Mahi Rahman**