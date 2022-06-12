DB_URL=postgresql://postgres:postgres@localhost:5432/simple_bank?sslmode=disable
postgres: 
	docker run --name image-postgres -p 5432:5432 -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -d postgres:14.3-alpine

createdb: 
	docker exec -it image-postgres createdb --username=postgres --owner=postgres simple_bank

dropdb:
	docker exec -it image-postgres dropdb --username=postgres simple_bank

migrateup: 
	migrate -path db/migration -database "${DB_URL}" -verbose up

migratedown: 
	migrate -path db/migration -database "${DB_URL}" -verbose down

connectpsql: 
	 psql -h localhost -p 5432 -U postgres

sqlc: 
	sqlc generate
test: 
	go test -v -cover ./...

.PHONY: postgres createdb dropdb migrateup migratedown connectpsql sqlc