import { LightningElement } from 'lwc';

const CELL_SIZE = 20;
const COLS = 20;
const ROWS = 20;
const INITIAL_SPEED = 150; // ms per tick

export default class SnakeGame extends LightningElement {
    score = 0;
    isRunning = false;
    gameOver = false;

    get buttonLabel() {
        return this.isRunning ? 'Restart' : 'Start';
    }

    _canvas;
    _ctx;
    _snake;
    _direction;
    _pendingDirection;
    _food;
    _timerId;

    connectedCallback() {
        this._handleKeyDown = this.handleKeyDown.bind(this);
        window.addEventListener('keydown', this._handleKeyDown);
    }

    disconnectedCallback() {
        window.removeEventListener('keydown', this._handleKeyDown);
        this.stopLoop();
    }

    renderedCallback() {
        if (!this._canvas) {
            this._canvas = this.template.querySelector('canvas');
            if (this._canvas) {
                this._canvas.width = COLS * CELL_SIZE;
                this._canvas.height = ROWS * CELL_SIZE;
                this._ctx = this._canvas.getContext('2d');
                this.resetGame();
                this.draw();
            }
        }
    }

    handleStartClick() {
        this.resetGame();
        this.startLoop();
    }

    resetGame() {
        this.score = 0;
        this.gameOver = false;
        this.isRunning = false;

        const startX = Math.floor(COLS / 2);
        const startY = Math.floor(ROWS / 2);
        this._snake = [
            { x: startX, y: startY },
            { x: startX - 1, y: startY },
            { x: startX - 2, y: startY }
        ];
        this._direction = { x: 1, y: 0 }; // moving right
        this._pendingDirection = this._direction;
        this.spawnFood();
        this.draw();
    }

    startLoop() {
        this.stopLoop();
        this.isRunning = true;
        this._timerId = window.setInterval(() => {
            this.tick();
        }, INITIAL_SPEED);
    }

    stopLoop() {
        if (this._timerId) {
            window.clearInterval(this._timerId);
            this._timerId = null;
        }
        this.isRunning = false;
    }

    handleKeyDown(event) {
        if (this.gameOver) {
            return;
        }

        let newDir;
        switch (event.key) {
            case 'ArrowUp':
                newDir = { x: 0, y: -1 };
                break;
            case 'ArrowDown':
                newDir = { x: 0, y: 1 };
                break;
            case 'ArrowLeft':
                newDir = { x: -1, y: 0 };
                break;
            case 'ArrowRight':
                newDir = { x: 1, y: 0 };
                break;
            default:
                return;
        }

        // Prevent reversing directly into itself
        if (
            (newDir.x === -this._direction.x && newDir.y === 0) ||
            (newDir.y === -this._direction.y && newDir.x === 0)
        ) {
            return;
        }

        this._pendingDirection = newDir;
    }

    tick() {
        if (!this.isRunning || this.gameOver) {
            return;
        }

        this._direction = this._pendingDirection;

        const head = this._snake[0];
        const newHead = {
            x: head.x + this._direction.x,
            y: head.y + this._direction.y
        };

        // Check wall collision
        if (
            newHead.x < 0 ||
            newHead.x >= COLS ||
            newHead.y < 0 ||
            newHead.y >= ROWS
        ) {
            this.endGame();
            return;
        }

        // Check self collision
        if (this._snake.some(segment => segment.x === newHead.x && segment.y === newHead.y)) {
            this.endGame();
            return;
        }

        this._snake = [newHead, ...this._snake];

        // Check food
        if (newHead.x === this._food.x && newHead.y === this._food.y) {
            this.score += 10;
            this.spawnFood();
        } else {
            // Remove tail
            this._snake.pop();
        }

        this.draw();
    }

    endGame() {
        this.gameOver = true;
        this.stopLoop();
    }

    spawnFood() {
        // Keep trying random positions until we find an empty one
        let x;
        let y;
        do {
            x = Math.floor(Math.random() * COLS);
            y = Math.floor(Math.random() * ROWS);
        } while (this._snake && this._snake.some(segment => segment.x === x && segment.y === y));

        this._food = { x, y };
    }

    clearBoard() {
        if (this._ctx) {
            this._ctx.fillStyle = '#111827'; // slate-900-ish
            this._ctx.fillRect(0, 0, COLS * CELL_SIZE, ROWS * CELL_SIZE);
        }
    }

    draw() {
        if (!this._ctx) {
            return;
        }

        this.clearBoard();

        // Draw grid (optional subtle grid)
        this._ctx.strokeStyle = '#1f2933';
        this._ctx.lineWidth = 1;
        for (let x = 0; x <= COLS; x++) {
            this._ctx.beginPath();
            this._ctx.moveTo(x * CELL_SIZE + 0.5, 0);
            this._ctx.lineTo(x * CELL_SIZE + 0.5, ROWS * CELL_SIZE);
            this._ctx.stroke();
        }
        for (let y = 0; y <= ROWS; y++) {
            this._ctx.beginPath();
            this._ctx.moveTo(0, y * CELL_SIZE + 0.5);
            this._ctx.lineTo(COLS * CELL_SIZE, y * CELL_SIZE + 0.5);
            this._ctx.stroke();
        }

        // Draw snake
        this._ctx.fillStyle = '#22c55e'; // green-500
        this._snake.forEach((segment, index) => {
            const isHead = index === 0;
            this._ctx.fillStyle = isHead ? '#4ade80' : '#22c55e';
            this._ctx.fillRect(
                segment.x * CELL_SIZE + 1,
                segment.y * CELL_SIZE + 1,
                CELL_SIZE - 2,
                CELL_SIZE - 2
            );
        });

        // Draw food
        if (this._food) {
            this._ctx.fillStyle = '#ef4444'; // red-500
            this._ctx.beginPath();
            this._ctx.arc(
                this._food.x * CELL_SIZE + CELL_SIZE / 2,
                this._food.y * CELL_SIZE + CELL_SIZE / 2,
                CELL_SIZE / 2 - 2,
                0,
                Math.PI * 2
            );
            this._ctx.fill();
        }
    }
}