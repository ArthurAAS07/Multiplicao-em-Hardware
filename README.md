# 🔢 Multiplicação Inteira em Hardware

Projeto desenvolvido para a disciplina de **Organização e Arquitetura de Computadores**, com o objetivo de implementar e comparar diferentes arquiteturas de multiplicadores inteiros em hardware.

---

## 📚 Objetivo

O projeto tem como objetivo analisar o impacto de diferentes abordagens de multiplicação em hardware, comparando:

* ⏱️ **Desempenho (número de ciclos)**
* 🧠 **Uso de recursos de hardware (FPGA)**

---

## ⚙️ Tecnologias Utilizadas

* **SystemVerilog** – descrição do hardware
* **ModelSim** – simulação
* **Quartus** – síntese para FPGA

---

## 🧱 Estrutura do Projeto

* `multiplicador_refinado.sv` → Módulo principal
* `datapath_refinado.sv` → Caminho de dados (datapath)
* `fsm_controle1.sv` → Unidade de controle (FSM)
* `tb_multiplicador_refinado.sv` → Testbench para simulação

---

## 🚀 Funcionamento

O multiplicador implementado utiliza uma versão otimizada do algoritmo de multiplicação binária, com melhorias que reduzem o número de ciclos e aumentam a eficiência do hardware.

### 🔹 Principais características:

* O registrador de **produto** também armazena o multiplicador
* As operações de **soma e deslocamento (shift)** são combinadas no mesmo ciclo
* O controle é feito por uma **FSM**, evitando estados desnecessários
* Redução de operações redundantes ao longo da execução

---

## 🧪 Simulação (ModelSim)

Durante a simulação, é possível observar:

* Sinal de clock (`clk`)
* Início da operação (`start`)
* Finalização (`done`)
* Número 1 (`A`)
* Número 2 (`B`)
* Resultado (`produto`)

---

## 📊 Métricas Analisadas

### ⏱️ Número de Ciclos

Medido pelo tempo de execução:

* Time / 5 → ciclos de clock 

---

### 🧠 Uso de Hardware

Obtido através do **Quartus**, observando:

* Logic Elements (LEs)
* Registradores

---

## ⚖️ Comparação de Abordagens

| Abordagem            | Ciclos | Hardware |
| -------------------- | ------ | -------- |
| Simplificada         | Alto   | Médio    |
| Refinada             | Menor  | Baixo    |

---

## 📉 Fluxograma

*A ser adicionado*

---

## 🔄 FSM (Máquina de Estados)

A unidade de controle foi implementada como uma FSM responsável por:

* Controlar as operações do datapath
* Gerenciar os estados da multiplicação
* Coordenar sinais como `start`, `done` e operações da ALU

---

## 🎥 Demonstração

O projeto inclui um vídeo demonstrando:

* Execução da simulação no ModelSim
* Comparação entre versões
* Análise de desempenho e uso de hardware

---

## 📌 Autores

* Arthur Albuquerque
* Pedro Magnata
* Marcela Paranhos
* Nina Schettini

---
