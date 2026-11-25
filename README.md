NEXORA ERP 1.3.3

## Atualização 1.3.3 — Inventário cego e relatório final por item/lote

Esta versão altera a experiência de contagem para não revelar o saldo do sistema durante a operação. Na tela de inventário e no formulário do operador aparecem identificação, categoria, SKU/EAN, lote, validade ou série e o estado da contagem; a quantidade esperada, o saldo atual e a divergência ficam ocultos até o encerramento integral da sessão.

Depois que todos os itens forem finalizados e a sessão for encerrada, o usuário autorizado poderá abrir o **Relatório final / PDF** (janela própria com impressão/Salvar como PDF) ou exportar CSV. O relatório separa **Produtos e lotes** de **Ativos patrimoniais** e inclui categoria, identificadores, lote anterior e conferido, validade, quantidade esperada, quantidade contada, divergência, saldo final, WMS, número de série, situação, setor, localização e responsável.

A contagem de produto inicia com o campo de quantidade física em branco. O sistema mantém internamente a fotografia de saldo feita ao abrir o item para permitir comparação no relatório e reconciliação auditada na finalização. O botão de relatório final/exportação só é disponibilizado quando o inventário está concluído e todos os itens foram finalizados.

**Limite do modelo atual de produtos:** cada cadastro de produto mantém um lote e uma validade de referência. O inventário e o relatório distinguem e exibem esse lote por registro; controlar vários lotes simultâneos para o mesmo SKU, cada um com saldo próprio, exige uma evolução futura para saldos por lote.


# Nexora ERP | Pacote local-first

> **Estado do projeto:** versão 1.3.3. Estoque de entrada somente por notas confirmadas; o módulo independente PDV / Entrada foi removido e o PDV de vendas permanece separado. O pacote inclui interface local-first, perfil pessoal, colaboradores/permissões locais, alertas, relatório e financeiro, além de build desktop Electron para Windows x64 (instalador NSIS e EXE portátil) e Linux x64 (AppImage e DEB). A primeira compilação exige Node.js LTS 20+ e internet para obter dependências. A matriz de homologação de 1.400 cenários fica em `MATRIZ_HOMOLOGACAO_1400.md`, fora do HTML executado. O HTML principal desta versão tem aproximadamente 460 KiB. A app continua local-first, sem sincronização multiusuário nem emissão fiscal oficial.




## Atualização 1.3.2 — Correções finais de ativos, inventário, notificações e base administrativa

- **Ativos:** ao editar um ativo baixado e mudar o status para Em estoque, Em uso ou Em manutenção, o registro volta a ficar ativo. A mudança de status é registrada no histórico patrimonial e na auditoria.
- **Inventário:** a divergência é calculada e salva imediatamente como `quantidade contada - saldo esperado` (com três casas decimais). A coluna Divergência mostra valores positivos/negativos enquanto a contagem estiver salva. O saldo permanece bloqueado até finalizar o item. Antes da reconciliação, o sistema compara o saldo atual com a fotografia inicial; se houve alteração inesperada, recalcula a diferença e pede revisão.
- **Notificações:** cada aviso pode ser marcado como lido/não lido individualmente ou excluído da central sem apagar o dado que o originou. A opção “Limpar todas” permanece disponível. O contador do sino considera apenas avisos não lidos.
- **Base e segurança:** a página dedicada só aparece e só responde a ações de Administrador. Exige backup JSON atualizado, confirmação de que o backup foi guardado fora do dispositivo, revisão dos totais, digitação de `ZERAR` e uma segunda confirmação. Ao concluir, preserva apenas a conta de Administrador conectada e as categorias/setores patrimoniais padrão.

### Homologação específica 1.3.2

1. Baixe um ativo, edite-o para “Em uso” e salve; confira a listagem e o histórico.
2. Abra inventário de um produto com saldo 10; conte 12; salve e confira divergência +2 sem alteração imediata do saldo; finalize e confirme saldo 12. Repita com contagem 8 para divergência -2.
3. Marque uma notificação como lida; ela deve continuar no painel com etiqueta “Lida”. Marque como não lida e, em outro aviso, exclua apenas aquele item.
4. Entre com colaborador não administrador: a navegação não deve exibir “Base e segurança”, o acesso direto deve ser recusado e ações de backup/reset devem ser bloqueadas.
5. Entre como Administrador; tente avançar sem backup atual, sem as duas caixas, sem digitar `ZERAR` e sem a confirmação final. Todas essas tentativas devem ser recusadas. Faça backup, confirme as etapas e valide que a conta de Administrador continua acessível depois da limpeza.

A interface continua local-first. O controle de acesso do HTML protege os fluxos locais do aplicativo, mas não substitui autorização no servidor em uma implantação multiusuário.


## Atualização 1.3.1 — Inventário e etiquetas

### Gestão → Inventário
- Criar inventários **rotativos** (por escopo/categoria/setor) ou **gerais** (Produtos + Ativos, ou escopo definido).
- Abrir a contagem de um item grava uma fotografia do saldo/estado esperado e pausa aquele produto ou ativo no sistema. Enquanto a linha estiver `Contando` ou `Contado`, vendas, entradas de nota, movimentações WMS, edição/transferência de ativos e alterações de saldo são bloqueadas para o item.
- Salvar a contagem não altera imediatamente o saldo. A ação **Finalizar item** pede confirmação e só então reconcilia diferença de produto por movimento auditado ou registra a conferência patrimonial; o bloqueio é liberado apenas na finalização. Um item não pode ser iniciado em duas sessões ativas simultâneas.
- Uma sessão só pode ser encerrada quando todos os itens estiverem finalizados. O histórico pode ser exportado em CSV.

### Gestão → Etiquetas
- Escolha Produtos/Estoque ou Ativos/Máquinas; pesquise por ID, SKU, EAN, lote, nome, código patrimonial ou número de série.
- Selecione um ou vários registros, defina número de cópias e tamanho (70×40, 90×60 ou 100×70 mm) e imprima usando a janela de impressão do navegador/driver da impressora.
- O código de barras é gerado em SVG usando simbologia **Code 39**, sem carregar bibliotecas de terceiros. Para leitura, use um scanner que suporte Code 39; um EAN real continua aparecendo no detalhe da etiqueta, mas o gráfico impresso codifica o código escolhido no preview (EAN/SKU/ID).
- As etiquetas exibem informações úteis de produto/lote/validade/saldo/endereços WMS ou de patrimônio/marca/modelo/série/setor/local/responsável. A exportação de listas é CSV.

### Validação desta versão
- JavaScript do HTML validado com `node --check`; `package.json` parseado como JSON; cópia do HTML desktop sincronizada; scripts de inicialização/build e integridade do pacote verificados.
- O navegador automatizado foi bloqueado pelo ambiente de teste (`ERR_BLOCKED_BY_ADMINISTRATOR`), então os fluxos visuais de abrir modal, imprimir etiquetas e finalizar inventário ainda devem ser homologados no Chrome/Edge da máquina cliente. A matriz completa de cenários fica em `MATRIZ_HOMOLOGACAO_1400.md`, fora do HTML executado.

## Atualização 1.3.0 — Ativos e WMS

Esta versão acrescenta dois módulos integrados à mesma aplicação local-first:

- **Ativos e Patrimônio:** inventário de computadores, notebooks, monitores, periféricos, impressoras e demais bens. Cada ativo recebe ID e código patrimonial gerados pelo sistema, com categoria, marca, modelo, número de série, status, condição, aquisição, valor, garantia, setor, localização física, responsável e observações. Número de série ativo duplicado é bloqueado. Há transferência/atribuição, baixa com motivo, catálogo editável de categorias e setores e exportação CSV.
- **WMS / Armazém:** cadastro de armazéns/posições com código, zona, corredor, rack, prateleira, bin e capacidade em unidades; pesquisa de produtos; endereçamento de estoque, transferência entre posições, contagem física por posição e histórico/exportação CSV. A tela Produtos mostra os endereços WMS e abre o módulo correspondente; no WMS é possível voltar ao cadastro do produto.
- **Integração do fluxo:** confirmar uma nota aumenta o saldo de Produtos e registra o recebimento WMS como “sem endereço”. Depois, o estoque pode ser endereçado. Endereçar ou transferir entre posições não altera o saldo total. Saídas consomem primeiro o saldo sem endereço e, depois, o saldo alocado nas posições, atualizando o histórico.
- **Contagem física:** registra quantidade esperada, quantidade contada e diferença. A divergência fica registrada para revisão; não altera o estoque total silenciosamente.
- **Permissões:** os novos módulos aparecem na matriz de acessos de Colaboradores, com permissões separadas para visualizar, cadastrar/editar ativos, gerir catálogo, gerir posições, endereçar, mover, contar e exportar.

