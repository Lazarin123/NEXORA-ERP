# Nexora ERP

> **Nexora ERP 1.3.3** é uma aplicação de gestão local-first cuja
> interface, estilos e lógica principal estão reunidos em `index.html`.
> O pacote também oferece inicializador local em Python e um wrapper
> Electron para geração de aplicativos desktop. Os dados ficam no
> armazenamento do navegador/perfil e não são sincronizados
> automaticamente entre computadores.

---

## Visão geral

O Nexora ERP reúne, em uma única interface, recursos para organizar
operações comerciais e administrativas:

- Dashboard com indicadores e atividades.
- Cadastro e movimentação de produtos.
- Clientes e fornecedores.
- Entrada e conferência de notas, incluindo leitura de XML NF-e
  compatível.
- Financeiro: contas a pagar, contas a receber, baixas e conciliação
  assistida.
- Vendas e PDV local com leitor de código de barras.
- Relatórios, exportações e auditoria local.
- Colaboradores e permissões por página/ação.
- Ativos patrimoniais e gestão WMS.
- Inventário com contagem cega, reconciliação e relatório final.
- Etiquetas para produtos e ativos.
- Perfil pessoal, notificações, backup e restauração.

O projeto foi pensado para demonstração, avaliação e operação local
controlada. **Não é, nesta versão, um ERP multiusuário com banco
central, autenticação segura em servidor ou emissão fiscal oficial.**

## Índice

