<a id="top"></a>
# INTERFACE SBC ARM

* * *

## Sensor de Temperatura e Umidade- TEC499 - MI Sistemas Digitais

Professor: Thiago Cerqueira de Jesus

Dupla: Gabriel Costa Baptista, Márcio Roberto e Kauan Caio de Arruda Farias

* * *

## Seções 

&nbsp;&nbsp;&nbsp;[**1.** Introdução](#introducao)

&nbsp;&nbsp;&nbsp;[**2.** Hardware Utilizado](#hardware_utilizado)


<a id="introducao"></a>
## Introdução

Descrição do problema e solução.

Propriedades do projeto:
  - Escrever Propriedades

{...} permite no mínimo as seguinte operações: ```
1) Escrever operações
```
Além de:
```
4) Deslocar cursor do display para a direita
5) Ligar display, ativar cursor e fazê-lo piscar
6) Desligar display
7) Return Home
```

* * *
<a id="hardware_utilizado"></a>
## Hardware Utilizado:
O hardware utilizado para a síntese e testes deste projeto é uma Orange PI PC Plus, com 40 pinos GPIO e um processador H3 Quad-core Cortex-A7 H.265/HEVC 4K com arquitetura ARM V7, rodando o sistema operacional Raspbian com Kernel proprietário e em sua versão 5.15.74-sunxi.
## [Orange Pi PC Plus](http://www.orangepi.org/html/hardWare/computerAndMicrocontrollers/details/Orange-Pi-PC-Plus.html)

### Especificações - Orange PI PC Plus:

<img src="./src/OrangePI.png" alt="isolated" width="400"/>
<!-- ![Orange PI PC Plus](./src/OrangePI.png) -->


| CPU | H3 Quad-core Cortex-A7 H.265/HEVC 4K   |
|:--- |                                   ---: |
| GPU |     Mali400MP2 GPU @600MHz             |
| Memória (SDRAM) |  1GB DDR3 (shared with GPU)|
| Armazenamento interno | Cartão MicroSD (32 GB); 8GB eMMC Flash|
| Rede embarcada | 10/100 Ethernet RJ45        |
| Fonte de alimentação | Entrada DC,<br>entradas USB e OTG não servem como fonte de alimentação | 
| Portas USB | 3 Portas USB 2.0, uma porta OTG USB 2.0 |
| Periféricos de baixo nível | 40 pinos        |

### Pinout Orange PI PC Plus:
Por meio dos pinos de entrada e saída de propósito geral foi possível prosseguir com a solução e
enviar dados e comandos ao display LCD 16x2 e interagir com os botões push, todos os pinos do computador estão dispostos conforme a figura abaixo:

<img src="./src/pinagemOrange.png" alt="isolated" width="500"/>
<!-- ![Disposição dos pinos Orange PI PC Plus](./src/pinagemOrange.png) -->

#### [Voltar ao topo](#top)
