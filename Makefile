.DEFAULT_GOAL: migrate
.PHONY: migrate clean repair
migrate:
	@echo "Migrating main db..."
	flyway migrate -configFiles="./flyway.conf" -workingDirectory=".\ev34Flyway" -url="jdbc:sqlserver://localhost:1433;databaseName=ev34;encrypt=false;integratedSecurity=true;trustServerCertificate=true" -community

clean:
	@echo "Cleaning main db..."
	flyway clean -configFiles="./flyway.conf" -workingDirectory=".\ev34Flyway" -url="jdbc:sqlserver://localhost:1433;databaseName=ev34;encrypt=false;integratedSecurity=true;trustServerCertificate=true" -community

repair:
	@echo "Repairing main db..."
	flyway repair -configFiles="./flyway.conf" -workingDirectory=".\ev34Flyway" -url="jdbc:sqlserver://localhost:1433;databaseName=ev34;encrypt=false;integratedSecurity=true;trustServerCertificate=true" -community

info:
	@echo "Info main db..."
	flyway info -configFiles="./flyway.conf" -workingDirectory=".\ev34Flyway" -url="jdbc:sqlserver://localhost:1433;databaseName=ev34;encrypt=false;integratedSecurity=true;trustServerCertificate=true" -community
