
Basta rodar 

```
sudo curl https://raw.githubusercontent.com/pedrost/fast-mysql-setup/master/setup.sh | sudo bash
```


Quando pedir para selecionar o tipo de server selecione pressionando *espaço* o *apache2* e depois pressione *enter*
![alt text](https://i.imgur.com/H3s8DRK.png "Config phpmyadmin")
E quando pedir para configurar a dbconfig-common, selecione *no* e pressione *enter*
![alt text](https://i.imgur.com/eoeULJC.png "Config phpmyadmin")


Se voce estiver rodando isso em uma maquina EC2 da amazon
Vai precisar abrir a porta HTTP nos security-groups
E tambem nao precisa usar o NGROK, pode usar o endereco IP da maquina que sera acessivel de qualquer lugar