### Iniciar localmente

Extraia o ZIP e execute `INICIAR_LOCAL.bat` no Windows (Python 3) ou `INICIAR_LOCAL.sh` no Linux/macOS. O script Python usa loopback (`127.0.0.1`), uma porta livre, desativa listagem de diretório e serve o documento com o tipo MIME apropriado. Mantenha o terminal aberto durante o uso.

### Gerar aplicativos desktop

A pasta `desktop-app/` contém a versão incorporada do HTML, o código Electron e o `package.json`. Para compilar, instale Node.js LTS 20+ com npm e internet para baixar dependências:

- Windows instalador NSIS: `GERAR_INSTALADOR_WINDOWS.bat`.
- Windows portátil: `GERAR_EXECUTAVEL_WINDOWS.bat`.
- Linux x64 AppImage e DEB: `chmod +x GERAR_INSTALADOR_LINUX.sh && ./GERAR_INSTALADOR_LINUX.sh`.
- Windows + WSL2: `GERAR_INSTALADOR_LINUX_WSL.bat`, com Node/npm instalados na distribuição Linux.

O ZIP inclui o código e os scripts de build, não binários `.exe`, `.AppImage` ou `.deb` previamente compilados. Esses arquivos serão criados na pasta `desktop-app/dist/` após o build. O primeiro build requer internet.

**Base documental:** os seis protótipos do PDF de desenho e as regras técnicas do documento “Nexora ERP — Documento de Estruturação do Projeto” (outubro de 2026). A aplicação segue as áreas Dashboard, Estoque, Clientes e Fornecedores, Entrada de Notas e Financeiro; também inclui Relatórios, Colaboradores, Perfil Pessoal e Auditoria local. A página Configurações foi retirada da navegação; o modo claro/escuro fica no canto superior. Por solicitação posterior, o módulo de Vendas foi expandido com um PDV local para scanner, carrinho, baixa de estoque, recebimento, histórico e comprovante não fiscal; isso é uma extensão ao roadmap original, não uma alteração retroativa do PDF.

## Correção de inicialização nesta versão

Esta revisão evita que a tela fique carregando indefinidamente quando o IndexedDB fica pendente ou bloqueado. A interface tem uma rota de recuperação em modo local, e o inicializador deixou de depender da porta fixa 8080.

**Importante:** extraia o ZIP antes de executar. Não tente abrir o `index.html` diretamente dentro da visualização do ZIP. No Windows, abra `INICIAR_LOCAL.bat` e mantenha a janela preta aberta enquanto usa o sistema. Se o navegador já estiver com uma versão antiga aberta, feche todas as abas do Nexora antes de reiniciar.

Se a página ainda não abrir, confira se o Python 3 está instalado e se o endereço impresso na janela inicia com `http://127.0.0.1:`. Não altere para `0.0.0.0`.

**Se aparecer texto como `<!DOCTYPE html>`, `<script>` ou códigos HTML em vez do sistema:** feche essa aba, extraia o ZIP novamente e execute `INICIAR_LOCAL.bat`. Abra apenas o endereço `http://127.0.0.1:.../index.html` impresso na janela do inicializador. Não abra o arquivo em Visualizador de Arquivos/Editor, nem execute uma cópia antiga do `index.html`.

## Índice rápido

