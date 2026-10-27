# Chef's Shelf

## Sobre o projeto

O Chef's Shelf é um aplicativo mobile desenvolvido em Flutter como projeto acadêmico do curso de Desenvolvimento de Sistemas do SENAI.

O aplicativo permite que os usuários pesquisem receitas, visualizem seus detalhes e salvem suas receitas favoritas. A aplicação utiliza o Firebase para autenticação de usuários e armazenamento dos favoritos, permitindo que cada usuário tenha sua própria lista de receitas.

## Objetivo

Desenvolver um aplicativo mobile que facilite a busca e a organização de receitas culinárias, aplicando conhecimentos de desenvolvimento mobile, integração com APIs externas, autenticação e armazenamento de dados em nuvem.

## Funcionalidades

- Cadastro de usuários com e-mail e senha.
- Login e autenticação de usuários.
- Pesquisa de receitas culinárias.
- Visualização dos detalhes das receitas.
- Adição e remoção de receitas favoritas.
- Armazenamento dos favoritos no Firebase Firestore.
- Separação dos favoritos por usuário.
- Persistência dos dados após fechar e abrir o aplicativo novamente.

## Tecnologias utilizadas

- **Flutter:** desenvolvimento da interface mobile.
- **Dart:** linguagem de programação.
- **Firebase Authentication:** cadastro e autenticação de usuários.
- **Cloud Firestore:** armazenamento dos favoritos.
- **TheMealDB API:** obtenção de receitas culinárias.
- **Git e GitHub:** versionamento e hospedagem do código-fonte.
- **Google Stitch:** prototipação das interfaces.

## Estrutura do projeto

```text
lib/
├── main.dart
├── firebase_options.dart
├── screens/
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── home_screen.dart
│   ├── recipe_detail_screen.dart
│   └── favorites_screen.dart
└── services/
    ├── auth_service.dart
    ├── recipe_service.dart
    └── favorite_service.dart
```

## Firebase

O Firebase é utilizado para gerenciar a autenticação dos usuários e armazenar as receitas favoritas.

O Cloud Firestore organiza os favoritos em coleções associadas ao identificador de cada usuário. Dessa forma, cada conta acessa apenas seus próprios favoritos, conforme as regras de segurança configuradas no banco de dados.

## API de receitas

O aplicativo utiliza a API TheMealDB para consultar receitas culinárias e apresentar informações como nomes, imagens e detalhes dos pratos.

Documentação da API: https://www.themealdb.com/api.php

## Como executar o projeto

### Pré-requisitos

- Flutter instalado e configurado.
- Dart instalado.
- Visual Studio Code ou outra IDE compatível.
- Emulador Android ou dispositivo físico.
- Projeto Firebase configurado.

### Instalação

Clone o repositório:

```bash
git clone https://github.com/anadoree08/chefs-shelf.git
```

Entre na pasta do projeto:

```bash
cd chefs-shelf
```

Instale as dependências:

```bash
flutter pub get
```

Verifique os dispositivos disponíveis:

```bash
flutter devices
```

Execute o aplicativo:

```bash
flutter run
```

### Configuração do Firebase

Para executar o projeto em outro ambiente, é necessário configurar um projeto Firebase e habilitar o Firebase Authentication com o método de e-mail e senha, além do Cloud Firestore.

O arquivo `firebase_options.dart` deve corresponder à configuração do projeto Firebase utilizado pela aplicação. Caso necessário, configure novamente o Firebase para a plataforma desejada seguindo a documentação oficial do FlutterFire.

Documentação: https://firebase.google.com/docs/flutter/setup

## Protótipo

O protótipo das interfaces foi desenvolvido no Google Stitch.

Acesse o projeto: https://stitch.withgoogle.com/projects/11043324647884107913

## Autoria

Projeto acadêmico desenvolvido por Ana Dore para o curso de Desenvolvimento de Sistemas do SENAI.

## Considerações finais

O Chef's Shelf aplica conceitos de desenvolvimento mobile, consumo de APIs, autenticação de usuários e armazenamento de dados em nuvem, reunindo essas funcionalidades em um aplicativo para pesquisa e organização de receitas culinárias.
