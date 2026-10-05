.up:
	docker compose up --build -d

.down:
	docker compose down

.logs:
	docker compose logs -f

.seed:
	docker compose exec backend npx prisma db seed

.reset:
	docker compose down -v
	docker compose up --build -d

.test:
	docker compose exec backend npm test

up: .up
down: .down
logs: .logs
seed: .seed
reset: .reset
test: .test
