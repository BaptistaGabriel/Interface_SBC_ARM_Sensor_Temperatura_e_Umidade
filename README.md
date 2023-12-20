<a id="top"></a>
# INTERFACE SBC ARM

* * *

## Sensor de Temperatura e Umidade- TEC499 - MI Sistemas Digitais

Professor: Anfranserai Morais Dias

## Componentes da equipe: 
- Gabriel Costa Baptista [BaptistaGabriel](https://github.com/BaptistaGabriel)
- Márcio Roberto Fernandes dos Santos Lima [MarcioDzn](https://github.com/MarcioDzn)
- Kauan Caio de Arruda Farias [kakafariaZ](https://github.com/kakafariaZ)

* * *

## Seções 

&nbsp;&nbsp;&nbsp;[**1.** Introdução](#introducao)

&nbsp;&nbsp;&nbsp;[**2.** Hardware Utilizado](#hardware_utilizado)


<a id="introducao"></a>
## Introdução


Neste projeto avançado da disciplina TEC 499 - Sistemas Digitais, mergulhamos na intricada tarefa de desenvolver uma Interface Homem-Máquina (IHM) utilizando um diplay LCD 16x2. O foco central recai sobre a programação em Assembly ARM-v7 para a Interface Single-Board Computer (SBC) Orange PI PC PLUS, a qual é enriquecida pela integração de uma comunicação serial UART com um Sensor UHT-11 de temperatura e umidade. Esta iniciativa não apenas desafia nossa compreensão das complexidades da arquitetura ARM, mas também destaca a importância da interação precisa entre hardware e software para criar uma IHM eficiente e responsiva. Ao unir elementos cruciais e a comunicação serial com sensores, elevando nossas habilidades na criação de sistemas digitais avançados.

Propriedades do projeto:
  - Menu no display LCD:
  - Solicitação do requerimento:
    - Umidade atual
    - Temperatura atual
    - Monitoramento da umidade atual
    - Monitoramento da temperatura atual

* * *
<a id="hardware_utilizado"></a>
## Hardware Utilizado:
O hardware empregado na síntese e testes deste projeto é uma Orange PI PC Plus, que conta com 40 pinos GPIO e é alimentada por um processador H3 Quad-core Cortex-A7 H.265/HEVC 4K, baseado na arquitetura ARM V7. O sistema operacional utilizado é o Raspbian, com um kernel proprietário, destacando-se na versão 5.15.74-sunxi. Essa configuração robusta proporciona um ambiente sólido e eficiente para o desenvolvimento e implementação da Interface Single-Board Computer (SBC) em Assembly ARM-v7, a qual integra um LCD 16x2 e estabelece comunicação serial UART com um Sensor UHT-11 de temperatura e umidade.
## [Orange Pi PC Plus]
<img src="http://www.orangepi.org/img/img4/banner-PC-PLUS.jpg" alt="Texto Alternativo" width="400" height="295,2">
<!-- ![Orange PI PC Plus](http://www.orangepi.org/img/img4/banner-PC-PLUS.jpg) -->
### Especificações - Orange PI PC Plus:

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
A solução foi viabilizada através dos pinos de entrada e saída de propósito geral, permitindo a transmissão de dados e comandos para o display LCD 16x2 e a interação com os botões push. 
A disposição dos pinos no computador segue a configuração representada na figura abaixo:

<img src="http://www.orangepi.org/img/computersAndMmicrocontrollers/Pc-Plus/Rectangle%20741.png" alt="Texto Alternativo" width="400" height="316,333">
<!-- ![Disposição dos pinos Orange PI PC Plus](http://www.orangepi.org/img/computersAndMmicrocontrollers/Pc-Plus/Rectangle%20741.png) -->


#### [Voltar ao topo](#top)
