CREATE OR REPLACE FUNCTION public.modulo11_CalcularDV(p_Chave TEXT) RETURNS integer AS $$

  /* --------------------------------------------------------------------------------
   * Exemplo de como a regra do módulo 11 funciona
   * --------------------------------------------------------------------------------
   *
   *  +---+---+---+---+---+---+
   *  | 2 | 6 | 1 | 5 | 3 | 3 |
   *  +---+---+---+---+---+---+
   *    |   |   |   |   |   |
   *   x7  x6  x5  x4  x3  x2
   *    |   |   |   |   |   |
   *   =14 =36 =05 =20 =09 =06 soma = 90                                          +---+
   *    +---+---+---+---+---+-> = (90 / 11) = 8,1818 , resto 2 => DV = (11 - 2) = | 9 |
   *                                                                              +---+
   *
   * --------------------------------------------------------------------------------
   */
DECLARE
  total INTEGER;
  peso INTEGER;
  tamanho INTEGER;
  indice INTEGER;
  resto INTEGER;

BEGIN
  p_Chave := REPLACE(p_Chave, ' ','');
  tamanho := length(p_Chave);
  indice   := 0;
  total   := 0;
  peso   := 2;

  -----------------------------------------------------------------
  -- O RAISE seria o equivalente ao 'System.out.println' no Java --
  -----------------------------------------------------------------
  RAISE NOTICE '%', p_Chave;
  
  WHILE (indice < tamanho)
  LOOP
    total  := total  + (substr(p_Chave, tamanho - indice, 1)::integer * peso);
    peso   := peso   + 1;
    indice := indice + 1;
    
    IF (peso = 10) THEN peso := 2; END IF;
  END LOOP;

  resto = total % 11;

  IF (resto = 0) OR (resto = 1) 
  THEN
    RETURN 0;
  ELSE  
    RETURN (11 - resto);
  END IF;
END;
$$ LANGUAGE plpgsql;