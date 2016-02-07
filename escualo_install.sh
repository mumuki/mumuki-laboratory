#/bin/bash

echo "[Escualo::Atheneum] Running Migrations..."
rake db:migrate
echo "[Escualo::Atheneum] Compiling assets..." 
rake assets:precompile
