.PHONY: all redeploy

all:

.env: .env.gen
	./.env.gen > $@

redeploy: .env
	docker compose down -v
	docker compose up -d --build

hadoop1:
	docker compose exec -u hdfs hadoop1 bash