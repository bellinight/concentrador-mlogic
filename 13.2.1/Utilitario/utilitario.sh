export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:.
java -cp ".:lib/*" -Djava.library.path="." br.com.pi.utilitario.Main