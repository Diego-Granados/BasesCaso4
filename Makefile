.DEFAULT_GOAL: migrate
.PHONY: migrate clean repair info migrateFix cleanFix repairFix infoFix
migrate:
	@echo "Migrating main db..."
	flyway migrate -configFiles="./flyway.conf" -workingDirectory=".\ev41FlywayProb" -url="jdbc:sqlserver://localhost:1433;databaseName=ev34;encrypt=false;integratedSecurity=true;trustServerCertificate=true" -community

clean:
	@echo "Cleaning main db..."
	flyway clean -configFiles="./flyway.conf" -workingDirectory=".\ev41FlywayProb" -url="jdbc:sqlserver://localhost:1433;databaseName=ev34;encrypt=false;integratedSecurity=true;trustServerCertificate=true" -community

repair:
	@echo "Repairing main db..."
	flyway repair -configFiles="./flyway.conf" -workingDirectory=".\ev41FlywayProb" -url="jdbc:sqlserver://localhost:1433;databaseName=ev34;encrypt=false;integratedSecurity=true;trustServerCertificate=true" -community

info:
	@echo "Info main db..."
	flyway info -configFiles="./flyway.conf" -workingDirectory=".\ev41FlywayProb" -url="jdbc:sqlserver://localhost:1433;databaseName=ev34;encrypt=false;integratedSecurity=true;trustServerCertificate=true" -community

migrateFix:
	@echo "Migrating ev41 db..."
	flyway migrate -configFiles="./flyway.conf" -workingDirectory=".\ev41Flyway" -url="jdbc:sqlserver://localhost:1433;databaseName=ev41;encrypt=false;integratedSecurity=true;trustServerCertificate=true" -community

cleanFix:
	@echo "Cleaning ev41 db..."
	flyway clean -configFiles="./flyway.conf" -workingDirectory=".\ev41Flyway" -url="jdbc:sqlserver://localhost:1433;databaseName=ev41;encrypt=false;integratedSecurity=true;trustServerCertificate=true" -community

repairFix:
	@echo "Repairing ev41 db..."
	flyway repair -configFiles="./flyway.conf" -workingDirectory=".\ev41Flyway" -url="jdbc:sqlserver://localhost:1433;databaseName=ev41;encrypt=false;integratedSecurity=true;trustServerCertificate=true" -community

infoFix:
	@echo "Info ev41 db..."
	flyway info -configFiles="./flyway.conf" -workingDirectory=".\ev41Flyway" -url="jdbc:sqlserver://localhost:1433;databaseName=ev41;encrypt=false;integratedSecurity=true;trustServerCertificate=true" -community