- [Demonstração e acesso](#demonstração-e-acesso)
- [Principais recursos](#principais-recursos)
- [Módulos](#módulos)
- [Inventário 1.3.3](#inventário-133)
- [Tecnologias e arquitetura](#tecnologias-e-arquitetura)
- [Estrutura do pacote](#estrutura-do-pacote)
- [Executar localmente](#executar-localmente)
- [Aplicativo desktop](#aplicativo-desktop)
- [Dados, backup e restauração](#dados-backup-e-restauração)
- [Personalização da marca](#personalização-da-marca)
- [Publicação como demonstração
  web](#publicação-como-demonstração-web)
- [Homologação e testes](#homologação-e-testes)
- [Limitações e segurança](#limitações-e-segurança)
- [Solução de problemas](#solução-de-problemas)
- [Roadmap técnico](#roadmap-técnico)

---

## Demonstração e acesso

A aplicação inclui dados fictícios para avaliação local.

Campo Acesso de demonstração

---

E-mail `demo@nexora.local`
Senha `Nexora123!`

Na tela de login, também é possível utilizar **Entrar com a
demonstração**.

> As credenciais são exclusivamente demonstrativas. O login atual é uma
> barreira de interface local, não um mecanismo de autenticação seguro.
> Não utilize a demonstração para proteger dados reais ou confidenciais.

## Principais recursos

---

Área Recursos

---

Interface Layout responsivo, navegação
lateral, busca global e temas
claro/escuro

Produtos Cadastro, SKU, EAN/GTIN, categoria,
custo, preço, mínimo, ideal, lote e
validade

Estoque Movimentos, ajustes permitidos,
histórico e custo médio ponderado
nos fluxos suportados

Parceiros Cadastro compartilhado de clientes
e fornecedores, CPF/CNPJ e consulta
de CEP

Notas Entrada manual, leitura de XML
compatível, conferência e estorno
nos fluxos suportados

Financeiro Títulos a pagar/receber, baixas
parciais/totais, baixa em lote e
conciliação assistida

PDV Scanner HID, carrinho, desconto,
venda à vista/a prazo, comprovante
não fiscal e estorno local

WMS Armazéns, posições, endereçamento,
transferência e contagem por
posição

Patrimônio Cadastro, atribuição,
transferência, baixa e histórico de
ativos

Inventário Sessões gerais/rotativas, contagem
cega, bloqueio operacional e
reconciliação auditada

Etiquetas Impressão de etiquetas de produtos
e ativos com código de barras Code
39

Relatórios Impressão/Salvar como PDF, CSV e
Excel XML nos módulos compatíveis

Administração Colaboradores, permissões locais,
auditoria e base/segurança

Dados IndexedDB, fallback localStorage,
backup JSON e restauração

---

## Módulos

### Dashboard

- Indicadores locais de estoque, títulos em aberto e alertas.
- Gráfico demonstrativo e atividades recentes.
- Busca global e filtros de período.
- Os números representam os registros existentes no navegador atual.

### Produtos e estoque

- Cadastro e edição de produtos com identificadores internos, SKU e
  EAN/GTIN.
- Categoria, unidade, custo, preço, estoque mínimo e ideal.
- Lote e validade de referência no cadastro atual.
- Movimentações de entrada/saída e ajustes suportados, com histórico.
- Importação e exportação CSV e importação do catálogo XML Nexora.
- Cálculo de custo médio ponderado nos movimentos compatíveis.
- Estoque negativo bloqueado por padrão.

**Regra de recebimento:** o saldo de estoque aumenta por meio da
confirmação de uma nota na tela **Entrada de Notas**. Cadastrar um
produto ou importar o catálogo não adiciona quantidade ao saldo. Ajustes
manuais de aumento fora de nota confirmada são bloqueados pelo fluxo
central de movimentos.

**Limite de lotes:** cada cadastro de produto mantém um lote e uma
validade de referência. O controle de vários lotes simultâneos para o
mesmo SKU, cada um com saldo independente, exige evolução futura.

### Clientes e fornecedores

- Um parceiro pode ser cliente, fornecedor ou ambos.
- Validação matemática local de CPF e CNPJ.
- Suporte ao formato de CNPJ alfanumérico conforme a regra
  implementada.
- Consulta de endereço pelo ViaCEP.
- Pré-preenchimento de dados empresariais pela BrasilAPI, quando
  disponível.

As consultas externas dependem de conectividade e disponibilidade dos
serviços. Validação matemática não comprova regularidade cadastral
perante a Receita Federal.

### Entrada de notas

- Lançamento manual de nota e revisão de fornecedor, itens e valores.
- Leitura de XML NF-e para pré-preenchimento quando o documento segue
  a estrutura reconhecida.
- Vínculo entre itens da nota e produtos cadastrados.
- Conferência de totais com tolerância de R\$ 0,05 no fluxo descrito.
- Confirmação gera movimentos de estoque e títulos a pagar
  relacionados.
- Estorno cria movimentos inversos e preserva histórico nos casos
  suportados.

A leitura automática exige conferência humana. OCR de PDF/imagem,
processamento de XLSX em fila e retenção fiscal em storage de servidor
não fazem parte desta edição.

### Financeiro

- Contas a pagar e contas a receber.
- Criação e edição de títulos, vencimentos e filtros.
- Baixas parciais e totais, com método e conta.
- Baixa em lote de um ou vários títulos elegíveis do mesmo tipo.
- Importação OFX/CSV nos formatos reconhecidos.
- Sugestões de conciliação com confirmação manual.
- Histórico de baixas e possibilidade de desfazer conciliação nos
  fluxos permitidos.

O módulo é operacional/local e não substitui um sistema contábil
certificado. Não presuma DRE fiscal completa, fechamento contábil formal
ou cobertura de todas as regras contábeis.

### Vendas e PDV local

- Busca manual por nome, SKU ou EAN/GTIN.
- Leitura por scanner USB/Bluetooth configurado como teclado HID
  (_keyboard wedge_).
- Carrinho com quantidade, remoção, subtotal, desconto percentual e
  total.
- Validação de produto ativo e saldo disponível.
- Venda à vista com registro local na conta/caixa selecionada.
- Venda a prazo com título em contas a receber.
- Histórico, exportação e estorno local com motivo obrigatório.
- Comprovante imprimível identificado como **não fiscal**.
- Atalhos: `F2` foca o leitor, `F4` abre a finalização e `Esc` limpa a
  busca quando o campo está focado.

**Configuração do leitor:** configure o scanner como USB HID Keyboard ou
teclado Bluetooth e programe o sufixo Enter/CR. Cadastre o código real
no campo EAN/GTIN ou SKU do produto. O scanner deve digitar no campo de
leitura do PDV.

O PDV não integra TEF, maquininha, cobrança real de cartão, confirmação
bancária de PIX ou emissão de NFC-e/NF-e/SAT. O meio de pagamento é
registrado pelo operador; a transação deve ser confirmada separadamente
no serviço ou dispositivo externo. O estorno local não desfaz uma
transação bancária/adquirente nem cancela documento fiscal externo.

### Ativos e patrimônio

- Cadastro de computadores, notebooks, monitores, periféricos,
  impressoras e outros bens.
- ID interno e código patrimonial gerados pelo sistema.
- Marca, modelo, série, status, condição, aquisição, valor e garantia.
- Setor, localização física, responsável e observações.
- Atribuição/transferência, baixa com motivo e histórico.
- Catálogo editável de categorias e setores.
- Bloqueio de número de série ativo duplicado nos fluxos
  implementados.
- Exportação CSV.

### WMS / Armazém

- Cadastro de armazéns e posições.
- Endereçamento por zona, corredor, rack, prateleira e bin.
- Capacidade em unidades, pesquisa e histórico.
- Transferência entre posições sem alterar o saldo total.
- Recebimentos confirmados por nota entram inicialmente como **sem
  endereço**.
- Saídas consomem primeiro o saldo sem endereço e depois o saldo
  alocado.
- Contagem física por posição e exportação CSV.

### Inventário e etiquetas

- Inventários gerais ou rotativos por escopo, categoria ou setor.
- Contagem de produtos e ativos patrimoniais.
- Fotografia do saldo/estado esperado ao iniciar a contagem.
- Bloqueio operacional do item enquanto está em contagem.
- Reconciliação somente após confirmação de **Finalizar item**.
- Etiquetas selecionáveis por produto ou ativo, com múltiplos tamanhos
  e cópias.
- Código de barras SVG em simbologia Code 39.

### Relatórios, notificações e auditoria

- Relatórios com impressão em janela própria e opção **Salvar como
  PDF** do navegador.
- Exportação CSV e Excel XML (SpreadsheetML) nos módulos compatíveis.
- Auditoria local exportável e imprimível.
- Alertas de validade e notificações com estado lido/não lido.
- Perfil pessoal com nome, foto e bio opcional.

A auditoria é armazenada localmente e pode ser alterada por quem
controla o navegador. Não equivale a uma trilha de auditoria imutável em
servidor.

### Colaboradores e permissões

Perfis iniciais incluem Administrador, Gestor, Financeiro, Estoquista,
Vendedor, Somente leitura e Personalizado. A matriz local permite
controlar visualização de páginas e ações como criar, editar, movimentar
estoque, baixar títulos, conciliar e exportar.

As regras de permissão do HTML são proteções de fluxo na interface. Em
produção, toda autorização deve ser validada novamente no backend, em
cada requisição.

---

## Inventário 1.3.3

A versão 1.3.3 introduz **contagem cega** e relatório final por
item/lote.

Durante a contagem, o operador visualiza identificadores, categoria,
SKU/EAN, lote, validade/série e estado da contagem. A quantidade
esperada, o saldo atual e a divergência ficam ocultos até o encerramento
integral da sessão.

- A quantidade física começa em branco.
- O sistema registra internamente uma fotografia do saldo/estado
  inicial.
- A sessão só pode ser encerrada quando todos os itens forem
  finalizados.
- Depois do encerramento, usuários autorizados podem abrir o relatório
  final em janela própria, imprimir/Salvar como PDF ou exportar CSV.
- O relatório separa **Produtos e lotes** de **Ativos patrimoniais**.
- Entre os campos disponíveis estão quantidade esperada, contada,
  divergência, saldo final, WMS, série, situação, setor, localização e
  responsável.
- O relatório/exportação só fica disponível após a conclusão de todos
  os itens.

A reconciliação considera alterações inesperadas no saldo desde a
fotografia inicial e solicita revisão quando necessário. Consulte o
histórico de atualização e a interface para o comportamento detalhado da
versão instalada.

---

## Tecnologias e arquitetura

```{=html}
<p>
```

`<img alt="HTML5" src="https://img.shields.io/badge/HTML5-E34F26?style=flat-square&logo=html5&logoColor=white">`{=html}
`<img alt="CSS3" src="https://img.shields.io/badge/CSS3-1572B6?style=flat-square&logo=css3&logoColor=white">`{=html}
`<img alt="JavaScript" src="https://img.shields.io/badge/JavaScript-F7DF1E?style=flat-square&logo=javascript&logoColor=black">`{=html}
`<img alt="Python" src="https://img.shields.io/badge/Python-3776AB?style=flat-square&logo=python&logoColor=white">`{=html}
`<img alt="Electron" src="https://img.shields.io/badge/Electron-47848F?style=flat-square&logo=electron&logoColor=white">`{=html}
`<img alt="Node.js" src="https://img.shields.io/badge/Node.js-339933?style=flat-square&logo=nodedotjs&logoColor=white">`{=html}
`<img alt="IndexedDB" src="https://img.shields.io/badge/IndexedDB-browser%20storage-6B7280?style=flat-square">`{=html}

```{=html}
</p>
```

Tecnologia/recurso Utilização

---

HTML5 Estrutura da aplicação principal
CSS3 Estilos e responsividade integrados ao HTML
JavaScript Regras e interações integradas ao HTML
IndexedDB Persistência local principal
localStorage Fallback de armazenamento local
Python 3 Servidor local simples para servir o HTML por loopback
Electron Empacotamento desktop
Electron Builder Geração de instaladores e pacotes
ViaCEP Consulta de CEP
BrasilAPI Pré-preenchimento de dados de CNPJ

### Visão simplificada

```text
Nexora ERP
│
├── index.html
│   ├── HTML da interface
│   ├── CSS integrado
│   └── JavaScript integrado
│
├── Armazenamento do navegador
│   ├── IndexedDB (principal)
│   └── localStorage (fallback)
│
├── iniciar_local.py
│   └── Servidor local em 127.0.0.1
│
└── desktop-app/
    └── Electron + Electron Builder
```

**Importante:** não há API própria nem banco de dados central nesta
versão. As integrações ViaCEP e BrasilAPI são chamadas externas
específicas, não um backend do Nexora.

## Estrutura do pacote

A estrutura pode variar conforme o ZIP/release distribuído. No pacote
1.3.3, os principais arquivos são:

```text
Nexora-ERP/
├── index.html
├── README.md
├── INICIAR_LOCAL.bat
├── INICIAR_LOCAL.sh
├── iniciar_local.py
├── GERAR_INSTALADOR_WINDOWS.bat
├── GERAR_EXECUTAVEL_WINDOWS.bat
├── GERAR_INSTALADOR_LINUX.sh
├── GERAR_INSTALADOR_LINUX_WSL.bat
├── CHECKLIST_HOMOLOGACAO.md
├── MATRIZ_HOMOLOGACAO_1400.md
├── GUIA_RAPIDO_PDV.md
├── DIAGNOSTICO_EXECUTAVEL.md
├── desktop-app/
│   ├── index.html
│   ├── main.cjs
│   └── package.json
└── arquivos de teste/documentação
```

`index.html` é a aplicação principal em arquivo único. A pasta
`desktop-app/` contém a cópia incorporada usada no empacotamento
Electron. Ao atualizar a aplicação, mantenha a cópia desktop
sincronizada conforme o procedimento de build do pacote.

## Executar localmente

### Requisitos

- Windows, Linux ou macOS para executar pelo inicializador Python.
- Python 3 instalado.
- Navegador moderno, como Chrome ou Edge.

### Windows

1.  Baixe ou clone o repositório.
2.  Extraia o pacote para uma pasta normal.
3.  Instale Python 3, se necessário, habilitando a opção de adicionar
    Python ao `PATH`.
4.  Execute `INICIAR_LOCAL.bat`.
5.  Aguarde o navegador abrir no endereço local informado pelo terminal.
6.  Entre com a conta de demonstração.

### Linux/macOS

Na raiz do projeto:

```bash
python3 --version
python3 iniciar_local.py
```

Ou, se o pacote possuir o script executável:

```bash
chmod +x INICIAR_LOCAL.sh
./INICIAR_LOCAL.sh
```

### Execução manual no Windows

```bash
python --version
python iniciar_local.py
```

O inicializador escolhe uma porta livre e serve o HTML em `127.0.0.1`.
Mantenha o terminal aberto enquanto utiliza o sistema.

> Não abra o `index.html` diretamente dentro da visualização do ZIP.
> Também não substitua `127.0.0.1` por `0.0.0.0`: o servidor foi
> projetado para acesso local, não para compartilhar o armazenamento
> pela rede.

## Aplicativo desktop

O pacote inclui um wrapper Electron para gerar versões desktop. Os
binários não necessariamente acompanham o código-fonte: os scripts criam
os arquivos finais em `desktop-app/dist/`.

### Requisitos de build

- Node.js LTS 20 ou superior.
- npm.
- Internet na primeira compilação para baixar dependências e Electron.
- Espaço em disco para dependências e empacotamento.

### Windows x64

---

Objetivo Script Saída esperada

---

Instalador NSIS `GERAR_INSTALADOR_WINDOWS.bat` `Nexora-ERP-1.3.3-Setup.exe`

Executável portátil `GERAR_EXECUTAVEL_WINDOWS.bat` `Nexora-ERP-1.3.3-portable.exe`

---

Execute o script correspondente na raiz do pacote.

### Linux x64

```bash
chmod +x GERAR_INSTALADOR_LINUX.sh
./GERAR_INSTALADOR_LINUX.sh
```

O build gera os formatos AppImage e DEB, conforme a configuração do
projeto.

### Windows com WSL2

É possível usar `GERAR_INSTALADOR_LINUX_WSL.bat`, desde que Node.js e
npm também estejam instalados dentro da distribuição Linux do WSL. Para
builds mais consistentes, mantenha o projeto no sistema de arquivos
Linux, por exemplo em `~/nexora-build`.

**Recomendação:** compile cada plataforma no sistema correspondente
sempre que possível. Não compartilhe `node_modules` entre Windows e
Linux.

Electron incorpora Chromium e Node.js; por isso, o pacote desktop tende
a ser maior e consumir mais memória que uma aplicação nativa mínima. O
tamanho final deve ser medido após a compilação.

## Dados, backup e restauração

### Onde os dados ficam?

A aplicação utiliza IndexedDB como armazenamento principal e tenta
localStorage como fallback.

---

Cenário Compartilha os dados?

---

Mesmo navegador, perfil e origem Sim, nesse mesmo contexto local

Outro perfil ou navegador Não

Outro computador Não

Site estático aberto por visitantes Não
diferentes

Backend e banco central (não Seria compartilhado conforme a
incluídos) arquitetura implantada

---

Origens como `file://`, `http://localhost`, `http://127.0.0.1` e o
domínio publicado podem manter armazenamentos separados.

### Fazer backup

1.  Entre no Nexora ERP.
2.  Use a ação **Exportar backup** ou o ícone de download.
3.  Guarde o arquivo JSON com data no nome.
4.  Mantenha uma cópia em outro dispositivo ou volume protegido.
5.  Faça backups periódicos e antes de atualizações ou operações
    administrativas sensíveis.

### Restaurar backup

1.  Abra o Nexora no perfil em que deseja restaurar.
2.  Selecione **Importar backup**.
3.  Escolha um JSON exportado anteriormente.
4.  Leia e confirme a operação.
5.  Sempre que possível, valide primeiro em um perfil de teste.

O backup JSON não é criptografado automaticamente e pode conter
informações pessoais, comerciais e financeiras. Trate-o como arquivo
confidencial. Limpar os dados do navegador, usar modo privado ou trocar
de perfil/origem pode tornar os dados locais inacessíveis.

## Personalização da marca

A aplicação foi preparada para permitir personalização por cliente. No
`index.html`, localize o objeto `CONFIG` e os tokens CSS
correspondentes.

---

Elemento Local de configuração

---

Nome do sistema `CONFIG.appName`

Slogan `CONFIG.tagline`

E-mail de suporte `CONFIG.supportEmail`

Cor principal `CONFIG.brandColor` e tokens CSS
`--brand`/`--brand-hover`

Logotipo Função `brandMark()`

Tema inicial `CONFIG.defaultTheme` e variáveis
CSS

---

### Fluxo recomendado

1.  Duplique a pasta-base para o cliente.
2.  Altere nome, slogan, e-mail e cores.
3.  Substitua o SVG da marca pelo logotipo autorizado.
4.  Atualize o título da página, metadados e textos fixos.
5.  Teste contraste, navegação, formulários e responsividade.
6.  Faça backup e restauração de teste.
7.  Preserve uma cópia-base sem personalizações.

Uma configuração de marca salva no navegador não separa empresas de
forma segura. Para clientes distintos, mantenha cópias independentes ou
implemente organizações e isolamento de dados no backend.

## Publicação como demonstração web

O `index.html` pode ser hospedado como site estático em serviços como
GitHub Pages, Cloudflare Pages ou Vercel, desde que o arquivo esteja no
caminho de publicação configurado.

Passos gerais:

1.  Coloque `index.html` na raiz do repositório (ou na pasta de saída
    configurada).
2.  Conecte o repositório ao serviço de hospedagem.
3.  Configure o projeto como site estático, sem etapa de build de
    framework.
4.  Publique e teste a URL gerada.

**Hospedar a interface não hospeda o banco de dados.** Cada visitante
continuará utilizando o armazenamento local do próprio navegador. Não
apresente a publicação estática como ERP multiusuário e não utilize
dados reais de clientes nessa demonstração.

Referências: - [Cloudflare Pages --- Static
HTML](https://developers.cloudflare.com/pages/framework-guides/deploy-anything/) -
[Vercel --- Deployments](https://vercel.com/docs/deployments) - [GitHub
Pages](https://docs.github.com/pages)

## Homologação e testes

O pacote contém documentos de apoio:

- `CHECKLIST_HOMOLOGACAO.md`: checklist resumido para registrar testes
  reais.
- `MATRIZ_HOMOLOGACAO_1400.md`: matriz documental com 1.400 cenários
  planejados.
- `GUIA_RAPIDO_PDV.md`: orientação para scanner, finalização,
  pagamentos, impressão e estorno.
- `DIAGNOSTICO_EXECUTAVEL.md`: diagnóstico de build e distribuição.

A matriz de 1.400 cenários é um roteiro de homologação; **não significa
que 1.400 testes automatizados foram executados**.

### Validações técnicas registradas

Na revisão documentada do pacote, foram realizados checks de sintaxe
JavaScript com Node, parsing do `package.json`, verificações estáticas e
testes de lógica de fluxos selecionados. A automação visual do navegador
foi bloqueada pelo ambiente em uma etapa de validação; portanto, os
fluxos visuais e os dispositivos físicos precisam ser homologados na
máquina de destino.

### Checklist sugerido

- [ ] Executar a aplicação em Chrome e Edge.
- [ ] Testar em resolução desktop e viewport móvel.
- [ ] Criar, editar e pesquisar produtos.
- [ ] Conferir bloqueio de estoque negativo.
- [ ] Importar catálogo e confirmar uma nota fictícia.
- [ ] Validar movimentos de estoque e títulos financeiros.
- [ ] Testar baixa parcial, total e em lote.
- [ ] Importar extrato de teste e confirmar conciliação manual.
- [ ] Testar leitor HID com sufixo Enter.
- [ ] Validar venda à vista, venda a prazo e estorno local.
- [ ] Imprimir comprovante não fiscal e etiquetas.
- [ ] Testar WMS, transferência e contagem física.
- [ ] Testar inventário cego, finalização e relatório final.
- [ ] Testar perfis e permissões com usuários fictícios.
- [ ] Exportar backup e restaurar em perfil separado.
- [ ] Testar instaladores em máquinas limpas Windows/Linux.

## Limitações e segurança

Esta seção é essencial para entender o escopo da versão atual.

---

Recurso Situação

---

Aplicação principal HTML único com CSS e JavaScript
integrados

Persistência IndexedDB/localStorage no navegador
ou perfil desktop

Banco central/API própria Não incluídos

Sincronização entre computadores Não implementada

Login Demonstração local; não é
autenticação de produção

Permissões Barreiras de interface locais; não
substituem autorização no servidor

Auditoria Local e editável por quem controla
o armazenamento

Backup automático em servidor Não implementado; exportação JSON
manual

Emissão NF-e/NFC-e/SAT Não implementada

TEF/maquininha/PIX bancário Não integrados

OCR de PDF/imagem e processamento Não implementados
fiscal em fila

Multiempresa real Não implementado

Testes Checks e testes selecionados; não
há suíte integral comprovada

---

### Antes de usar em produção

Para transformar o protótipo local-first em uma solução comercial
multiusuário, será necessário implementar, no mínimo:

- API autenticada e banco de dados central.
- Isolamento de dados por empresa validado em cada rota.
- Senhas com hash seguro, sessões com expiração/revogação e proteção
  contra abuso.
- Autorização RBAC no servidor, não apenas ocultação de páginas.
- Transações atômicas para operações que envolvam nota, estoque e
  financeiro.
- Armazenamento privado de documentos e validação de uploads.
- Backups criptografados, externos ao servidor e com testes de
  restauração.
- Logs de auditoria no servidor, monitoramento e plano de incidentes.
- Revisão de segurança, privacidade e requisitos legais/fiscais.

Não utilize dados pessoais reais em demonstrações públicas. Para
adequação à LGPD, defina finalidade, base legal, retenção, minimização,
controle de acesso e processo para atendimento aos titulares, com
orientação especializada.

A leitura/conferência de XML não representa emissão ou autorização
fiscal. Certificado digital, regras estaduais, comunicação com SEFAZ e
validação contábil não estão incluídos.

## Solução de problemas

```{=html}
<details>
```

```{=html}
<summary>
```

`<strong>`{=html}O sistema não abre ou fica carregando`</strong>`{=html}

```{=html}
</summary>
```

Extraia o ZIP para uma pasta normal e execute `INICIAR_LOCAL.bat`.
Mantenha o terminal aberto. Feche abas antigas do Nexora e reinicie o
inicializador. Confira se Python 3 está instalado.

```{=html}
</details>
```

```{=html}
<details>
```

```{=html}
<summary>
```

`<strong>`{=html}O navegador mostra código HTML como
texto`</strong>`{=html}

```{=html}
</summary>
```

Não abra o arquivo pelo visualizador do ZIP ou por um visualizador de
texto. Execute `INICIAR_LOCAL.bat` e abra o endereço
`http://127.0.0.1:PORTA/index.html` exibido no terminal.

```{=html}
</details>
```

```{=html}
<details>
```

```{=html}
<summary>
```

`<strong>`{=html}Os dados não aparecem em outro
computador`</strong>`{=html}

```{=html}
</summary>
```

É o comportamento esperado da arquitetura local-first. Cada
navegador/perfil possui seu próprio armazenamento. Para compartilhar
dados, será necessário desenvolver uma API e um banco central.

```{=html}
</details>
```

```{=html}
<details>
```

```{=html}
<summary>
```

`<strong>`{=html}Os dados desapareceram`</strong>`{=html}

```{=html}
</summary>
```

Confira se está utilizando o mesmo navegador, perfil e origem. Verifique
se o navegador estava em modo privado ou se os dados do site foram
apagados. Se o armazenamento foi removido e não existe backup, talvez
não seja possível recuperar os registros.

```{=html}
</details>
```

```{=html}
<details>
```

```{=html}
<summary>
```

`<strong>`{=html}O scanner não adiciona o produto`</strong>`{=html}

```{=html}
</summary>
```

Confirme que o leitor está configurado como teclado HID, que o campo do
scanner está focado e que o sufixo Enter está habilitado. Verifique se o
código lido corresponde ao SKU ou EAN/GTIN cadastrado. Teste o leitor em
um editor de texto.

```{=html}
</details>
```

```{=html}
<details>
```

```{=html}
<summary>
```

`<strong>`{=html}A impressão não abre ou sai no tamanho
errado`</strong>`{=html}

```{=html}
</summary>
```

Permita pop-ups para a aplicação, instale o driver da impressora e
selecione o papel/tamanho disponível na janela de impressão do
navegador. A aplicação não controla diretamente o hardware da impressora
nesta edição.

```{=html}
</details>
```

```{=html}
<details>
```

```{=html}
<summary>
```

`<strong>`{=html}Uma nota não pode ser confirmada`</strong>`{=html}

```{=html}
</summary>
```

Confira o fornecedor, os produtos vinculados, quantidades e valores.
Revise o total calculado e compare com o XML original. A leitura do
documento não substitui a conferência humana.

```{=html}
</details>
```

## Roadmap técnico

Próximas evoluções recomendadas:

1.  Refatorar regras de negócio, interface e persistência em módulos
    testáveis.
2.  Criar API e banco central com migrações e transações.
3.  Implementar autenticação, autorização e isolamento multiempresa no
    servidor.
4.  Ampliar e validar o processamento de documentos fiscais.
5.  Evoluir conciliação, relatórios e controles financeiros com revisão
    especializada.
6.  Implementar sincronização, backups automáticos e monitoramento.
7.  Homologar instalação, atualização e operação em hardware real.
8.  Avaliar controle de múltiplos lotes por SKU com saldo independente.

---

## Licença e uso

Defina aqui a licença aplicável antes de distribuir ou comercializar o
projeto. A ausência de um arquivo de licença não concede automaticamente
permissão irrestrita de uso, cópia ou redistribuição.

---

```{=html}
<p align="center">
```

`<strong>`{=html}Nexora ERP`</strong>`{=html}`<br>`{=html} Gestão
integrada. Operação organizada. Evolução contínua.

```{=html}
</p>
```

```{=html}
<p align="center">
```

`<sub>`{=html}Documentação referente ao pacote Nexora ERP
1.3.3.`</sub>`{=html}

```{=html}
</p>
```