- [1. Começar em 2 minutos](#1-começar-em-2-minutos)
- [2. Login de demonstração](#2-login-de-demonstração)
- [3. Módulos que podem ser testados](#3-módulos-que-podem-ser-testados)
  - [PDV / Frente de Caixa e leitores de código de barras](#pdv--frente-de-caixa-e-leitores-de-código-de-barras)
- [4. Onde os dados ficam](#4-onde-os-dados-ficam)
- [5. Backup e restauração](#5-backup-e-restauração)
- [6. Personalização por cliente](#6-personalização-por-cliente)
- [7. Usar em máquinas dos clientes](#7-usar-em-máquinas-dos-clientes)
- [8. Publicar na web](#8-publicar-na-web)
- [9. Arquitetura para produção multiusuário](#9-arquitetura-para-produção-multiusuário)
- [10. Validação e checklist de homologação](#10-validação-e-checklist-de-homologação)
- [11. Limitações conhecidas](#11-limitações-conhecidas)
- [12. Segurança, LGPD e fiscal](#12-segurança-lgpd-e-fiscal)
- [13. Solução de problemas](#13-solução-de-problemas)
- [14. Roadmap sugerido](#14-roadmap-sugerido)

<details open>
<summary><strong>📦 O que há neste pacote?</strong></summary>

| Arquivo | Finalidade |
|---|---|
| `index.html` | Aplicação principal em arquivo único: HTML, CSS e JavaScript. Inclui os módulos Ativos e WMS. |
| `desktop-app/` | Wrapper Electron e HTML sincronizado para compilar o aplicativo desktop Windows/Linux. |
| `INICIAR_LOCAL.bat` / `INICIAR_LOCAL.sh` / `iniciar_local.py` | Inicializadores para executar o HTML por loopback. |
| `README.md` | Este manual com instalação, operação, personalização, hospedagem e limites. |
| `INICIAR_LOCAL.bat` | Chama o servidor local do projeto e abre o navegador em uma porta livre. Requer Python 3. |
| `iniciar_local.py` | Servidor de loopback que escolhe uma porta dinamicamente e força `text/html; charset=utf-8` para evitar exibição do HTML como texto. |
| `INICIAR_LOCAL.sh` | Atalho opcional para Linux/macOS com Python 3. |
| `CHECKLIST_HOMOLOGACAO.md` | Checklist resumido para registrar testes reais, inclusive permissões, estoque, parceiros e financeiro. |
| `RELATORIO_AJUSTES_1.0.5.md` | Histórico anterior de correções. |
| `RELATORIO_AJUSTES_1.0.6.md` | Histórico de correções anteriores. |
| `RELATORIO_AJUSTES_1.2.3.md` | Atualizações de menu, scanner desconhecido, alertas de validade, perfil e colaboradores. |
| `RELATORIO_AJUSTES_1.2.4.md` | Modais persistem ao clicar no fundo; identificação de CPF/CNPJ acompanha o tipo de pessoa. |
| `RELATORIO_AJUSTES_1.2.5.md` | Tema, menu, login e preparação de base limpa para novo cliente. |
| `desktop-app/` | Projeto Electron que incorpora a interface para gerar Windows e Linux. |
| `GERAR_EXECUTAVEL_WINDOWS.bat` | Gera o EXE portátil se Node.js e internet estiverem disponíveis. |
| `LEIA_PRIMEIRO.txt` | Instruções rápidas para versão 1.3.3 e builds de instaladores. |
| `GERAR_INSTALADOR_WINDOWS.bat` | Gera o instalador Windows NSIS com atalhos. |
| `GERAR_INSTALADOR_LINUX.sh` | Gera AppImage e pacote DEB para Linux x64. |
| `MATRIZ_HOMOLOGACAO_1400.md` | Matriz documental de 1.400 cenários planejados; não são testes todos executados. |
| `DIAGNOSTICO_EXECUTAVEL.md` | Solução de problemas de compilação e alternativas de distribuição. |
| `GUIA_RAPIDO_PDV.md` | Passo a passo do scanner, finalização, formas de pagamento, impressão e estorno. |

</details>

## Atualizações da versão 1.2.5

- Botão alternador de tema no cabeçalho, no PDV e na tela de Login; claro/branco é o padrão de novas instalações, com variáveis visuais próprias para o tema escuro.
- Página Configurações removida da navegação e das permissões visíveis.
- O recebimento de mercadorias é feito na tela Entrada de Notas; não há módulo independente PDV / Entrada.
- Botão administrativo vermelho e visível **Base limpa**: digite `ZERAR` para limpar os dados operacionais e preservar somente a conta de administrador atual; exporte backup antes.
- Login público apenas com e-mail e senha; cadastro removido da tela.
- Novo `GERAR_INSTALADOR_WINDOWS.bat` para criar instalador NSIS, além do EXE portátil.

## 1. Começar em 2 minutos

### Windows

1. Extraia o ZIP para uma pasta normal, por exemplo `C:\Nexora_ERP`.
2. Instale Python 3 se ainda não estiver instalado. Na instalação do Python, marque a opção para adicionar Python ao `PATH`.
3. Dê duplo clique em `INICIAR_LOCAL.bat`.
4. O navegador abre automaticamente um endereço `http://127.0.0.1:PORTA/index.html`; a porta é escolhida automaticamente.
5. Entre pelo botão **Entrar com a demonstração**.

### Manualmente

Abra um terminal dentro desta pasta e execute:

```bash
python --version
python iniciar_local.py
```

O script abre o navegador e mantém o servidor ativo. Em Linux/macOS, use `python3 iniciar_local.py` se o comando `python` não estiver disponível.

**Por que usar `localhost` em vez de abrir o arquivo diretamente?** Alguns navegadores restringem armazenamento quando a página usa `file://`. O servidor está vinculado a `127.0.0.1`, então só atende conexões feitas nesse mesmo computador. Não substitua por `0.0.0.0` para “compartilhar” o banco: isso não cria um banco multiusuário seguro.

## 2. Login de demonstração

| Campo | Valor |
|---|---|
| E-mail | `demo@nexora.local` |
| Senha | `Nexora123!` |

Clique no botão **Entrar com a demonstração** para evitar digitação.

O sistema inclui dados fictícios para experimentar os módulos. A tela mostra somente o Login; o cadastro público foi removido. O usuário de demonstração serve para homologação local. O login continua sendo uma barreira de interface, não autenticação de produção; dados do navegador podem ser inspecionados por quem controla o computador.

## 3. Módulos que podem ser testados

<details open>
<summary><strong>Dashboard</strong></summary>

- Indicadores locais de títulos em aberto, estoque e alertas.
- Gráfico demonstrativo e lista de atividades recentes.
- Busca global e filtros de período disponíveis na interface.
- Os números refletem somente os registros presentes no navegador. Não representam contabilidade oficial.
</details>

<details>
<summary><strong>Estoque / Produtos</strong></summary>

- Cadastro e edição de produtos, SKU, categoria, unidade, custo, preço, mínimo e ideal.
- Visualização em lista/grade e filtros de busca/status/categoria/ativos/inativos.
- Cadastro de saldo inicial convertido em movimento de estoque.
- Ajustes, entrada/saída e cálculo de custo médio ponderado nos movimentos suportados.
- Importação/exportação de CSV e importação de catálogo XML Nexora disponível; o sistema reporta erros de importação. O XML de catálogo usa `<catalogoProdutos>` com elementos `<produto>`; veja `produtos_teste.xml`.
- Saldo não deve ser digitado diretamente como se fosse uma movimentação. Estoque negativo fica bloqueado por padrão.
</details>

<details>
<summary><strong>Clientes e Fornecedores</strong></summary>

- Cadastro compartilhado: um parceiro pode ser cliente, fornecedor ou ambos.
- Validação matemática local de dígitos verificadores de CPF e CNPJ. CPF válido matematicamente não significa situação regular na Receita Federal.
- **CNPJ alfanumérico:** o cadastro aceita 14 caracteres, com 12 posições iniciais alfanuméricas e dois dígitos finais numéricos. A validação usa módulo 11 com valor de cada caractere calculado como ASCII − 48, conforme o [manual oficial da Receita Federal](https://www.gov.br/receitafederal/pt-br/centrais-de-conteudo/publicacoes/documentos-tecnicos/cnpj/manual-dv-cnpj.pdf/view). A Receita Federal informou que a emissão de CNPJs alfanuméricos começou progressivamente em julho de 2026 e publicou a geração do primeiro em 31/07/2026 ([comunicado oficial](https://www.gov.br/receitafederal/pt-br/assuntos/noticias/2026/julho/receita-federal-gera-o-primeiro-cnpj-em-formato-alfanumerico)).
- Consulta de CEP pelo **ViaCEP** (`https://viacep.com.br/ws/{CEP}/json/`), que preenche logradouro, bairro, cidade e UF quando há correspondência. CEP deve ter 8 dígitos; se a API falhar, os campos permanecem editáveis.
- Consulta pública de CNPJ pela **BrasilAPI** (`https://brasilapi.com.br/api/cnpj/v1/{CNPJ}`) para pré-preenchimento de dados empresariais, conforme disponibilidade e limites de serviço. Confirme os dados com o responsável antes de salvar; não trate o resultado como certidão fiscal.
- A aplicação não consulta a situação cadastral oficial do CPF por uma API pública gratuita sem credenciais. O serviço oficial de Consulta CPF do Serpro requer contratação/credenciais e tem preço de acordo com consumo; veja [o serviço oficial do Gov.br](https://www.gov.br/pt-br/servicos/obter-solucao-de-consulta-de-dados-de-cadastro-de-pessoa-fisica-cpf) e [aviso sobre Consulta CPF v3](https://centraldeajuda.serpro.gov.br/duvidas/pt/avisos/avisoconsultacpfv3/).
</details>

<details>
<summary><strong>Entrada de Notas</strong></summary>

- Entrada manual com revisão de fornecedor, número, série, itens e valores.
- Leitura de XML NF-e para pré-preenchimento quando o XML segue a estrutura reconhecida pelo leitor da aplicação.
- Conferência exige fornecedor e vínculo de produtos; fórmula de total com tolerância de R$ 0,05.
- Ao confirmar, cria movimentos de estoque e títulos a pagar vinculados à nota. Estorno cria movimentos inversos e mantém o histórico nos casos suportados.
- Leitura de PDF/imagem por OCR, leitura de XLSX, processamento em fila e retenção fiscal em storage de servidor **não** estão implementados. A leitura automática exige conferência humana.
</details>

<details>
<summary><strong>Financeiro e conciliação</strong></summary>

- Criar e editar títulos a pagar/a receber; pesquisar e filtrar a lista.
- Baixar parcialmente ou totalmente, com método e conta; cancelar títulos sem baixas no fluxo permitido.
- A conta local selecionada atualiza seu saldo quando uma baixa é registrada.
- Importação OFX/CSV para extratos e sugestões de conciliação estão disponíveis conforme o formato reconhecido. A sugestão não equivale a conciliação automática: confirme o par manualmente.
- Baixa em lote permite selecionar um ou vários títulos elegíveis, sem exigir marcar todos. Cada lote precisa ser homogêneo (somente pagar ou somente receber); títulos já pagos/cancelados ou sem saldo elegível são ignorados ou bloqueados conforme a tela. O usuário confirma a baixa na janela do lote.
- Fechamento contábil formal, DRE fiscal/contábil completa, transferência entre contas e regras contábeis abrangentes não devem ser presumidos.
</details>

<details>
<summary><strong>Relatórios e Auditoria</strong></summary>

- Relatórios: impressão de somente o conteúdo do relatório em janela própria; usar “Salvar como PDF” na caixa de impressão do navegador. Exportação Excel XML (SpreadsheetML) com várias planilhas, que pode ser aberta no Excel.
- Gráfico “Valor em estoque por categoria” usa layout responsivo em largura total, com legenda abaixo.
- Auditoria: download CSV ou Excel XML e impressão isolada/Salvar como PDF.
- Backup/restore JSON e personalização de nome, slogan, cor e tema. Eventos de auditoria são salvos no estado local do navegador e podem ser exportados.
- O log local não é imutável: um usuário com acesso ao navegador pode alterar ou excluir o armazenamento. Não o use como trilha de auditoria oficial.
</details>

<details open>
<summary><strong>PDV / Frente de Caixa e leitores de código de barras</strong></summary>

O PDV foi acrescentado nesta edição. É uma frente de caixa local para homologação e operações simples em **um único navegador/perfil**.

- **Leitor de código de barras:** compatível com leitores USB ou Bluetooth configurados como *HID keyboard* / teclado (também chamado *keyboard wedge*). O leitor digita o código no campo do scanner. Configure o sufixo para enviar **Enter** depois do código.
- **Localização do produto:** usa EAN/GTIN ou SKU cadastrado em **Estoque → Produtos**. O código precisa existir no cadastro do cliente; os códigos de exemplo são fictícios.
- **Digitação manual:** o campo de busca permite localizar por nome, SKU e EAN; clicar no cartão do produto adiciona ao carrinho.
- **Carrinho:** adiciona quantidades, aumenta/diminui unidades, remove itens, calcula subtotal, desconto percentual geral e total.
- **Validações:** produto inativo não é vendido; saldo insuficiente bloqueia a inclusão/finalização, a menos que a opção local de estoque negativo tenha sido habilitada. A disponibilidade é conferida novamente ao finalizar.
- **Recebimento à vista:** registra o recebimento local na conta/caixa selecionada, atualiza seu saldo e cria título do tipo “receber” com status Pago.
- **Venda a prazo:** gera um título de contas a receber com vencimento informado. O título segue o fluxo normal do Financeiro para uma futura baixa.
- **Integrações no caixa:** o PDV **não cobra cartão, não chama TEF, não fala com maquininha, não confirma PIX bancário e não emite NFC-e/NF-e/SAT**. O meio de pagamento é registrado pelo operador; confirme a transação no dispositivo/serviço externo separadamente.
- **Comprovante:** cada venda tem um comprovante de **não fiscal** imprimível. A janela de impressão aceita impressora comum ou térmica com driver instalado; selecione o papel disponível (por exemplo, 80 mm, conforme a impressora). Permita pop-ups para a janela de impressão.
- **Histórico e estorno local:** permite consultar e exportar vendas e cancelar uma venda concluída com motivo obrigatório. O estorno repõe o estoque, reverte o saldo da conta local em venda à vista, cancela o título relacionado e grava auditoria. Isso **não** desfaz transações reais no banco/adquirente/maquininha nem cancela documento fiscal externo.
- **Atalhos:** `F2` foca o leitor; `F4` abre a finalização; `Esc` limpa a busca do catálogo quando ela estiver focada.

### Configurar o scanner físico

1. Conecte o leitor USB ou emparelhe o Bluetooth com o Windows.
2. No manual do fabricante, selecione modo **USB HID Keyboard** (ou teclado Bluetooth), layout compatível com o computador e sufixo **Enter/CR**. O procedimento exato depende do modelo do leitor.
3. Abra o PDV e clique em **Focar leitor** (ou pressione `F2`).
4. Cadastre cada produto com seu SKU e, se usar EAN, preencha o campo **EAN/GTIN** com o código real da etiqueta.
5. Bipe um produto de teste. O nome deve aparecer no carrinho; faça uma venda de homologação e confira Estoque, Financeiro e Histórico de vendas.

**Importante:** não existe acesso especial do browser ao scanner nesse modo; ele funciona como teclado. Leitores que operam somente por protocolo serial proprietária ou câmeras de celular não estão abrangidos. O campo `inputmode="none"` evita que alguns dispositivos móveis abram o teclado virtual, portanto prefira computador com leitor HID para o caixa.

### Roteiro rápido de homologação do PDV

- Cadastre um produto de teste com estoque conhecido e EAN exclusivo.
- Bipe duas vezes e confirme que a quantidade no carrinho é 2.
- Aplique 10% de desconto e confira o total centavo a centavo.
- Faça uma venda em dinheiro com valor recebido superior ao total e valide o troco.
- Confira o saldo de estoque, o saldo da conta, o título financeiro e o histórico de vendas.
- Imprima o comprovante em papel de teste; confira o tamanho e a identificação “COMPROVANTE NÃO FISCAL”.
- Faça outra venda a prazo e confirme a criação do título pendente com vencimento.
- Estorne uma venda fictícia com motivo e valide a reposição de estoque, reversão de saldo e status Cancelada.
- Tente vender item com saldo zero; a finalização deve ser impedida.

</details>



## Colaboradores e permissões por página/ação

A página **Colaboradores** permite cadastrar nome, e-mail local, senha inicial, perfil base e status. Os perfis iniciais incluem Administrador, Gestor, Financeiro, Estoquista, Vendedor, Somente leitura e Personalizado. A matriz detalhada permite ativar/desativar “Visualizar página” e ações como criar, editar, inativar, ajustar estoque, baixar títulos, conciliar, exportar e conceder permissões. O menu não exibe páginas sem permissão, e os handlers locais rejeitam ações sem a chave de permissão correspondente.

Um gestor não pode delegar uma permissão que não possui. A conta de administrador principal da demonstração não pode ser inativada. Ao editar um colaborador sem permissão para alterar status, o valor atual é preservado. Essas regras são uma barreira de interface para testes locais: em produção, é obrigatório reproduzir as checagens na API e validar a identidade do usuário em cada requisição.

## Correções do Financeiro nesta versão

- Abas Contas a pagar e Contas a receber filtram os títulos pelo tipo selecionado; busca, status e vencimento são combinados.
- Baixa individual valida data, forma, conta ativa, saldo aberto, juros, multa e permissão de desconto.
- Baixa em lote liquida integralmente cada título selecionado e aceita um subconjunto de qualquer tamanho (um, vários ou todos), desde que todos sejam do mesmo tipo por operação.
- Histórico de baixas preserva pagamentos estornados; gráficos e conciliação desconsideram baixas estornadas.
- A conciliação pode ser desfeita com permissão antes de estornar uma baixa, sem apagar o histórico de pagamento.
- Exportação CSV respeita os filtros atualmente aplicados.

## Estoque e parceiros

- O detalhe do produto mostra data/quantidade da última entrada e da última saída com base nos movimentos gravados. O modal de detalhe não oferece excluir nem movimentar; essas operações não são expostas ali.
- Clientes e Fornecedores usam duas abas dedicadas, sem aba “Todos”; um mesmo parceiro pode estar marcado para os dois perfis. O modal de parceiro é organizado por identificação, endereço, condição comercial e status.

## Atualizações da versão 1.2.3

- **Menu:** “Estoque” aparece como **Produtos**; “Entrada Rápida” aparece como **PDV / Entrada**. O cartão “Banco local do navegador” foi removido da parte inferior da lateral.
- **Scanner com código desconhecido:** ao bipar um código não cadastrado no PDV/Vendas ou em PDV / Entrada, o sistema mostra uma notificação e abre o modal de produto novo com o campo EAN ou SKU pré-preenchido. Depois de salvar, confira os dados e o estoque antes de concluir a venda/entrada.
- **Validade:** o sino identifica produtos vencidos e itens a vencer em até 30 dias. Itens vencidos e os que vencem em até 7 dias são sinalizados como críticos. As notificações são calculadas a partir dos dados locais de produto.
- **Limpar notificações:** o botão “Limpar notificações” no painel do sino dispensa as notificações visíveis. Se a condição do alerta mudar (por exemplo, a data/lote for atualizada) a identificação do aviso pode mudar e ele poderá aparecer novamente.
- **Perfil:** clique no seu nome/foto no canto superior para editar nome, foto e bio opcional. A imagem é reduzida antes de armazenar no navegador; nome, foto e bio são mostrados na página Colaboradores.
- **Armazenamento:** as fotos e preferências ficam na base local deste navegador/perfil. Exporte backup JSON regularmente. Não é armazenamento sincronizado entre computadores.

### Uso com leitores de código de barras

Configure o leitor como teclado HID/Keyboard Wedge e configure o sufixo Enter. Ao abrir o PDV, o campo de leitura recebe foco automaticamente. Um código desconhecido abre o cadastro do produto, pré-preenchendo EAN se parecer código numérico com 8–14 dígitos; caso contrário, pré-preenche SKU. Revise SKU, nome, preço e estoque antes de salvar. Se cadastrar um item pelo fluxo de venda com saldo zero e sem permissão para estoque negativo, o item não será adicionado à venda até haver saldo disponível.

## 4. Onde os dados ficam

A aplicação usa **IndexedDB** como armazenamento principal e tenta `localStorage` como fallback. Quando ambos são bloqueados, a interface avisa que o modo se tornou volátil e que o conteúdo pode se perder ao fechar a página.

| Situação | Onde fica o estado | Compartilhado entre máquinas? |
|---|---|---|
| Mesmo navegador, mesmo perfil e mesma origem (por exemplo, localhost) | Armazenamento local do navegador | Não é compartilhado por rede; é local a esse perfil/origem. |
| Outro perfil do navegador ou outro navegador | Outro espaço de armazenamento | Não. |
| Outra máquina cliente | Armazenamento próprio daquela máquina | Não. |
| Página estática publicada na web | Armazenamento local do navegador de cada visitante | Não há sincronização central automática. |
| Backend e banco central de produção (não incluídos) | Banco no servidor | Sim, segundo as permissões definidas no backend. |

**Atenção:** o sistema é local-first, mas IndexedDB não é um arquivo `.sqlite` que você pode simplesmente copiar da pasta do projeto. Faça backup pela ação do próprio Nexora. Limpar os dados do navegador, usar modo privado ou trocar origem/perfil pode tornar os dados inacessíveis. Mantenha mais de uma cópia do backup JSON, em local seguro e offline. A exportação JSON não é criptografada automaticamente.

## 5. Backup e restauração

1. Faça login.
2. Clique no ícone de download no topo ou use a ação **Exportar backup**.
3. Guarde o JSON com data no nome, por exemplo `nexora-backup-2026-10-27.json`.
4. Mantenha cópia em pelo menos outro dispositivo/volume protegido.
5. Para restaurar, use **Importar backup**, escolha um JSON exportado previamente e revise a confirmação.
6. Para validar o processo, restaure primeiro em um perfil de navegador de teste. Não experimente com a única cópia existente.

O backup contém dados operacionais e pode incluir informações pessoais e financeiras. Trate-o como dado confidencial. Não o envie por canais públicos.

## 6. Personalização por cliente

A personalização de marca foi concentrada para facilitar a criação de uma cópia para cada cliente.

<details open>
<summary><strong>Mapa de personalização</strong></summary>

| O que mudar | Onde localizar no `index.html` | Como personalizar |
|---|---|---|
| Nome padrão | Objeto JavaScript `CONFIG`, perto do início do script | Troque `appName: 'Nexora ERP'` pelo nome comercial. |
| Frase curta | `CONFIG.tagline` | Troque pela frase do cliente. |
| E-mail de suporte | `CONFIG.supportEmail` | Coloque um endereço real, se o projeto vier a usá-lo. |
| Cor primária | `CONFIG.brandColor` e token CSS `--brand` dentro de `:root` | Use hex `#RRGGBB`. Altere também `brandHover` e `--brand-hover`. |
| Logo | Função JavaScript `brandMark(size=36)` | Substitua o SVG interno pela marca licenciada/autorizada do cliente. |
| Tema padrão | `CONFIG.defaultTheme` e variáveis CSS `:root` | Defina `light` ou `dark` e teste contraste/foco. |
| Nome exibido na sessão de dados | Tela Configurações | Essa alteração grava no estado local atual; não substitui a mudança do `CONFIG` para novas instalações. |
| Limite de arquivo | `CONFIG.maxUploadBytes` | Aumentar o limite exige avaliar memória, segurança e parsing; não é só uma alteração visual. |
| Regras de margem/estoque/juros | Tela Configurações e estado local | Configure e teste com dados fictícios antes de usar. |

</details>

### Fluxo seguro para personalizar

- [ ] Duplique a pasta inteira para cada cliente.
- [ ] Troque `CONFIG.appName`, `tagline`, `supportEmail` e cores.
- [ ] Ajuste o SVG na função `brandMark()`.
- [ ] Atualize o `<title>`, a meta description e os textos fixos que tenham o nome Nexora.
- [ ] Teste em desktop e mobile, principalmente contraste de texto, status e botões.
- [ ] Gere um backup de teste, restaure-o em um perfil separado e confirme a persistência.
- [ ] Mantenha uma versão-base sem customizações para comparar correções.

> A aplicação pode guardar o nome e a cor da marca nas Configurações do navegador. Para entregar clientes diferentes, o ideal é gerar uma cópia/fork de código por cliente ou introduzir um cadastro real de organização no backend. Não dependa de uma configuração local para separar dados de empresas diferentes.

## 7. Usar em máquinas dos clientes

### Opção A: demonstração local em cada computador

1. Copie a pasta `Nexora_ERP` para o computador cliente.
2. Instale Python 3 e abra `INICIAR_LOCAL.bat`.
3. Use o navegador naquela mesma máquina.
4. Oriente o cliente a exportar backup periodicamente e a não limpar dados do navegador.

Cada instalação terá banco de navegador independente. **Um operador na máquina A não verá dados da máquina B.** Esse modo serve para demonstração, avaliação, teste ou uso individual sem dados sensíveis.

### Opção B: instalar como aplicativo desktop

O pacote inclui `desktop-app/` com Electron, um alvo para EXE portátil e um script para instalador NSIS. Para compilar, execute `GERAR_EXECUTAVEL_WINDOWS.bat` ou `GERAR_INSTALADOR_WINDOWS.bat` num Windows com Node.js LTS, npm e internet. O ZIP-fonte **não contém o `.exe` já compilado**. Para distribuição comercial, ainda avalie assinatura digital, atualizações, backup e testes de instalação.

### Opção C: vários computadores compartilhando o mesmo negócio

Não abra o mesmo arquivo HTML em cada computador esperando que compartilhem IndexedDB. Para compartilhar dados, é necessário um servidor de aplicação na rede ou na internet com API autenticada e banco central. Uma alternativa arquitetural é API + PostgreSQL no servidor, ou SQLite acessado exclusivamente por um único serviço local em rede pequena. **Não** coloque um arquivo SQLite em pasta de rede para vários navegadores escreverem nele diretamente.

## Instaladores desktop Windows e Linux (versão 1.3.3)

O projeto usa Electron Builder para gerar pacotes por sistema operacional. A configuração oferece NSIS/EXE portátil no Windows e AppImage/DEB no Linux, formatos documentados pelo electron-builder. (Consulte também a documentação oficial do [electron-builder: alvos](https://www.electron.build/v26/docs/targets/) e [Linux](https://www.electron.build/v26/docs/linux/).)

### Requisitos comuns

- Node.js LTS 20 ou superior com npm.
- Internet na primeira compilação para baixar Electron e as dependências.
- Espaço livre para baixar e empacotar Chromium/Electron; os arquivos finais são salvos em `desktop-app/dist/`.
- Recomenda-se compilar cada plataforma no próprio sistema: Windows no Windows; Linux em Linux x64 ou WSL2. Use pastas de trabalho separadas entre os sistemas e não compartilhe `node_modules` de Windows e Linux.

### Windows x64

- Dê dois cliques em `GERAR_INSTALADOR_WINDOWS.bat` para gerar `desktop-app\dist\Nexora-ERP-1.3.3-Setup.exe` (instalador NSIS com escolha de pasta e atalhos).
- Dê dois cliques em `GERAR_EXECUTAVEL_WINDOWS.bat` para gerar `desktop-app\dist\Nexora-ERP-1.3.3-portable.exe` (sem instalação tradicional).

### Linux x64

No Linux (ou terminal WSL2), execute na pasta raiz extraída: `chmod +x GERAR_INSTALADOR_LINUX.sh` e depois `./GERAR_INSTALADOR_LINUX.sh`. O script gera AppImage (arquivo único, sem instalação tradicional) e pacote DEB (Debian/Ubuntu/Mint). No Windows com WSL2 configurado, também pode executar `GERAR_INSTALADOR_LINUX_WSL.bat`; exige que Node.js LTS e npm estejam instalados dentro do Ubuntu/WSL, não apenas no Windows. Para builds mais rápidos no WSL, copie o projeto para o sistema de arquivos Linux (por exemplo, `~/nexora-build`) antes de compilar. Para Fedora/openSUSE ou outras distribuições, é possível configurar um alvo RPM adicional. A primeira execução exige internet.

### Otimização de tamanho e desempenho

A matriz de 1.400 cenários de homologação foi movida para `MATRIZ_HOMOLOGACAO_1400.md`, fora do HTML executado, mantendo a matriz documental fora do HTML executado; o HTML principal desta versão tem aproximadamente 395 KiB. A aplicação desktop inclui somente `main.cjs`, `index.html` e `package.json` dentro de ASAR e usa compressão máxima na geração dos instaladores. A janela foi ajustada para telas menores. A compressão máxima pode aumentar o tempo de build.

Electron incorpora Chromium e Node.js, portanto o instalador continuará maior e consumirá mais memória que uma aplicação nativa pequena; o tamanho real e a RAM precisam ser medidos após compilar e testar nas máquinas de destino. Se um pacote muito pequeno for prioridade absoluta, considere futuramente migrar o shell para Tauri/WebView — isso exige revalidar impressão, scanner, armazenamento e distribuição.

**Os dados são locais ao perfil do aplicativo e não sincronizam automaticamente entre computadores.** O ZIP-fonte não contém binários compilados; use os scripts para produzi-los.

## 8. Publicar na web

### Importante antes de publicar

Há duas coisas diferentes: **hospedar a interface** e **hospedar o banco de dados**. Este `index.html` pode ser publicado como site estático, mas seus dados continuam no navegador de cada visitante. Isso não cria usuários reais, sincronização, backup de servidor ou controle de permissões. Não publique esta demonstração com promessa de ERP multiusuário nem preencha com dados de clientes reais.

### Método 1: Cloudflare Pages (site estático de demonstração)

A documentação oficial aceita um site HTML estático sem framework e informa que o arquivo `index.html` deve estar na raiz do diretório de saída: [Cloudflare Pages — Static HTML](https://developers.cloudflare.com/pages/framework-guides/deploy-anything/).

1. Crie um repositório Git com `index.html` na raiz.
2. Entre no painel da Cloudflare e acesse **Workers & Pages**.
3. Crie uma aplicação Pages e conecte o repositório.
4. Para este HTML sem build, configure o comando de build conforme a documentação atual (normalmente `exit 0`) e diretório de saída `.`/raiz do projeto, conforme as opções apresentadas.
5. Faça o deploy e abra a URL de pré-visualização.
6. Teste os recursos locais em cada dispositivo e confirme que os dados não sincronizam entre visitantes.

### Método 2: Vercel (site estático de demonstração)

A Vercel documenta deploy conectado a Git e deploys de produção/preview: [Vercel — Deployments](https://vercel.com/docs/deployments). Importe um repositório que contenha o `index.html` no local esperado e confira as configurações de build/output no painel. A interface publicada continuará sem banco central.

### Método 3: GitHub Pages

Use um repositório GitHub contendo `index.html` na raiz, ative Pages nas configurações de publicação e teste a URL do repositório. Para instruções atuais, consulte a documentação oficial do GitHub Pages: https://docs.github.com/pages. Este é um site estático, sem API/servidor de dados.

### Método 4: publicar um ERP multiusuário de verdade

Isso não pode ser concluído somente publicando este arquivo. Prepare frontend/backend, banco, domínio, HTTPS, autenticação segura, backups e monitoração. Para uma VM própria, Oracle Cloud possui uma camada Free com condições e limites sujeitos à disponibilidade; confira a página oficial atual antes de contar com custo zero: [Oracle Cloud Free Tier](https://www.oracle.com/br/cloud/free/). Uma VPS paga previsível também pode ser mais adequada para serviço comercial.

Não exponha o comando `python -m http.server` da instalação local à internet. Ele serve somente para visualizar arquivos estáticos; não possui as medidas de segurança, autenticação ou API necessárias para gerir dados de clientes.

## 9. Arquitetura para produção multiusuário

O documento de estruturação sugere uma arquitetura em camadas. Para preservar a ideia do PDF e não fingir que ela já existe neste arquivo, o caminho recomendado é:

```text
Navegador (Next.js / React / TypeScript)
            | HTTPS / API REST
            v
API NestJS por módulos + validação + autorização
            | Prisma ORM / migrations
            v
PostgreSQL 16 (banco central; transações)
            |                  |
       jobs/worker       storage privado de arquivos
      (Valkey/BullMQ)       (XML/PDF/anexos)
```

Camadas e tarefas necessárias:

- **Banco:** PostgreSQL com migrações e constraints; dinheiro em `NUMERIC(14,2)`; não usar `float` para valores financeiros.
- **Isolamento por empresa:** `empresa_id` em registros do negócio e checagem em cada rota; não confiar no filtro da interface.
- **Autenticação:** hash seguro de senha com Argon2id, sessão/token com ciclo de vida e revogação, cookies seguros, rate limit, reset de senha e verificação de e-mail em backend.
- **Permissões:** RBAC validado no servidor em todas as operações. Esconder botão no front-end não é controle de acesso suficiente.
- **Transações:** confirmar entrada da nota deve gravar a nota, movimentos de estoque e títulos financeiros em transação atômica.
- **Arquivos:** upload privado, validar tipo real/tamanho/hash, guardar originais com retenção definida e backup. XML é preferível à extração OCR quando disponível.
- **Jobs demorados:** parsing/OCR, notificações e alertas rodam fora de requisições longas, com estado, retries e observabilidade.
- **Publicação:** Docker Compose, proxy reverso como Caddy, HTTPS válido, firewall, logs e alertas.
- **Backup:** backup diário criptografado para local separado e teste periódico de restauração, não apenas verificar se o arquivo existe.

O frontend atual é um protótipo de referência para migrar layout e fluxos. A lógica do arquivo único precisa ser reescrita/refatorada em módulos com validação central no backend antes de receber dados reais.

## 10. Validação e checklist de homologação

### Validação realizada para a versão 1.1.0

Testes automatizados no Chromium com respostas controladas/mock para dependências externas:
- Menu lateral recolhido no desktop e aberto/fechado por botão/overlay no mobile.
- Seleção parcial de título habilita a baixa; seleção de um elemento altera o contador sem exigir selecionar toda a tabela.
- ViaCEP/BrasilAPI mapeados e preenchimento dos campos testados usando respostas simuladas; isso não equivale a um teste de disponibilidade ao vivo dos serviços públicos.
- Validação de dígitos de CPF/CNPJ, incluindo exemplos de documentos matematicamente válidos.
- Entrada Rápida: leitura simulada por SKU, inclusão no carrinho, confirmação, movimento de estoque e recálculo de custo médio ponderado.
- Relatório: gráfico responsivo e legenda abaixo; impressão abre documento separado sem a barra lateral; exportação XML Excel gera planilhas. Auditoria exporta CSV/XML e possui impressão isolada.
- Em viewport 390 px, o relatório não gera rolagem horizontal. Os fluxos testados não registraram erros JavaScript no console.

**Homologação ainda necessária:** consultar os endpoints públicos ao vivo em rede real, abrir a caixa “Salvar como PDF” no Windows, testar scanners físicos com Enter e revisar os dados com um usuário do cliente. Nenhum teste automatizado garante funcionamento em todo navegador, rede ou hardware.

- [x] Extração do primeiro bloco JavaScript do HTML e validação de sintaxe com `node --check`.
- [x] Verificação estática das páginas de colaboradores, matriz de permissões, tabs do financeiro, baixa em lote, estorno e conciliação.
- [x] Testes de lógica em Node: modelos de permissão, filtros Pagar/Receber, bloqueio de baixa em lote mista, baixa em lote homogênea com saldo atualizado, desfazer conciliação sem apagar o pagamento e proteção de pesquisa global conforme permissão.
- [x] Inclusão de inicializador Python que define explicitamente MIME `text/html; charset=utf-8`, escolhe porta pelo bind do próprio servidor e envia cabeçalhos para evitar cache do HTML antigo.
- [ ] Teste visual interativo desta revisão em Chrome/Edge e no hardware do cliente: precisa ser repetido com o `INICIAR_LOCAL.bat`; a execução visual automatizada não pôde ser confirmada neste ambiente.

**Importante:** validação sintática e estática não prova que todos os formulários e cálculos funcionam em todas as combinações. O teste visual real continua necessário, especialmente para cadastrar colaboradores, negar uma página a um perfil, registrar baixas, desfazer conciliação e emitir comprovantes.

### Checklist manual

- [ ] Validar o cadastro de produto com SKU repetido e documento inválido.
- [ ] Testar saída acima do saldo e confirmar bloqueio do estoque negativo.
- [ ] Calcular manualmente o custo médio após uma nova entrada.
- [ ] Cadastrar CPF/CNPJ válidos e inválidos e testar parceiro como cliente e fornecedor.
- [ ] Criar nota de teste, alterar quantidades/valores, testar divergência maior que R$ 0,05 e confirmar que não lança.
- [ ] Confirmar nota válida e conferir movimentos, títulos e histórico.
- [ ] Testar baixa parcial, baixa total, cancelamento de título sem baixa e tentativa de cancelar título com baixa.
- [ ] Importar OFX/CSV de teste, conferir duplicidade e confirmar conciliação manualmente.
- [ ] Exportar backup JSON, restaurar em perfil de teste e comparar dados.
- [ ] Repetir fluxos essenciais em 1440 px e viewport móvel de aproximadamente 375 px.
- [ ] Atualizar o arquivo, fazer backup antes e confirmar que a versão nova continua lendo o estado antigo.

O `index.html` contém uma matriz documental de 1.400 cenários manuais em comentário HTML para orientar regressão. Ela é **roteiro planejado**, não um conjunto de 1.400 testes executados. Use `CHECKLIST_HOMOLOGACAO.md` para anotar resultados observados.

## 11. Limitações conhecidas

| Área | Estado desta versão |
|---|---|
| UI das seis telas principais | Implementada para testes locais, com visual responsivo. |
| Persistência | IndexedDB/localStorage do navegador, por perfil e origem. |
| Autenticação/contas | Interface de demonstração local; sem segurança de servidor. |
| Multiempresa/permissões | Não implementados como isolamento real em backend. |
| Estoque e custo médio | Fluxos locais de movimento e cadastro para homologação. |
| Parceiros e CPF/CNPJ | Validação matemática local de CPF e CNPJ numérico/alfanumérico; consulta de CEP via ViaCEP e pré-preenchimento de CNPJ via BrasilAPI quando a fonte reconhece o documento. Situação oficial de CPF não consultada. |
| Notas | Entrada manual e leitura de XML NF-e compatível; não emite NF-e. PDF/imagem/OCR/XLSX em processamento fiscal não implementados. |
| Financeiro | Títulos, baixas individuais e em lote para qualquer subconjunto elegível do mesmo tipo e contas locais; não é sistema contábil certificado. |
| Conciliação | Importação de formatos reconhecidos e sugestões com confirmação manual nos fluxos disponíveis. |
| Vendas/PDV | Carrinho, scanner tipo teclado via EAN/SKU, desconto, venda à vista/a prazo, estoque, título financeiro, histórico, impressão de comprovante não fiscal e estorno local. Não inclui TEF, maquininha, cobrança real de cartão, confirmação bancária de PIX ou documento fiscal. |
| E-mail/Google OAuth/reset/2FA | Não implementados. |
| Auditoria | Local e editável por quem controla o navegador; pode imprimir e exportar CSV/Excel XML; não é imutável. |
| Backup automático de servidor | Não implementado. Exportação JSON é manual. |
| Exportação de relatório/auditoria | PDF via janela de impressão do navegador (escolha “Salvar como PDF”) e Excel XML SpreadsheetML; não é geração de PDF por uma biblioteca embutida. |
| API e banco central | Não incluídos no HTML. |
| Teste automatizado completo | Smoke test de fluxos selecionados, não suíte integral. |

## 12. Segurança, LGPD e fiscal

- Não utilize dados pessoais reais em demonstração pública; use dados fictícios.
- Não use esse login local como controle de acesso; não há validação de permissão em API porque não existe API nesta edição.
- Antes de uso comercial, implementar autorização por operação, segregação por empresa, expiração/revogação de sessão, registros de auditoria no servidor, criptografia de backups e controle de acesso a arquivos.
- Documentar finalidade/base legal, retenção, atendimento a titulares, processo de anonimização e minimização de dados pessoais. Obter orientação especializada para LGPD.
- O fluxo de entrada/conferência de XML não equivale a emitir NF-e/NFC-e nem a enviar dados à SEFAZ. Certificado digital, regras fiscais estaduais e validação do contador ficam fora deste HTML.
- Requisitos legais e fiscais podem mudar. Confirmar regras atuais com profissional contábil/jurídico e com documentação oficial antes de produção.

## 13. Solução de problemas

<details>
<summary><strong>A tela avisa que o armazenamento persistente está bloqueado</strong></summary>

Use `INICIAR_LOCAL.bat` (Windows) ou execute `python iniciar_local.py`. O script imprime o endereço completo com a porta escolhida automaticamente e abre o navegador. Feche a janela do servidor somente quando terminar. Não use navegação anônima para dados que precisem persistir.
</details>

<details>
<summary><strong>O navegador mostra códigos HTML em vez da tela do sistema</strong></summary>

Isso normalmente acontece quando o arquivo é aberto pelo visualizador de anexos, dentro do ZIP ou por um caminho que não o entrega como página HTML. Feche essa aba, extraia o ZIP para uma pasta e execute `INICIAR_LOCAL.bat`. O novo `iniciar_local.py` serve a página com `Content-Type: text/html; charset=utf-8`. Na barra de endereço, use a URL `http://127.0.0.1:PORTA/index.html` exibida na janela preta; não use `view-source:` e não cole o conteúdo do arquivo na barra. Mantenha o terminal aberto durante o uso.
</details>

<details>
<summary><strong>O navegador não abre em localhost</strong></summary>

Confirme que Python 3 está instalado. O inicializador escolhe uma porta livre automaticamente; use o endereço exibido no terminal. O servidor só deve escutar em `127.0.0.1` para uso local. Se o navegador não abrir automaticamente, copie o endereço impresso na janela e cole no Chrome/Edge.
</details>

<details>
<summary><strong>Os dados sumiram</strong></summary>

Verifique se está usando o mesmo navegador, perfil e origem. `file://`, `http://localhost`, `http://127.0.0.1` e um domínio publicado podem ter armazenamentos diferentes. Confira se estava em modo privado e se os dados do site foram apagados. Se não houver backup, os dados do armazenamento removido podem não ser recuperáveis.
</details>

<details>
<summary><strong>A nota não pode ser confirmada</strong></summary>

Confira fornecedor vinculado, ao menos um item ligado a produto, quantidades/preços positivos e fórmula de total: produtos + frete + impostos − desconto. A diferença precisa ficar dentro de R$ 0,05 conforme o modelo. Compare o XML original; a leitura não dispensa revisão.
</details>

<details>
<summary><strong>CSV não importa alguns registros</strong></summary>

Confira delimitador, cabeçalhos reconhecidos e codificação UTF-8. O relatório de importação indica as linhas com nome/documento ausente ou documento inválido. Não reimporte cegamente sem verificar duplicados.
</details>

<details>
<summary><strong>O cliente quer compartilhar banco entre computadores</strong></summary>

Esse não é um problema de configurar o arquivo. É necessário implementar a API e um banco central ou instalar serviço servidor local protegido. Publicar o arquivo estático não sincroniza IndexedDB.
</details>


**Scanner não adiciona o produto:** confirme se o campo do leitor tem foco, configure Enter como sufixo, confira se o código impresso corresponde ao EAN/GTIN ou SKU cadastrado e teste o leitor num editor de texto. Se o leitor apenas emite dados seriais, esta versão HID não vai interpretá-lo diretamente.

**Impressão em térmica:** instale o driver do fabricante no sistema operacional, permita pop-ups e selecione o tamanho de papel suportado na janela de impressão. O navegador não conversa diretamente com a impressora térmica nesta edição.

## 14. Roadmap sugerido

O PDV básico local entrou nesta edição; o roadmap a seguir se refere aos próximos incrementos e às integrações de produção.

1. **Revisão técnica:** separar regras, UI e persistência; cobrir cálculos com testes automatizados.
2. **Backend local/servidor:** API, schema/migrations, PostgreSQL ou serviço local com SQLite, importação transacional e gestão de erros.
3. **Autenticação e autorização:** hashing de senha, sessões, perfis, escopo de empresa e aprovação de ações sensíveis.
4. **Documentos fiscais:** parser XML mais abrangente e validado com fixtures reais anonimizadas; processamento de PDF/OCR em worker quando necessário.
5. **Financeiro robusto:** extratos reais anonimizados para testes, conciliação idempotente, estornos, recorrências e relatórios conferidos por especialista.
6. **Distribuição:** pacote desktop assinado ou deploy server com HTTPS, backup/restore, monitoração, atualização e suporte.
7. **Aceitação comercial:** QA em múltiplos navegadores, threat modeling, teste de restauração, política LGPD, homologação contábil e plano de incidentes.

---

## Referências oficiais para hospedagem

- Cloudflare Pages, estático HTML: https://developers.cloudflare.com/pages/framework-guides/deploy-anything/
- Vercel Deployments: https://vercel.com/docs/deployments
- GitHub Pages: https://docs.github.com/pages
- Oracle Cloud Free Tier (condições e limites atuais): https://www.oracle.com/br/cloud/free/

Planos, limites gratuitos, disponibilidade e termos de fornecedores mudam com o tempo. Verifique as condições no dia do deploy.


## Histórico 1.2.0 — Produtos, PDV e aplicativo desktop

Esta versão acrescenta lote, validade e imagem no cadastro de produtos; ID imutável e busca por ID; modal de produto que só fecha pelo botão **Fechar** (ou depois de salvar); máscaras e marcação de campos obrigatórios. O PDV abre em modo exclusivo, foca o campo do scanner, apresenta apenas os itens do carrinho e mostra atalhos mais visíveis. A finalização passa por uma conferência de itens, quantidades, descontos e pagamentos; depois é possível escolher se deseja imprimir.

**Importante sobre cupom fiscal:** a impressão desta edição é de comprovante não fiscal e usa uma referência interna da venda. Não cria um número de NF-e/NFC-e nem afirma autorização da SEFAZ. Para cupom fiscal verdadeiro, é necessária integração com um provedor fiscal autorizado e os dados/certificados aplicáveis.

### Aplicativo desktop — versão 1.3.3

A pasta `desktop-app/` contém Electron e empacota somente `main.cjs`, `index.html` e `package.json`, com ASAR habilitado. Gere os pacotes no sistema correspondente usando os scripts da raiz. Os arquivos finais são criados em `desktop-app/dist/`; o ZIP de código não contém binários já compilados.

O script Linux apaga `desktop-app/node_modules` anterior para evitar misturar dependências de outra plataforma. Para builds repetidos, isso faz o npm baixar/instalar as dependências novamente; é um trade-off por confiabilidade entre Windows/Linux. Não apague `desktop-app/dist` até copiar os artefatos finais.

Para abrir a versão HTML sem compilar o app, execute `INICIAR_LOCAL.bat`. Esse inicializador chama `iniciar_local.py`, escolhe automaticamente uma porta livre e escuta somente em `127.0.0.1`. Mantenha a janela do terminal aberta enquanto usa o ERP.

## Arquivos XML de teste (versão 1.2.1)

O módulo **Produtos** agora aceita CSV e XML do catálogo Nexora. Para testar, importe primeiro `produtos_teste.xml` em **Produtos → Importar CSV/XML**. Esse arquivo cria cinco produtos fictícios com SKU, EAN, custo, preço, lote e validade; a quantidade inicial é zero para que a entrada da nota possa demonstrar o aumento do estoque. O sistema gera o ID interno automaticamente, sem aceitar ID de fora.

Depois abra **Entrada de Notas → Importar documento** e selecione `nota_fiscal_teste_nfe.xml`. O XML contém três itens com `cProd` iguais aos SKUs do catálogo. Na revisão, selecione o fornecedor já cadastrado correspondente ao CNPJ do emitente `83.927.641/0001-13` (ou cadastre um parceiro fornecedor de teste com esse documento), depois vincule cada item aos produtos de mesmo SKU e confirme a entrada. A nota de exemplo tem produtos R$ 454,40, frete R$ 18,00, desconto R$ 5,00 e total R$ 467,40.

**Ambos os arquivos são fictícios para homologação.** O XML de nota não foi assinado nem autorizado pela SEFAZ; não tem validade fiscal e não deve ser usado para escrituração ou declaração tributária.


## Versão 1.2.3 — Perfil pessoal

Foi adicionada uma seção própria **Conta pessoal → Meu Perfil** no menu. Qualquer usuário autenticado pode abrir essa página para alterar nome de exibição, adicionar/substituir foto, remover a foto e editar uma bio opcional de até 280 caracteres. As alterações só são persistidas ao clicar em **Salvar perfil pessoal**. A foto é otimizada antes de ser salva e o nome, a imagem e a bio aparecem também no cabeçalho e na lista de Colaboradores. A edição rápida do perfil continua acessível ao clicar no chip do usuário no topo.


## Atualizações da versão 1.2.4

- Cliques fora do modal não o fecham; use o botão X, Cancelar/Fechar ou Escape (quando permitido pelo formulário).
- Formulário de parceiros sinaliza explicitamente CPF para Pessoa Física e CNPJ para Pessoa Jurídica. Ao trocar o tipo de pessoa, o campo de documento é limpo, o rótulo/placeholder e o botão de validação são atualizados.
- CPF passa por validação matemática local; a aplicação não consulta situação cadastral do CPF junto à Receita Federal. CNPJ mantém validação local e consulta BrasilAPI.


## Regra de estoque na versão 1.2.6

O módulo independente “PDV / Entrada” foi removido do menu. Entradas de mercadorias são registradas apenas pela tela **Entrada de Notas**: importe ou cadastre a nota, confira os itens e confirme o lançamento. O saldo só muda após a confirmação da nota. Cadastro manual de produto e importação de catálogo atualizam apenas os dados mestres, sem quantidade inicial. Ajustes manuais ficam limitados a saídas/perdas/ajustes negativos.

Se um item do XML não tiver correspondência no catálogo, o cadastro do produto abre automaticamente com SKU/código, descrição, unidade, custo, EAN e NCM sugeridos. Depois de salvar, o produto é vinculado à linha da nota; quando todos os itens estiverem cadastrados/vinculados, a conferência da nota é reaberta. O estoque permanece zerado até confirmar a nota.

O menu lateral está compacto e sua barra de rolagem fica visualmente oculta; a rolagem com roda/trackpad continua funcionando.

## Regra de entrada de estoque (1.2.6)

O menu **PDV / Entrada** foi removido. Produtos novos e importações de catálogo não adicionam quantidades ao saldo. Para receber mercadoria, vá a **Entrada de Notas**, importe o XML ou cadastre a nota, vincule produtos e confirme a conferência. Se um item XML ainda não existe no catálogo, o Nexora abre o modal de cadastro preenchido com os dados disponíveis; ao salvar, o produto é vinculado à linha e a conferência continua. O estoque só muda quando a nota inteira é confirmada.

A antiga rotina técnica de recebimento manual também está bloqueada, e o controle central de movimentos rejeita aumentos de saldo fora de nota confirmada. Estornos de venda podem repor unidades como reversão auditada, não como recebimento novo.
