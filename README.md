<div align='center'>

# 💻Interface para um sensor de Temperatura e Umidade SBC ARM🌡️
</div>

## Índice:
1.  [Sobre](#sobre)
2.  [Visão Geral](#visaoGeral)
      - 2.1. [Linguagem Assembly](#linguagemAssembly)
      - 2.2. [Registradores](#registradores)
      - 2.3. [CCU](#ccu) 
3.  [Interface do Usuário](#interfaceDoUsuario)
4.  [Mapeamento de Memória e GPIO](#mapeamentoDeMemoriaEGPIO)
      - 4.1. [GPIO](#GPIO)
      - 4.2. [Manipulação de um pino](#manipulacaoDeUmPino)
      - 4.3. [Funções e Macros](#GPIOFuncoesEMacros)
5.  [UART](#UART)
    - 5.1. [Configuração do Clock](#configuracaoDoClock)
    - 5.2. [Configuração da UART](#configuraçãoDaUART)
    - 5.2. [Transmissão e recepção de dados](#transmissaoERecepcao)
    - 5.3. [UART - Funções e Macros](#UARTFuncoesEMacros)
6.  [LCD](#LCD)
       - 6.1. [Inicialização](#inicializacao)
       - 6.2. [Instruções](#instrucoes)
       - 6.3. [Escrita de Caractere](#escritaDeCaractere)
       - 6.4. [LCD - Funções e Macros](#LCDFuncoesEMacros)
7.  [Testes](#testes)
8.  [Modulos do Projeto](#modulosDoProjeto)
9.  [MakeFile](#makeFile)
10.  [Conclusão](#conclusao)
11.  [Como Executar](#comoExecutar)
12.  [Referências](#referencias)

## Equipe

Gabriel Baptista: [@BaptistaGabriel](https://github.com/BaptistaGabriel)

Kauan Farias: [@kakafariaZ](https://github.com/kakafariaZ)

Márcio Roberto: [@MarcioDzn](https://github.com/MarcioDzn)

## 1. Sobre <a id="sobre"></a>

### 1.1 Objetivo

Desenvolver de uma interface para um sensor de temperatura e umidade, projetada para ser utilizada em Single Board Computers (SBC) baseados na arquitetura ARM. Esta interface visa possibilitar a leitura e controle eficientes dos dados de temperatura e umidade, oferecendo uma solução integrada para a obtenção dessas informações em placas ARM específicas.</br>
Alguns requisitos devem ser cumpridos durante o desenvolvimento, como:
- O código deve ser escrito em Assembly;
- O sistema só poderá utilizar os componentes disponíveis no protótipo.


### 1.2 Materiais utilizados

- Orange Pi PC PLUS
- LCD HD44780U
- ESP32


## 2. Visão Geral <a id="visaoGeral"></a>
  
O funcionamento do protótipo se dá a partir da configuração inicial e habilitação de certos componentes. 
- O primeiro passo é o mapeamento de memória da OrangePI PC Plus, o qual permite a manipulação dos pinos do GPIO. A partir do mapeamento é possível trabalhar com botões, LCD e UART. 
- Em seguida, inicializa-se o display, cuja função é permitir a exibição de dados para o usuário. A inicialização se dá através de uma sequência de passos (instruções) pré-definidos. Também são necessárias configurações adicionais no display para garantir o funcionamento adequado.
- Por fim, mapeia-se e configura-se a UART, utilizada para comunicação serial com a ESP, a fim de receber dados do sensor DHT11.

<div align='center'>

![image](https://github.com/BaptistaGabriel/Interface_SBC_ARM_Sensor_Temperatura_e_Umidade/assets/91295529/dfdba369-a7df-4c4d-95b0-9b91c837b5ab)


</div>

### 2.1. Linguagem Assembly <a id="linguagemAssembly"></a>

Para desenvolver o projeto utilizou-se o Assembly, uma linguagem de baixo nível que visa abstrair a linguagem de máquina, de difícil compreensão. Nesse sentido, a partir de mnemônicos do Assembly, o desenvolvedor pode ter um melhor entendimento do código.

Utilizando a linguagem Assembly é possível controlar o hardware do sistema, por meio da manipulação de dados e operações aritméticas, por exemplo.

### 2.2. Registradores <a id="registradores"></a>

Cada módulo contém diversos registradores utilizados para fins variados, como configuração e transmissão de dados. Muitos pinos são manipulados através dos registradores, podendo ter seu estado ou modo de operação alterados. Tais registradores, em geral, contém 32 bits de dados armazenados.

Os registradores são encontrados a partir da soma de um offset específico com um determinado endereço base, conforme especificado no datasheet Allwinner H3. Ademais, certos bits de um determinado registro se referem a tipos de configuração diferentes, sendo necessários offsets específicos para encontrar a posição desejada.

Com base nisso, a manipulação, de maneira geral, dos módulos utilizados no projeto, com exceção do LCD, se dá a partir da modificação de determinados bits em registradores específicos. Tal modificação ocorre através de máscaras de bits, as quais permitem a alteração de parte dos dados sem comprometer os demais.

### 2.3 CCU <a id="ccu"></a>

A Unidade de Controle de Relógio (CCU) permite a manipulação da geração, divisão, distribuição e sincronização de sinais de relógio. Dessa forma, a partir desses sinais, é possível garantir o correto funcionamento de diversos componentes do sistema.

A partir da manipulação dos registradores da CCU, tornou-se possível obter o correto funcionamento da UART como meio de comunicação de dados.


## 3. Interface do usuário <a id="interfaceDoUsuario"></a>

Um importante requisito do projeto é uma interface amigável, que permite ao usuário receber informações da temperatura, da umidade e do status do sensor, além de escolhê-lo.

Para tanto, foram utilizadas quatro “camadas” de telas, tanto para solicitação quanto para recebimento de dados. A primeira camada, a camada zero, se refere à escolha do sensor, cujo número varia entre 0 e 32. Caso um sensor inválido seja escolhido, um erro aparece, já para um sensor correto, o sistema passa para as telas da camada A, de escolha de solicitação.

<div align='center'>

![image](https://github.com/BaptistaGabriel/Interface_SBC_ARM_Sensor_Temperatura_e_Umidade/assets/91295529/fa3ac92a-3622-43dd-bbe6-0819a93b5967)
</div>

O objetivo das telas da segunda camada, ou camada A, é permitir que o usuário solicite um dado em específico, seja o sensoriamento atual, contínuo ou o estado do sensor.

<div align='center'>

![image](https://github.com/BaptistaGabriel/Interface_SBC_ARM_Sensor_Temperatura_e_Umidade/assets/91295529/8e3151aa-fc36-43fa-b2e7-10e25211a4f1)
</div>

Após a solicitação, são exibidas as telas da camada B, onde se encontram os dados solicitados, como a umidade, temperatura e status do sensor.

<div align='center'>

![image](https://github.com/BaptistaGabriel/Interface_SBC_ARM_Sensor_Temperatura_e_Umidade/assets/91295529/f3a41e29-4f34-42d6-93d4-e6798a25997d)
</div>

Por fim, existem as camadas intermediárias, responsáveis por indicar se alguma ação está sendo executada, como o fim do sensoriamento contínuo, ou se houve algum erro.

<div align='center'>

![image](https://github.com/BaptistaGabriel/Interface_SBC_ARM_Sensor_Temperatura_e_Umidade/assets/91295529/7c1a8e6d-7802-433b-8c10-e56040496a94)
</div>

A fim de controlar a mudança de telas no LCD utilizou-se botões específicos, tanto alterar as páginas de uma mesma camada quanto para selecionar uma opção e passar para uma outra. De maneira intuitiva, os botões da direita e da esquerda alteram entre opções e o do meio modifica a camada.

Logo abaixo é possível observar alguns vídeos que demonstram o funcionamento real do protótipo.
- Escolha de sensor
<div align='center'>

<img src="media\gif_escolha_sensor.gif" width="600">

</div>

- Verificação de status (sensor com problema)
<div align='center'>

<img src="media\gif_status_prob.gif" width="600">

</div>

- Escolha de temperatura contínua
<div align='center'>

<img src="media\gif_temp_continua.gif" width="600">

</div>


## 4. Mapeamento de Memória e GPIO <a id="mapeamentoDeMemoriaEGPIO"></a>
Para manipular os componentes da OrangePI PC Plus necessários ao projeto, como o GPIO e a UART, é necessário realizar o mapeamento de memória dos seus respectivos módulos. Cada módulo tem um endereço base, sendo dividido em páginas de tamanho determinado. Tanto para o GPIO, quanto para a UART e o CCU, cada página tem o tamanho de 1k.</br>
Os endereços base utilizados foram:

- UART: 0x1C20000
- GPIO: 0x1C20800
- CCU: 0x1C2800</br>
  
O primeiro passo para realizar o mapeamento é ter acesso a um arquivo que dá acesso à memória física da OrangePi PC Plus, o `/dev/mem`. Para abrir esse arquivo é preciso utilizar a chamada de sistema `open`, que retorna um descritor de arquivo, o qual poderá ser usado para acessá-lo.</br>

Utilizando arquivo supracitado e outros argumentos, como o endereço base e tamanho da página, é possível realizar o mapeamento em si, por meio da chamada de sistema `mmap2`. O seu retorno é o endereço virtual mapeado, o endereço base, que poderá ser utilizado como base para encontrar determinados registradores.</br>

Nesse sentido, a partir do mapeamento de memória é possível ter acesso a determinadas portas, que permitem a manipulação e configuração de pinos e funcionalidades.


### 4.1 GPIO <a id="GPIO"></a>
Para manipular certos pinos, como os referentes aos botões e as entradas de dados do display LCD, tornou-se necessário trabalhar com o módulo GPIO (General Purpose Input/Output). Dessa forma, após realizar o mapeamento deste módulo, obteve-se acesso às suas portas.</br>

As portas utilizadas durante a manipulação do GPIO são a A e a G, segundo o datasheet da OrangePI PC Plus. Cada tipo de porta contém alguns registradores de configuração, para ajuste dos pinos, e um registrador de dados, referente ao estado atual de um pino.</br>

Cada registrador está em algum local da memória, e para encontrá-lo é necessário utilizar um offset específico associado a ele. A partir da soma desse offset com o endereço base encontra-se o registro buscado. Dentro de cada registrador há diversos conjuntos de bits, sendo que, cada um deles, no caso da GPIO, está associado a um determinado pino específico.

### 4.2 Manipulação de um pino <a id="manipulacaoDeUmPino"></a>
Nesse sentido, para manipular um determinado pino, é necessário buscar seu registrador correspondente, e em seguida, dentro desse registro, modificar seu respectivo conjunto de bits. Para registradores de configuração a quantidade de bits referente a cada pino é 3, já para os de dados é apenas 1.

<div align='center'>

![image](https://github.com/BaptistaGabriel/Interface_SBC_ARM_Sensor_Temperatura_e_Umidade/assets/91295529/51d9c0cb-29eb-4f21-bc98-d5f6f0f497d6)
</div>

As modificações utilizadas no projeto se referem a alterar o modo de um pino para entrada, saída ou UART, por meio de um registrador de configuração. Além disso, é possível capturar o estado de um pino ou alterá-lo para alto ou baixo, por meio do registrador de dados. 

### 4.3 Funções e Macros <a id="GPIOFuncoesEMacros"></a>

O módulo GPIO, no protótipo, foi utilizado principalmente para o envio de dados para o LCD, configuração da UART e verificação do estado de certos botões. Algumas macros utilizadas na implementação foram:

- `mapMemory` - Mapeia o endereço do GPIO
- `setPinHigh` - responsável por atribuir nível alto a um pino
- `setPinLow`  - responsável por atribuir nível baixo a um pino
- `setPinIn` - responsável por definir um pino como de entrada
- `setPinOut` -  responsável por definir um pino como de saída
- `getPinState` - responsável por capturar o estado de um pino


## 5. UART <a id="UART"></a>

A UART é o protocolo utilizado para transmissão e recepção de dados entre a ESP32 e a OrangePi PC Plus. Para utilizar corretamente a UART disponível na OrangePi, faz-se necessário, inicialmente, configurá-la. A configuração se dá através da manipulação de registradores específicos dos módulos GPIO, CCU e UART.

### 5.1 Configuração do Clock <a id="configuracaoDoClock"></a>

O primeiro passo para a configuração da UART é o direcionamento do clock para a mesma. Para tanto, é necessário manipular alguns registradores disponíveis no módulo da CCU, a fim de habilitar o clock correto, e transmiti-lo para a UART. Além disso, também há a necessidade de resetá-la durante essa etapa.

<div align='center'>

![image](https://github.com/BaptistaGabriel/Interface_SBC_ARM_Sensor_Temperatura_e_Umidade/assets/91295529/298905aa-3397-4936-92d4-c85779a6410d)
</div>

### 5.2 Configuração da UART <a id="configuraçãoDaUART"></a>

Ademais, faz-se necessário configurar os pinos de transmissão e recepção de dados para o modo UART_TX e UART_RX, sendo eles o PA13 e o PA14, respectivamente.

Outrossim, é importante definir quantos bits serão enviados e recebidos, configurar o baud rate e habilitar os FIFOs necessários.

<div align='center'>

![image](https://github.com/BaptistaGabriel/Interface_SBC_ARM_Sensor_Temperatura_e_Umidade/assets/91295529/21b1044b-b85e-41b7-96f4-80a0afbff86f)
</div>

A configuração correta do baud rate se dá a partir da atribuição de um divisor nos registradores DLH e DLL, os quais devem ser previamente habilitados. Para encontrar o valor desse divisor é necessário utilizar a equação `baud rate = taxa de clock / (16 * divisor)`, na qual a taxa clock é 624MHz e o baud rate 9600 bit/s.

### 5.3 UART - Transmissão e recepção de dados <a id="transmissaoERecepcao"></a>

Para a transmissão de dados utilizou-se o registrador THR (Transmit Holding Register), o qual recebe um byte e o coloca em uma FIFO, para ser enviado de maneira serial. Já para receber as informações, necessitou-se manipular o registrador RBR (Receiver Buffer Register), que armazena 8 bits de dados que chegam da FIFO. Para garantir o recebimento correto dos dados fez-se necessário verificar se a FIFO contém algo antes de tentar carregar algum valor do RBR.

<div align='center'>

![image](https://github.com/BaptistaGabriel/Interface_SBC_ARM_Sensor_Temperatura_e_Umidade/assets/91295529/4e41577b-b090-4bc2-9bfa-8b65b14a045e)
</div>

### 5.4 UART - Funções e Macros <a id="UARTFuncoesEMacros"></a>

Alguns macros utilizados para a implementação dos conceitos supracitados foram:

- `mapMemoryCCU`: responsável por mapear o endereço da CCU, a fim de permitir o acesso a seus registros.
- `configClock`: responsável por configurar o clock e direcioná-lo para a UART3
- `mapMemoryUART`: responsável por mapear o endereço da UART, com a finalidade de permitir a manipulação de seus registradores.
- `setPinToUART`: responsável por configurar os pinos de transmissão e recepção.
- `configUART`: responsável por configurar a UART em si.
- `sendUART`: responsável pela transmissão de dados.
- `receiveUART`: responsável pela recepção de dados.



## 6. LCD <a id="LCD"></a>

Um requisito fundamental do projeto é a exibição de um menu amigável no LCD, o qual deve conter textos que se refiram tanto às opções disponíveis quanto aos dados obtidos do sensor. Para isso, utilizou-se o LCD HD44780U, que contém duas linhas e pode manifestar 16 caracteres em cada. 

Para manipular o display é necessário enviar determinados valores a ele, que podem ser instruções ou dados a serem exibidos. Nesse sentido, alguns pinos são requisitados para realizar essa transmissão da maneira correta, como: 
- `RS` - responsável por selecionar entre o registrador de instrução e o de dados; `RS = 0` para envio de instruções e `RS = 1` para envio de dados.
- `DB7 a DB4` - responsdáveis pela transferência de dados entre a MPU e o LCD.
- `E` - responsável por habilitar a leitura ou a escrita de dados.

Os dados enviados podem ser amazenados em dois tipos de registradores, o IR (Instruction Register) ou DR (Data Register). As insformações transferidas ao DR são automaticamente enviados ao DDRAM, o buffer de dados do LCD, cujos endereços se referem a uma posição do display.

Como a interface de dados é de 4 bits, apenas 4 pinos de transferência são usados, indo do DB7 ao DB4. Para a transferência de dados, os 4 bits de ordem mais alta (DB4 a DB7) são enviados antes dos 4 bits de ordem mais baixa, os quais seriam DB0 a DB3, para uma interface de 8 bits. Dessa forma, os pinos a serem utilizados para envio de informações são apenas D7 a D4, sendo D3, D2, D1 e D0 substituídos por D7, D6, D5 e D4, respectivamente.


### 6.1 Inicialização <a id="inicializacao"></a>

O primeiro passo para a utilização do display é inicializá-lo, a partir de um conjunto específico de instruções e de uma temporização correta. Estas podem ser encontrados no datasheet do display em questão.

<div align='center'>
  
![image](https://github.com/BaptistaGabriel/Interface_SBC_ARM_Sensor_Temperatura_e_Umidade/assets/91295529/2f6fb07c-f293-4d84-8bcd-0056b49af762)
</div>

### 6.2 Instruções <a id="instrucoes"></a>

Para realizar o envio de instruções, é necessário transmitir dados convenientes através dos pinos DB7 a DB4, seguido de pulsos de habilitação.

<div align='center'>
  
![image](https://github.com/BaptistaGabriel/Interface_SBC_ARM_Sensor_Temperatura_e_Umidade/assets/91295529/80b804ac-e249-450d-aa98-63784e3ef63b)
</div>

### 6.3 Escrita de Caractere <a id="escritaDeCaractere"></a>

Outra ação importante é a escrita de dados na tela, a qual segue um princípio semelhante ao envio de instruções, com a transferência de dados a partir dos pinos DB7 a DB4. Entretanto, além de atribuir nível alto ao pino RS, para modo de envio de dados, configurações adicionais do LCD são necessárias.

Os dados enviados devem corresponder a um ASCII (um byte) referente a um caractere específico.

<div align='center'>
  
![image](https://github.com/BaptistaGabriel/Interface_SBC_ARM_Sensor_Temperatura_e_Umidade/assets/91295529/d7133b4e-9e39-46e6-b4f7-eb09c7885e95)
</div>

### 6.4 LCD - Funções e Macros <a id="LCDFuncoesEMacros"></a>

O LCD tem fundamental importância em servir como uma interface amigável para o usuário, fornecendo opções de escolha de sensor e de tipo de sensoriamento. Ademais, exibe as informações solicitadas de maneira clara e concisa. Para a implementação do display no projeto, utilizou-se alguns macros, tanto para a inicialização quanto para o envio de instruções e dados, como:

- `initializeDisplay`: responsável pela inicialização do display
- `setPinsOut`: responsável por atribuir modo saída para os pinos do display
- `clearDisplay`: responsável por limpar o display e mover o cursor para a posição inicial
- `twoLine`: responsável por habilitar a segunda linha do display
- `secondLine`: responsável por mover o cursor para a segunda linha do display
- `writeChar`: responsável por escrever um caractere no display
- `writeCharNumber`: responsável por escrever um valor numérico no display
- `nanoSleep`: responsável por garantir a correta temporização entre instruções, quando necessário
- `writeLine`: responsável pela escrita de uma string no LCD


## 7. Testes <a id="testes"></a>

Durante o desenvolvimento foram realizados testes, a fim de verificar se os dados enviados eram coerentes com as respostas obtidas. 

Inicialmente testou-se a solicitação de umidade, a qual deve enviar dois bytes de requisição e receber a resposta necessária. O valor obtido foi de 4 bytes, entretanto, apenas os 2 primeiros são realmente a resposta, sendo os dois últimos considerados “lixo”.

<div align='center'>
  
![image](https://github.com/BaptistaGabriel/Interface_SBC_ARM_Sensor_Temperatura_e_Umidade/assets/91295529/84443d62-5d93-4fa7-9d36-9cc2638c75d3)
</div>

Outro valor solicitado foi a temperatura, que também retornou um valor coerente, apesar dos dois últimos bytes, descartáveis.

<div align='center'>
  
![image](https://github.com/BaptistaGabriel/Interface_SBC_ARM_Sensor_Temperatura_e_Umidade/assets/91295529/15e11a8b-f14e-4011-8c4b-466c83fdcf0b)
</div>

Em seguida verificou-se o status do sensor, solicitando-o conforme o protocolo. As respostas obtidas foram coerentes, tanto para o correto funcionamento do sensor quanto para algum erro.

<div align='center'>

![image](https://github.com/BaptistaGabriel/Interface_SBC_ARM_Sensor_Temperatura_e_Umidade/assets/91295529/55c94c5a-ecaa-4441-a1f1-bf7cb12728f1)
![image](https://github.com/BaptistaGabriel/Interface_SBC_ARM_Sensor_Temperatura_e_Umidade/assets/91295529/803a08f7-62fb-471d-917a-8741f4b07dc5)
</div>

Desta forma, diversos testes foram realizados observando sua requisição, bem como sua resposta através do osciloscópio. Na tabela a seguir, é possível observar todos os testes realizados.

<div align="center">
<br />

|            **Tela**           |                 **Entrada**                 |            **Saída esperada**           |
|:-----------------------------:|:-------------------------------------------:|:---------------------------------------:|
|  Página de Escolha do sensor  | Escolhe algum sensor não utilizado na placa |       Mensagem de sensor inválido       |
|  Página de Escolha do sensor  |        Escolhe algum sensor utilizado       |     Entrada no menu De solicitações     |
|   Solicita temperatura Atual  |    Retirar o sensor durante a verificação   | Exibição de mensagem de sensor inválido |
|   Solicita temperatura Atual  |          Solicita com sensor válido         |      Exibição da temperatura atual      |
| Solicita temperatura Contínua |          Solicita sem sensor válido         | Exibição de mensagem de sensor inválido |
| Solicita temperatura Contínua |          Solicita com sensor válido         |     Exibição da temperatura continua    |
|     Solicita umidade Atual    |          Solicita sem sensor válido         | Exibição de mensagem de sensor inválido |
|     Solicita umidade Atual    |          Solicita com sensor válido         |        Exibição da umidade atual        |
|   Solicita umidade Contínua   |          Solicita sem sensor válido         | Exibição de mensagem de sensor inválido |
|   Solicita status do sensor   |          Solicita sem sensor válido         | Exibição de mensagem de sensor inválido |
|   Solicita status do sensor   |          Solicita com sensor válido         |       Exibe mensagem de sensor ok       |
</div>

## 8. Modulos do Projeto <a id="modulosDoProjeto"></a>
Os módulos criados para realizar a implementação completa do protótipo são:

- `uart.s` - Contém funções referentes à manipulação e configuração da UART, bem como seu mapeamento e o do CCU.
- `lcd.s` - Contém macros necessários à manipulação do display LCD, como inicialização e instruções.
- `gpio.s` - Contém macros referentes ao mapeamento da GPIO e à manipulação dos pinos.
- `sleep.s` - Contém uma macro de temporização, utilizada em outros módulos para fins diversos.
- `split.s` - Contém funções que separam um valor numérico em dezena e unidade
- `main.s` - Integra todas as macros e funções a fim de permitir o funcionamento completo do sistema a partir de uma lógica principal. Nela se encontra a implementação da interface de usuário.

## 9. MakeFile <a id="makeFile"></a>


Para facilitar a compilação e a execução do programa criou-se um makefile, o qual:

- Converte o código assembly (.s) em um arquivo objeto (.o), com o assembler.
- “Linka” o arquivo objeto e gera o executável.
- Executa o programa.

## 10. Conclusão <a id="conclusao"></a>

Ao fim do desenvolvimento todos os requisitos foram cumpridos, e o sistema funcionou como esperado. Tal fato se dá devido a correta aplicação dos conceitos aprendidos durante o período de desenvolvimento.

Nesse sentido, a integração dos elementos necessários forma um sistema funcional que exibe corretamente as informações solicitadas. Tais elementos são: a UART, para comunicação de dados, o GPIO para manipulação dos pinos de entrada e saída e o display LCD para exibição de dados para o usuário.
 
Por fim, o projeto desenvolvido ajudou a compreender conceitos importantes relacionados à linguagem Assembly e a recursos de hardware que podem ser manipulados a partir da mesma, tal qual a OrangePi PC Plus.

## 11. Como executar <a id="comoExecutar"></a> 
### Ambiente de Trabalho
Abra um ambiente de trabalho adequado para manipular a OrangePi PC Plus.
### Compilação do projeto
1) Navegue até o diretório do projeto usando o terminal.
2) Execute o comando abaixo:
```bash
$ make all
```

## 12. Referências <a id="referencias"></a> 
- Datasheet - Allwinner H3: https://drive.google.com/file/d/1AV0gV4J4V9BVFAox6bcfLu2wDwzlYGHt/view. Acesso em 27 dez. 2023
- Datasheet - LCD HD44780U: https://www.sparkfun.com/datasheets/LCD/HD44780.pdf. Acesso em 27 dez. 2023
- Smith S. (2019). Raspberry Pi Assembly Language Programming.
- Repositório [TimerAssembly](https://github.com/AssemblyTimer/TimerAssembly) usado como referência.