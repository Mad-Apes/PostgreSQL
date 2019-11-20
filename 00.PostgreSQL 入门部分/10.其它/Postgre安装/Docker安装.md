# docker run -tid --name pg12 -e POSTGRES_PASSWORD=postgres -p 5432:5432 -v /var/lib/postgresql/data:/var/lib/postgresql/data -d postgres:12


docker run --name pg11.5 -e POSTGRES_PASSWORD=postgres -p 5433:5432 -v /var/lib/postgresql11/data:/var/lib/postgresql/data -d postgres:latest
