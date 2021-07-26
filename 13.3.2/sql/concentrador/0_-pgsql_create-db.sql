DO $$ BEGIN RAISE NOTICE 'Criando base de dados {ScriptPack.TargetDb}...'; END $$;
CREATE DATABASE "{ScriptPack.TargetDb}";
