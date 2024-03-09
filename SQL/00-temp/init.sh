#!/bin/bash
sudo -i -u postgres psql
dropdb cars_database
echo "BDD supprimée"
createdb cars_database -O iousco
echo "BDD créée"

# Nom des fichiers SQL
CREATE_DB_SQL="createdb.sql"
SEED_DB_SQL="seeddb.sql"

# Commande pour exécuter les fichiers SQL
psql -U iousco -d cars_database -a -f $CREATE_DB_SQL
psql -U iousco -d cars_database -a -f $SEED_DB_SQL
