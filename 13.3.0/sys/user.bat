@echo off

psql -h localhost -p 5432 -U postgres

psql ALTER USER postgres WITH PASSWORD 'local';