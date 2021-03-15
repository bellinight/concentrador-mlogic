#!/bin/bash
cd $1

SENHA_DEFAULT=pr0c3ss4
CERT_DEFAULT=CertificadoDigital.jks
rm -f $CERT_DEFAULT

echo ""
echo "É necessário que o certificado *.pfx do cliente já esteja nesta pasta."
read -p "O certificado do cliente já está na pasta? [y/n] " r
if [ "$r" = "y" ] || [ "$r" = "Y" ] || [ "$r" = "s" ] || [ "$r" = "S" ]
then
  #Buscando o certificado que será instalado
  CURRENT=`pwd`
  echo "$CURRENT"  
  
  CERT_ORIG=$(find -type f -name "*.pfx" -printf "%f")
  echo ""
  echo "-------------------------------------------------"
  echo "Importanto o certificado $CERT_ORIG"
  echo "-------------------------------------------------"
  stty -echo
  read -p "Informe a senha do certificado: " CERT_ORIG_SENHA
  stty echo
  echo ""
  echo ""
  echo "-------------------------------------------------"
  echo "Gerando o $CERT_DEFAULT"
  echo "-------------------------------------------------"
  keytool -importkeystore -srckeystore "$CERT_ORIG" -srcstorepass "$CERT_ORIG_SENHA" -srcstoretype pkcs12 -destkeystore "$CERT_DEFAULT" -storepass "$SENHA_DEFAULT" -deststoretype JKS 

  #Obtendo o alias do certificado para poder alterar a senha da chave
  echo ""
  ALIAS=$(keytool -list -keystore "$CERT_ORIG" -storetype pkcs12 -storepass "$CERT_ORIG_SENHA")
  ALIAS=$(echo ${ALIAS#*entry})
  ALIAS=$(echo ${ALIAS%%,*})
  keytool -keypasswd -alias "$ALIAS" -keypass "$CERT_ORIG_SENHA" -new "$SENHA_DEFAULT" -keystore "$CERT_DEFAULT" -storepass "$SENHA_DEFAULT" -storetype JKS
  echo ""
  echo "Certificado $CERT_DEFAULT gerado com sucesso!"
else
  echo ""
  echo "Coloque o certificado *.pfx do cliente na pasta e rode o script novamente."
fi

echo ""
read -p "Pressione qualquer tecla para fechar o terminal... " r
